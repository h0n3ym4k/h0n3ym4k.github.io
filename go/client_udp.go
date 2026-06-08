package main

import (
	"context"
	"encoding/binary"
	"fmt"
	"log"
	"math"
	"net"
	"os"
	"syscall"
	// 💡 "time" 已經被移除，解決 "imported and not used" 編譯錯誤
)

func processTickWindows(packet []byte, cancel context.CancelFunc) {
	stockBits := binary.BigEndian.Uint64(packet[4:12])
	stockPrice := math.Float64frombits(stockBits)

	gammaBits := binary.BigEndian.Uint64(packet[20:28])
	gamma := math.Float64frombits(gammaBits)

	// 觸發閾值
	if stockPrice >= 131.00 && gamma > 1.5 {
		strikeBits := binary.BigEndian.Uint64(packet[12:20])
		strike := math.Float64frombits(strikeBits)
		askBits := binary.BigEndian.Uint32(packet[28:32])
		askPrice := math.Float32frombits(askBits)

		fmt.Println("\n================================================================================")
		log.Printf("[💥 WINDOWS TRIGGER SUCCESS] 突破系統級延遲成功觸發！")
		log.Printf("[DATA] 標的價: $%.2f | 行使價: %.1f | 期權進場價: $%.2f", stockPrice, strike, askPrice)
		fmt.Println("================================================================================")

		cancel()
	}
}

func main() {
	log.Println("[ENGINE] 啟動 Windows 10 特供非阻塞交易引擎...")

	addr, err := net.ResolveUDPAddr("udp", "127.0.0.1:9999")
	if err != nil {
		log.Fatalf("地址解析失敗: %v", err)
	}

	conn, err := net.ListenUDP("udp", addr)
	if err != nil {
		log.Fatalf("監聽失敗: %v", err)
	}
	defer conn.Close()

	// 【Windows 硬核優化 1】：利用 Windows API 將套接字強行切換為「非阻塞模式 (Non-blocking)」
	// 拒絕 Winsock 默認的線程掛起（Thread Suspend）等待，有數據立刻噴出
	fd, err := conn.File()
	if err == nil {
		defer fd.Close()
		// 設置 Windows Handle 屬性
		_ = syscall.SetNonblock(syscall.Handle(fd.Fd()), true)
	}

	// 【Windows 硬核優化 2】：極致放大接收緩衝，強制 Windows 內核將 UDP 包直通 RAM 記憶體
	_ = conn.SetReadBuffer(32 * 1024 * 1024) 

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	readBuf := make([]byte, 32)

	log.Println("[ENGINE] 進入 Windows 激進自旋鎖輪詢 (Spin-lock Polling) 模式...")

	for {
		select {
		case <-ctx.Done():
			log.Println("[ENGINE] 系統安全關閉。")
			os.Exit(0)
		default:
			// 因為設置了非阻塞，如果緩衝區沒數據，ReadFromUDP 會立刻拋出常規錯誤，不會卡死
			n, _, err := conn.ReadFromUDP(readBuf)
			if err != nil {
				// 緩衝區空，立刻自旋（Spin）進入下一次循環，壓榨單核 CPU 算力換取 0 延遲
				continue 
			}

			if n == 32 {
				processTickWindows(readBuf, cancel)
			}
		}
	}
}

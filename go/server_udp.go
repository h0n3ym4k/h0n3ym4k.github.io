package main

import (
	"encoding/binary"
	"log"
	"math"
	"math/rand"
	"net"
)

func packBinaryData(buf []byte, stock float64, ask float32) {
	copy(buf[0:4], "NVDA")
	binary.BigEndian.PutUint64(buf[4:12], math.Float64bits(stock))
	binary.BigEndian.PutUint64(buf[12:20], math.Float64bits(132.0)) 
	binary.BigEndian.PutUint64(buf[20:28], math.Float64bits(1.85))  
	binary.BigEndian.PutUint32(buf[28:32], math.Float32bits(ask))
}

func main() {
	log.Println("[EXCHANGE] 啟動 Windows 終極解鎖版 UDP 饋送源...")
	addr, err := net.ResolveUDPAddr("udp", "127.0.0.1:9999")
	if err != nil {
		log.Fatalf("解析地址失敗: %v", err)
	}

	conn, err := net.DialUDP("udp", nil, addr)
	if err != nil {
		log.Fatalf("無法綁定 UDP Socket: %v", err)
	}
	defer conn.Close()

	packetBuf := make([]byte, 32)
	stockPrice := 129.50

	log.Println("[EXCHANGE] 拒絕 Windows Ticker！切入純 CPU 裸奔推送模式...")

	// 💥 移除 time.Ticker，直接使用最暴力的 for 循環加上純算力空轉
	// 這會迫使 Windows 內核以微秒（μs）級別的極限速度噴射數據包
	for {
		stockPrice += rand.Float64()*0.05 - 0.018
		var askPrice float32 = 0.02
		if stockPrice > 130.0 {
			askPrice = 0.02 + float32(stockPrice-130.0)*1.85*0.5
		}

		packBinaryData(packetBuf, stockPrice, askPrice)
		
		_, err := conn.Write(packetBuf)
		if err != nil {
			return
		}

		// 稍微利用簡單的 CPU 矩陣空轉進行「微秒級」延遲，防止瞬間塞爆單機 Windows 網絡環回口（Loopback）
		for i := 0; i < 50000; i++ {
			_ = i * i // 純硬件級空轉
		}

		if stockPrice > 133.0 {
			log.Println("[EXCHANGE] 達到模擬收市價，完成極速噴射！")
			return
		}
	}
}

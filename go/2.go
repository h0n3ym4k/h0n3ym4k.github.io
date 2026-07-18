package main

import (
	"crypto/rand"
	"fmt"
	"html/template"
	"math/big"
	"net/http"
	"sort"
)

const (
	totalNumbers = 49
	pickNumbers  = 6
	requiredBets = 4 // $40 蚊 4 條單式
)

// CheckBalance 檢查 3大3細 且 3單3雙
func CheckBalance(nums []int) bool {
	oddCount := 0
	bigCount := 0
	for _, n := range nums {
		if n%2 != 0 {
			oddCount++
		}
		if n >= 25 {
			bigCount++
		}
	}
	return oddCount == 3 && bigCount == 3
}

// GenerateSecureBet 生成一組號碼
func GenerateSecureBet() []int {
	numsMap := make(map[int]bool)
	var nums []int
	for len(nums) < pickNumbers {
		nBig, _ := rand.Int(rand.Reader, big.NewInt(totalNumbers))
		num := int(nBig.Int64()) + 1
		if !numsMap[num] {
			numsMap[num] = true
			nums = append(nums, num)
		}
	}
	sort.Ints(nums)
	return nums
}

// BetInfo 儲存單注號碼以及它是第幾次模擬成功
type BetInfo struct {
	AttemptNo int
	Numbers   []int
}

// PageData 傳遞給 HTML 範本的資料結構
type PageData struct {
	Bets []BetInfo
}

// 內嵌的 HTML/CSS 網頁設計
const htmlTemplate = `
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>六合彩 $40 完美機率篩選器</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; text-align: center; padding: 30px; margin: 0; }
        .container { max-width: 550px; margin: 0 auto; background: white; padding: 3px 30px 30px 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        h1 { color: #2c3e50; font-size: 24px; margin-bottom: 5px; }
        .subtitle { color: #7f8c8d; font-size: 14px; margin-bottom: 25px; }
        .btn { background-color: #27ae60; color: white; border: none; padding: 12px 25px; font-size: 16px; font-weight: bold; border-radius: 6px; cursor: pointer; transition: background 0.2s; width: 100%; }
        .btn:hover { background-color: #219653; }
        .bet-list { margin-top: 25px; text-align: left; }
        .bet-row { background: #fdfefe; border: 1px solid #e0e0e0; padding: 12px; margin-bottom: 10px; border-radius: 8px; display: flex; align-items: center; justify-content: space-between; }
        .bet-meta { display: flex; flex-direction: column; width: 120px; }
        .bet-num { font-weight: bold; color: #2c3e50; font-size: 15px; }
        .bet-attempt { font-size: 11px; color: #95a5a6; margin-top: 2px; }
        .balls { display: flex; gap: 8px; }
        .ball { width: 34px; height: 34px; background: #e74c3c; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        /* 幫波波加點顏色變化 */
        .ball:nth-child(even) { background: #3498db; }
        .ball:nth-child(3n) { background: #27ae60; }
        .footer { margin-top: 25px; font-size: 12px; color: #95a5a6; }
    </style>
</head>
<body>
    <div class="container">
        <h1>條條發財飛 💰</h1>
        <p class="subtitle">嚴格篩選 [3單3雙] 及 [3大3細] 黃金比例</p>
        
        <form action="/" method="GET">
            <button type="submit" class="btn">🎲 撳個掣 · 攪出 $40 心水號碼</button>
        </form>

        {{if .Bets}}
        <div class="bet-list">
            {{range $index, $bet := .Bets}}
            <div class="bet-row">
                <div class="bet-meta">
                    <span class="text-start bet-num">注項 {{add $index 1}}</span>
                    <span class="text-start bet-attempt">第 {{$bet.AttemptNo}} 次模擬得出</span>
                </div>
                <div class="balls">
                    {{range $num := $bet.Numbers}}
                    <div class="ball">{{printf "%02d" $num}}</div>
                    {{end}}
                </div>
            </div>
            {{end}}
        </div>
        {{end}}
        
        <p class="footer">目標幾百萬 · 小賭怡情 · 量力而為</p>
    </div>
</body>
</html>
`

func main() {
	tmpl := template.New("webpage")
	tmpl.Funcs(template.FuncMap{
		"add": func(a, b int) int { return a + b },
	})
	tmpl, err := tmpl.Parse(htmlTemplate)
	if err != nil {
		panic(err)
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		data := PageData{}

		betsFound := 0
		attempts := 0

		for betsFound < requiredBets {
			attempts++
			candidate := GenerateSecureBet()
			
			if CheckBalance(candidate) {
				betsFound++
				// 將當前的 attempts 紀錄一併塞進結構體
				data.Bets = append(data.Bets, BetInfo{
					AttemptNo: attempts,
					Numbers:   candidate,
				})
			}
		}

		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		tmpl.Execute(w, data)
	})

	fmt.Println("🌐 六合彩網頁伺服器已啟動！")
	fmt.Println("👉 請打開瀏覽器輸入: http://localhost:8080")
	
	if err := http.ListenAndServe(":8080", nil); err != nil {
		fmt.Println("伺服器啟動失敗:", err)
	}
}
# S7 Vault Setup & RAG Prep List for Code Opus

**Date**: 2026-04-06
**Series**: S7 攝 — 妙法蓮華經
**Purpose**: Pre-flight checklist for Code Opus — vault population + standing RAG resources for all 12 S7 papers
**Deliverable**: New `vault-法華` populated + readiness confirmation before S7-P01 RAG execution

---

## Part 1 — Vault 狀態盤點

### ✅ 已就緒 vaults（可直接使用）

| Vault | 涵蓋典籍 | S7 用途 |
|-------|---------|---------|
| `vault-阿含` | T0001 長阿含、T0026 中阿含、T0099 雜阿含、T0125 增壹阿含 | **命題三阿含種子檢索**——全系列使用 |
| `vault-唯識` | T0676 解深密經、T0681/T0682 密嚴經、T1585 成唯識論、T1579 瑜伽師地論、T1594 攝大乘論、T1612 百法明門論 等 | **命題一三性理論依據**——P01、P02、P03 核心 |
| `vault-楞嚴` | T0945 楞嚴經 + T1799 子璿、X0275 交光 | 跨系列引用（P11 壽量品與楞嚴七處徵心可能交叉） |
| `vault-華嚴` | T0279 八十華嚴 + 相關疏 | **P12 橋接論文**——命題二收斂時需要華嚴對照 |
| `vault-般若` | T0235 金剛經、T0251 心經、T0220 大般若等 | S5 已建立；P06 化城喻與 S5-P04 筏喻交叉引用時使用 |

### ⬜ 需要新建：`vault-法華`

S7 的核心經典全部不在任何現有 vault 中。Code Opus 需要**新建 `vault-法華` 目錄**並從 CBETA 下載以下典籍的 Obsidian markdown 版本。

---

## Part 2 — `vault-法華` 典籍清單（YAML）

以下 YAML 列出所有需要新增到 `vault-法華` 的典籍。分為**必須（required）** 與**建議（recommended）** 兩組。

```yaml
vault: vault-法華
priority: high
series: S7
description: 妙法蓮華經及主要疏論
created: 2026-04-06

required:
  # === 經部：法華三譯 ===
  - id: T0262
    title: 妙法蓮華經
    title_en: Saddharmapuṇḍarīka Sūtra (Kumārajīva translation)
    translator: 鳩摩羅什
    era: 姚秦（406 CE）
    fascicles: 7
    taisho_volume: 9
    status: missing
    priority: critical
    notes: |
      S7 主要依據文本。鳩摩羅什譯本是中國佛教法華傳承的標準本。
      Code Opus 必須優先抓取此經——所有 12 篇 S7 論文都會引用。
      CBETA URL pattern: T09n0262
      建議切分：每品（共 28 品）一個 markdown 檔，方便 grep。

  - id: T0263
    title: 正法華經
    title_en: Saddharmapuṇḍarīka Sūtra (Dharmarakṣa translation)
    translator: 竺法護
    era: 西晉（286 CE）
    fascicles: 10
    taisho_volume: 9
    status: missing
    priority: high
    notes: |
      最早的法華漢譯，比羅什早 120 年。對於文本校勘與指月
      「阿含種子→法華開展」命題三，正法華有時保留更古老的譯語特徵。
      建議整部下載但不必精細切分。

  - id: T0264
    title: 添品妙法蓮華經
    title_en: Saddharmapuṇḍarīka Sūtra (supplemented translation)
    translator: 闍那崛多、達摩笈多
    era: 隋（601 CE）
    fascicles: 7
    taisho_volume: 9
    status: missing
    priority: medium
    notes: |
      補訂本，主要用於對勘羅什本缺漏段落（如提婆達多品原位置）。
      P08 提婆達多品論文必用。

  # === 論部：印度唯識原典 ===
  - id: T1519
    title: 妙法蓮華經憂波提舍
    title_en: Saddharmapuṇḍarīkopadeśa (Vasubandhu's treatise on the Lotus, tr. Bodhiruci)
    author: 世親 (Vasubandhu)
    translator: 菩提流支、曇林
    era: 北魏（508 CE）
    fascicles: 2
    taisho_volume: 26
    status: missing
    priority: critical
    notes: |
      命題一的原始印度依據。世親從唯識角度解讀法華的罕見文獻。
      中國學界用得少，指月的學術貢獻在於把此論重新置於法華研究中心。
      全系列 P01、P02、P03 必用。

  - id: T1520
    title: 妙法蓮華經論優波提舍
    title_en: Saddharmapuṇḍarīkopadeśa (alternate translation)
    author: 世親 (Vasubandhu)
    translator: 勒那摩提、僧朗
    era: 北魏
    fascicles: 1
    taisho_volume: 26
    status: missing
    priority: critical
    notes: |
      世親法華論的另一漢譯本。與 T1519 對勘可確認關鍵概念的譯語差異。
      必與 T1519 同時入庫。

  # === 疏部：中國主要疏論 ===
  - id: T1723
    title: 妙法蓮華經玄贊
    title_en: Profound Commentary on the Lotus Sūtra
    author: 窺基
    era: 唐（約 680 CE）
    fascicles: 20
    taisho_volume: 34
    status: missing
    priority: critical
    notes: |
      法相宗（唯識）對法華的主要疏論。窺基用三性、種子、八識系統
      解讀法華，是命題一的最主要中國依據。
      全系列幾乎每篇都會引用。

  - id: T1716
    title: 妙法蓮華經玄義
    title_en: Profound Meaning of the Lotus Sūtra
    author: 智顗
    era: 隋（約 593 CE）
    fascicles: 20
    taisho_volume: 33
    status: missing
    priority: critical
    notes: |
      天台宗立宗之作。十如是三轉讀（「是相如／如是相／相如是」）
      是 P01 必備內容。迹本二門判攝架構也出自此論。
      P01、P02、P11、P12 必用。

  - id: T1718
    title: 妙法蓮華經文句
    title_en: Textual Commentary on the Lotus Sūtra
    author: 智顗
    era: 隋（約 587 CE）
    fascicles: 20
    taisho_volume: 34
    status: missing
    priority: high
    notes: |
      智顗對法華經文的逐句注釋。P01（方便品）、P02（開示悟入）、
      P03（火宅喻）、P11（壽量品）注釋部分最常引用。

recommended:
  # === 疏部：其他重要疏論 ===
  - id: T1717
    title: 法華玄義釋籤
    author: 湛然
    era: 唐（約 770 CE）
    fascicles: 20
    taisho_volume: 33
    status: missing
    priority: medium
    notes: 湛然對智顗玄義的補註，補充迹本二門的細節論證。

  - id: T1719
    title: 法華文句記
    author: 湛然
    era: 唐
    fascicles: 30
    taisho_volume: 34
    status: missing
    priority: medium
    notes: 湛然對智顗文句的補註。

  - id: T1721
    title: 法華義疏
    author: 吉藏
    era: 隋（約 602 CE）
    fascicles: 12
    taisho_volume: 34
    status: missing
    priority: medium
    notes: |
      三論宗（中觀）對法華的疏論。與窺基唯識疏構成對照。
      命題二的中觀背景依據。P06 化城喻、P11 壽量品需要吉藏對照。

  - id: T1720
    title: 法華玄論
    author: 吉藏
    era: 隋
    fascicles: 10
    taisho_volume: 34
    status: missing
    priority: low

  # === 相關典籍：楞伽（如來藏對接衣珠喻）===
  - id: T0670
    title: 楞伽阿跋多羅寶經
    title_en: Laṅkāvatāra Sūtra
    translator: 求那跋陀羅
    era: 南朝宋（443 CE）
    fascicles: 4
    taisho_volume: 16
    status: check_vault_唯識
    priority: medium
    notes: |
      如來藏與阿賴耶識結合的經典。P07 衣珠喻論文需要此經的
      如來藏段落作為「本有寶藏」命題的經典錨點。
      請 Code Opus 先確認是否已在 vault-唯識；若無則新增。

download_instructions: |
  1. 主要來源：CBETA Online (https://cbetaonline.dila.edu.tw/) 或
     CBETA 離線版 markdown export
  2. 命名慣例：沿用現有 vault 慣例，如 `T0262_卷01.md`、
     `T0262_妙法蓮華經_方便品.md` 等（視文件大小決定粒度）
  3. 建議切分：
     - T0262 法華經：**按品切分**（共 28 品），單檔約 3–8KB，grep 友好
     - T0263/T0264：按卷切分即可
     - T1723 玄贊：按卷切分（20 卷）
     - T1716 玄義、T1718 文句：按卷切分
     - T1519/T1520 世親論：全本一檔或按卷切分均可
  4. Front-matter 建議（YAML）：
     ```yaml
     ---
     taisho: T0262
     title: 妙法蓮華經
     fascicle: 1
     chapter: 方便品第二
     translator: 鳩摩羅什
     source: CBETA
     ---
     ```
  5. 完成後確認：`find vault-法華 -name "*.md" | wc -l` 並回報 Chat Opus
```

---

## Part 3 — S7-P01 RAG Queries

P01 工作標題：**諸法實相·十如是——法華的義理基石**
P01 經文錨點：方便品 §2「唯佛與佛乃能究盡諸法實相」段 + 十如是句
P01 任務：立命題一（三性映射）、顯命題二（攝顯對偶）、對接指月 manifesto「諸法實相」標語

### 執行方法

Code Opus 以 sub-agent parallel grep 方式在指定 vault 執行。每個 query 提供 target 典籍、grep pattern、vault 路徑與 context 需求。結果以「Q01 / Q02 ...」分節回傳。

### 查詢清單（共 12 條）

#### 經部 · 法華經本經（Q01–Q03）

**Q01: 方便品「諸法實相」核心句**
- Target: T0262 卷一 方便品第二
- Grep: `諸法實相|唯佛與佛|究盡諸法|甚深微妙|難解之法`
- Vault: `vault-法華/`
- Context flags: `-n -B3 -A25`
- Note: 重點在「唯佛與佛乃能究盡諸法實相」整段到「十如是」的連續脈絡。必須抓到完整偈頌前的長行部分。

**Q02: 十如是句**
- Target: T0262 卷一 方便品第二
- Grep: `如是相|如是性|如是體|如是力|如是作|如是因|如是緣|如是果|如是報|如是本末究竟`
- Vault: `vault-法華/`
- Context flags: `-n -B5 -A15`
- Note: 十如是只出現一次（方便品 §2），非常關鍵。抓到整段包括前後語境。
  羅什本是「如是相、如是性、如是體、如是力、如是作、如是因、如是緣、如是果、如是報、如是本末究竟等」共十句。

**Q03: 正法華經對應段（T0263 對勘）**
- Target: T0263 卷一 善權品
- Grep: `諸法|實相|本末|究竟|如|相|性`
- Vault: `vault-法華/`
- Context flags: `-n -B5 -A30`
- Note: 竺法護譯本沒有「十如是」這個名相，但有對應段。查此段作文本校勘依據——
  正法華的對應文字可能是「其所知見十相如是」或「本末相性」之類更古老的措辭。
  這是命題三阿含種子以外的另一條語言學線索。

#### 論部 · 印度唯識原典（Q04–Q05）

**Q04: 世親法華論 — 十如是／諸法實相段**
- Target: T1519 妙法蓮華經憂波提舍
- Grep: `諸法實相|如是相|種性|種子|三性|遍計|依他|圓成`
- Vault: `vault-法華/`
- Context flags: `-n -B5 -A20`
- Note: 世親如何用唯識概念解釋「諸法實相」。這是命題一最關鍵的原始依據。
  如果 T1519 沒有直接對應段，則 grep 方便品整體解讀部分。

**Q05: 世親法華論 — 一佛乘／會三歸一段**
- Target: T1519 + T1520
- Grep: `一乘|一佛乘|三乘|會|歸|方便`
- Vault: `vault-法華/`
- Context flags: `-n -B5 -A20`
- Note: 世親對一佛乘的唯識解讀，為 P02 預備材料；但 P01 也需要引一段
  證明命題一（三性映射）有印度原始依據。

#### 疏部 · 主要中國疏論（Q06–Q09）

**Q06: 窺基法華玄贊 — 諸法實相段**
- Target: T1723 卷三 或卷四（方便品注釋部分）
- Grep: `諸法實相|唯佛與佛|究盡|如是相|十如|種性|三性|遍計|依他|圓成`
- Vault: `vault-法華/`
- Context flags: `-n -B5 -A25`
- Note: 窺基是命題一的中國主要依據。必須抓到他如何把「諸法實相」與三性連接的段落。

**Q07: 智顗法華玄義 — 十如是三轉讀**
- Target: T1716 卷二上、卷二下
- Grep: `十如是|如是相|三轉|是相如|相如是|空假中|一念三千`
- Vault: `vault-法華/`
- Context flags: `-n -B5 -A30`
- Note: 智顗的十如是三轉讀（「是相如／如是相／相如是」對應空／假／中）
  是 P01 必備內容。即使指月不完全採用天台三觀，也必須呈現並討論這個讀法。
  一念三千的說法也在玄義中——可能需要。

**Q08: 智顗法華文句 — 方便品「諸法實相」段逐句注**
- Target: T1718 卷三下 或卷四上（方便品文句注釋）
- Grep: `諸法實相|唯佛與佛|甚深|微妙|難解|如是相`
- Vault: `vault-法華/`
- Context flags: `-n -B5 -A20`
- Note: 智顗的逐句注釋，提供字義訓詁層的依據。

**Q09: 吉藏法華義疏 — 諸法實相段（中觀對照）**
- Target: T1721 卷三 或卷四（方便品注釋）
- Grep: `諸法實相|實相|真如|中道|不二|空|假`
- Vault: `vault-法華/`
- Context flags: `-n -B5 -A20`
- Note: 吉藏從中觀角度解「諸法實相」。提供與窺基唯識讀法的對照，
  為命題二（攝顯對偶需要中觀背景）鋪路。

#### 支援典籍 · 唯識三性理論（Q10–Q11）

**Q10: 解深密經三性品**
- Target: T0676 卷二 一切法相品、三自性相品
- Grep: `遍計所執|依他起|圓成實|三自性|三無性|相|性`
- Vault: `vault-唯識/`
- Context flags: `-n -B5 -A25`
- Note: 三性理論最權威的經典依據。用於命題一的佛說授權。
  （S3、S5 已用過，可能 grep 得到既有結果，但為 P01 獨立引用請重跑。）

**Q11: 成唯識論三性段**
- Target: T1585 卷八、卷九
- Grep: `遍計所執性|依他起性|圓成實性|三性|三無性|初能變`
- Vault: `vault-唯識/`
- Context flags: `-n -B5 -A25`
- Note: 三性理論的論典展開。用於命題一的論典依據。
  特別注意「依他起」如何作為遍計與圓成之間的樞紐——這是
  指月把譬喻（依他起的教學示現）放在方便與實相之間的理論基礎。

#### 指月 manifesto 對接（Q12）

**Q12: 華嚴經「諸法實相」相關段（預先對接 P12 命題二）**
- Target: T0279 八十華嚴（任何卷）
- Grep: `諸法實相|法界|實相|一即一切|一切即一|重重無盡`
- Vault: `vault-華嚴/`
- Context flags: `-n -B5 -A15`
- Note: P01 雖然主要立命題一，但命題二（攝顯對偶）也要在 P01 顯題。
  為此需要一兩段華嚴對「諸法實相」的處理，以便對照法華的方便化表達
  與華嚴的密度坍縮表達。抓 1–3 段最具代表性的即可，不必窮盡。

---

## Part 4 — 執行優先順序

```
階段 A（vault 建置，必須先完成）：
  1. Code Opus 新建 vault-法華 目錄
  2. 下載 required 清單中的全部典籍（T0262 最優先）
  3. 按建議粒度切分、加 front-matter
  4. 回報 Chat Opus：vault-法華 檔案數 + T0262 各品檔名確認

階段 B（RAG 執行，vault 就緒後）：
  5. 執行 Q01–Q02（法華本經，最關鍵）
  6. 執行 Q04–Q05（世親法華論）
  7. 執行 Q06–Q09（中國疏論）
  8. 執行 Q10–Q11（唯識支援）
  9. 執行 Q03、Q12（對勘與預接）
  10. 結果整合為 S7-P01_rag_results.md 回傳 Chat Opus

階段 C（回到 Chat Opus）：
  11. Chat Opus 根據 RAG 結果起草 S7-P01 中文稿
  12. 英文適配
  13. 寫 S7-P01_passdown.md 並準備 S7-P02 RAG queries
```

---

## Part 5 — 給 Code Opus 的備註

1. **vault-法華 是 S7 的長期資產**——這次建好之後，S7 後續 11 篇論文都會用到，不只是 P01。
2. **T0262 切分粒度很關鍵**——如果整部 7 卷一檔，grep 結果會太大；如果每句一檔，查詢會太碎。建議**按品切分**（28 品），每品單檔。
3. **世親法華論（T1519/T1520）中國學界冷門**——如果 CBETA 沒有現成 markdown，可能需要從漢文大藏經線上版轉換。這是必須項，不是可選項。
4. **如果 T1519 抓不到 Q04 或 Q05 的目標段落**——請回報 Chat Opus，我會調整命題一的論證策略（改用窺基玄贊 T1723 為主要依據）。
5. **阿含 vault 已就緒**——本 P01 不需要阿含查詢，但 P02 開始會大量使用，請確認 vault-阿含 運作正常。
6. **P01 不設 Q13+ 的增補查詢**——如果 Q01–Q12 結果充足，直接回傳；如果某條結果不足，Chat Opus 會發補充查詢。

---

*指月 · Pointing at the Moon · 2026*
*Vault prep deliverable for Code Opus · S7-P01 RAG readiness*

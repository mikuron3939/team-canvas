// ゲームの状態管理
// 0: タイトル, 1: カウントダウン, 2: プレイ中, 3: リザルト
int eatState = 0; 
int countDownStartTime;
int playStartTime;
final int TIME_LIMIT = 3000; // プレイ制限時間（3秒 = 3000ミリ秒）
boolean isEatFinished;

Food[] foods;
ArrayList<Food> selectedFoods;
int score = 0;

void resetEat(){
  eatState = 0;
  isEatFinished = false;
  initGame();
}

void drawEat() {
  background(240, 248, 255); // 背景色（薄い水色）
  
  switch (eatState) {
    case 0:
      eatDrawTitle();
      break;
    case 1:
      eatDrawCountdown();
      break;
    case 2:
      eatDrawPlayScreen();
      break;
    case 3:
      eatDrawResult();
      break;
  }
}

void initGame() {
  // 食べ物データの初期化 (名前, x, y, ダイエット向きか, 色)
  float cx = width / 2;
  float cy = height / 2 - 100;
  foods = new Food[6];
  foods[0] = new Food("ブロッコリー", cx - 140, cy - 40, true, color(100, 200, 100)); // ⭕️
  foods[1] = new Food("唐揚げ", cx, cy - 120, false, color(200, 150, 50));     // ❌
  foods[2] = new Food("ささみ", cx + 140, cy - 40, true, color(255, 220, 220));     // ⭕️
  foods[3] = new Food("ケーキ", cx - 140, cy + 100, false, color(255, 150, 200));    // ❌
  foods[4] = new Food("ゆで卵", cx, cy + 160, true, color(255, 255, 150));     // ⭕️
  foods[5] = new Food("ラーメン", cx + 140, cy + 100, false, color(255, 200, 100));  // ❌
  
  selectedFoods = new ArrayList<Food>();
  score = 0;
}
// --- 各画面の描画処理 ---
void eatDrawTitle() {
  fill(50);
  textSize(40);
  text("ダイエット・チョイス！", width/2, height/3);
  
  textSize(20);
  fill(100);
  text("クリックしてスタート", width/2, height/2 + 50);
}

void eatDrawCountdown() {
  int elapsed = millis() - countDownStartTime;
  int remaining = 3 - (elapsed / 1000); // 3, 2, 1 のカウント
  
  fill(50);
  textSize(120);
  
  if (remaining > 0) {
    text(remaining, width/2, height/2);
  } else if (remaining == 0) {
    fill(255, 50, 50);
    text("GO!!", width/2, height/2);
  } else {
    // カウントダウン終了、ゲーム開始
    eatState = 2;
    playStartTime = millis();
  }
}
void eatDrawPlayScreen() {
  // 残り時間の計算
  int elapsed = millis() - playStartTime;
  int remainTime = TIME_LIMIT - elapsed;
  
  if (remainTime <= 0) {
    remainTime = 0;
    // タイムアップ時の処理
    calculateScore();
    eatState = 3;
  }
  
  // UI: 上部のタイマー
  fill(50);
  textSize(30);
  textAlign(LEFT, TOP);
  // スケッチにあった 3:00 のような表記をミリ秒込みで再現 (例: 2.50)
  text("残り " + nf(remainTime / 1000.0, 1, 2), 30, 30);
  textAlign(CENTER, CENTER); // アライメントを戻す
  
  // UI: 中央の選択肢を描画
  for (Food f : foods) {
    f.display();
  }
  // UI: 下部の選択枠を描画
  eatDrawSlots();
}

void eatDrawSlots() {
  rectMode(CENTER);
  for (int i = 0; i < 3; i++) {
    float slotX = width/2 - 120 + (i * 120);
    float slotY = height - 120;
    
    // 枠の描画
    stroke(100);
    strokeWeight(3);
    fill(255);
    rect(slotX, slotY, 100, 100, 15);
    
    // 選択された食べ物を枠内に描画
    if (i < selectedFoods.size()) {
      Food f = selectedFoods.get(i);
      noStroke();
      fill(f.col);
      ellipse(slotX, slotY, 70, 70);
      fill(50);
      textSize(16);
      text(f.name, slotX, slotY);
    }
  }
}

void eatDrawResult() {
  fill(50);
  textSize(40);
  text("結果発表", width/2, height/6);
  
  // 選んだアイテムの判定表示
  for (int i = 0; i < 3; i++) {
    float x = width/2 - 140 + (i * 140);
    float y = height/2 - 50;
    
    // 枠
    stroke(100);
    strokeWeight(2);
    fill(255);
    rect(x, y, 120, 120, 15);
    
    if (i < selectedFoods.size()) {
      Food f = selectedFoods.get(i);
      
      // 食べ物
      noStroke();
      fill(f.col);
      ellipse(x, y, 80, 80);
      fill(50);
      textSize(18);
      text(f.name, x, y);
      
      // ⭕️❌判定
      textSize(80);
      if (f.isHealthy) {
        fill(255, 50, 50);
        text("⭕️", x, y - 90);
      } else {
        fill(50, 50, 255);
        text("❌", x, y - 90);
      }
    } else {
      // 時間切れで選べなかった枠
      fill(150);
      textSize(40);
      text("-", x, y);
    }
  }
  
  // スコア表示
  fill(50);
  textSize(50);
  text("SCORE: " + score, width/2, height * 0.75);
  
  textSize(20);
  fill(100);
  text("クリックしてホームへ", width/2, height * 0.85);
}

void calculateScore() {
  score = 0;
  for (Food f : selectedFoods) {
    if (f.isHealthy) {
      score += 100; // 正解: +100点
    } else {
      score -= 50;  // 不正解: -50点
    }
  }
  // 3つ選べずにタイムアップした枠へのペナルティ
  int missed = 3 - selectedFoods.size();
  score -= missed * 50; 
}

void eatCheckClick() {
    if (eatState == 0) {
      // タイトルからカウントダウンへ
      eatState = 1;
      countDownStartTime = millis();
    } 
    else if (eatState == 2) {
      // プレイ中のクリック判定
      if (selectedFoods.size() < 3) {
        for (Food f : foods) {
          if (!f.isSelected && f.isClicked(mouseX, mouseY)) {
            f.isSelected = true;
            selectedFoods.add(f);
            break; // 1回のクリックで1つだけ選択
          }
        }
      }
      
      // 3つ選び終わったら即座に結果画面へ
      if (selectedFoods.size() == 3) {
        calculateScore();
        eatState = 3;
      }
    }
    else if (eatState == 3) {
      isEatFinished = true;
      rectMode(CORNER);
      //結果画面からタイトルへ戻る
    }
  }

//--- 食べ物を管理するクラス ---
class Food {
  String name;
  float x, y;
  float radius;
  boolean isHealthy; // ダイエット向きかどうか
  boolean isSelected;
  color col;

  Food(String n, float px, float py, boolean healthy, color c) {
    name = n;
    x = px;
    y = py;
    isHealthy = healthy;
    col = c;
    radius = 50;
    isSelected = false;
  }
  
  void display() {
    // 選択済みのものは画面中央から消す
    if (isSelected) return; 
    
    noStroke();
    fill(col);
    ellipse(x, y, radius * 2, radius * 2);
    
    fill(50);
    textSize(20);
    textAlign(CENTER, CENTER);
    text(name, x, y);
  }
  
  boolean isClicked(float mx, float my) {
    // マウスの座標と円の中心との距離で当たり判定
    return dist(mx, my, x, y) <= radius;
  }
}

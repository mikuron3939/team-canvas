// --- 状態管理変数 ---
float gaugeVal;
float gaugeSpeed;

// --- 判定基準・設定値（不変のものはfinalで定数化） ---
final float TARGET_MIN = 70;
final float TARGET_MAX = 90;
final int TRAINING_LIMIT_MS = 5000; // 制限時間（ミリ秒）

// タイマー管理用
int trainingStartTime;

boolean isTrainingFinished = false;
String trainingResultStr = "";
int trainingResultColor;

//------------------------
// 初期化
//------------------------
void resetTraining() {
  gaugeVal = 0;
  gaugeSpeed = 0.6;
  isTrainingFinished = false;
  trainingResultStr = "";
  
  // 開始時刻をシステム時間で記録
  trainingStartTime = millis();
}

//------------------------
// 画面描画とロジック更新
//------------------------
void TrainingView() {

  imageMode(CORNER);
  if(trainingBgImg != null){
    image(trainingBgImg, 0, 0, width, height);
  }

  // --- ロジック更新（トレーニング中のみ） ---
  if (!isTrainingFinished) {
    // ゲージの自然減少
    gaugeVal -= gaugeSpeed;
    gaugeVal = constrain(gaugeVal, 0, 100);
    
    // 経過時間の計算
    int elapsedTime = millis() - trainingStartTime;
    
    // 5秒経過した瞬間に判定処理を呼ぶ
    if (elapsedTime >= TRAINING_LIMIT_MS) {
      evaluateTraining();
    }
  }

  // --- UI描画 ---
  // 半透明の黒いシート
  noStroke();
  fill(0, 150);
  rect(180, 20, 440, 90, 15);

  textAlign(CENTER, CENTER);
  fill(255);
  textSize(28);
  text("SPACE連打でゲージをキープ！", width/2, 50);

  // 残り時間の表示
  textSize(24);
  if (!isTrainingFinished) {
    int remaining = max(0, TRAINING_LIMIT_MS - (millis() - trainingStartTime));
    text("残り時間: " + nf(remaining / 1000.0, 1, 2) + "秒", width/2, 90);
  } else {
    text("TIME UP!", width/2, 90);
  }

  //------------------
  // ゲージの描画
  //------------------
  float gx = 650;
  float gy = 120;
  float gw = 40;
  float gh = 300;

  // 背景
  fill(220);
  noStroke();
  rect(gx, gy, gw, gh, 10);

  // 成功ゾーン（緑）
  fill(100, 255, 100);
  float zoneY = gy + gh * (1 - TARGET_MAX / 100.0);
  float zoneH = gh * ((TARGET_MAX - TARGET_MIN) / 100.0);
  rect(gx, zoneY, gw, zoneH);

  // 現在ゲージ（赤）
  fill(255, 100, 100);
  float fillH = gh * (gaugeVal / 100.0);
  rect(gx, gy + gh - fillH, gw, fillH);

  // 枠線
  stroke(0);
  noFill();
  rect(gx, gy, gw, gh, 10);
  noStroke();

  //------------------
  // 結果表示
  //------------------
  if (isTrainingFinished) {
    fill(255, 255, 255, 180);
    rect(0, 0, width, height);

    fill(trainingResultColor);
    textSize(50);
    text(trainingResultStr, width/2, height/2 - 20);

    fill(0);
    textSize(22);
    text("クリックでホームへ", width/2, height/2 + 40);
  }
}

//------------------------
// SPACE連打による操作
//------------------------
void trainingSpacePressed() {
  if (isTrainingFinished) return;
  
  gaugeVal += 8;
  gaugeVal = constrain(gaugeVal, 0, 100);
}

//------------------------
// 時間切れ時の判定処理
//------------------------
void evaluateTraining() {
  isTrainingFinished = true;

  if (gaugeVal >= TARGET_MIN && gaugeVal <= TARGET_MAX) {
    trainingResultStr = "SUCCESS!!";
    trainingResultColor = color(0, 200, 0);
  } else {
    trainingResultStr = "FAILED...";
    trainingResultColor = color(255, 0, 0);
  }
}

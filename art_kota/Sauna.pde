int saunaRound = 1;
int saunaTempWeightLoss = 0;
boolean isSaunaFinished = false;
String saunaResultText = "";

// ==========================================
// 描画処理 (Gameタブの draw() から呼び出す)
// ==========================================
void drawSauna() {
  background(255, 240, 240); // 背景色

  if (!isSaunaFinished) {
    // --- プレイ中のUI描画 ---
    float[] rates = {70.0, 50.0, 30.0, 10.0};
    int currentRate = (int)rates[saunaRound - 1];

    fill(0);
    textSize(32);
    text("現在の成果: -" + saunaTempWeightLoss + "kg", width / 2, 160);
    
    // 限界に挑むボタン
    fill(255, 100, 100);
    rect(width / 2 - 250, 350, 200, 100, 10);
    fill(255);
    textSize(24);
    text("限界に挑む!\n(" + currentRate + "%で成功)", width / 2 - 150, 400);

    // 安全に終了ボタン
    fill(100, 150, 255);
    rect(width / 2 + 50, 350, 200, 100, 10);
    fill(255);
    text("ギブアップ...", width / 2 + 150, 400);

  } else {
    // --- 終了後の結果画面描画 ---
    fill(0);
    textSize(36);
    text(saunaResultText, width / 2, 200);
    textSize(28);
    text("最終減量: -" + saunaTempWeightLoss + "kg", width / 2, 280);

    // 次へボタン
    fill(200);
    rect(width / 2 - 100, 450, 200, 80, 10);
    fill(0);
    textSize(24);
    text("次へ", width / 2, 490);
  }
}

// ==========================================
// クリック処理 (Gameタブの mousePressed() から呼び出す)
// ==========================================
void mousePressedSauna() {
  if (!isSaunaFinished) {
    // 「限界に挑む」ボタン
    if (mouseX > width / 2 - 250 && mouseX < width / 2 - 50 && mouseY > 350 && mouseY < 450) {
      float[] rates = {70.0, 50.0, 30.0, 10.0};
      float currentRate = rates[saunaRound - 1];

      if (random(100) < currentRate) {
        // 成功
        saunaTempWeightLoss += 2;
        if (saunaRound >= 4) {
          weight -= saunaTempWeightLoss;
          saunaResultText = "完全制覇！限界を超えた！";
          isSaunaFinished = true;
        } else {
          saunaRound++;
        }
      } else {
        // 失敗
        saunaTempWeightLoss = 0;
        saunaResultText = "のぼせて倒れてしまった...";
        isSaunaFinished = true;
      }
    }
    // 「安全に終了」ボタン
    else if (mouseX > width / 2 + 50 && mouseX < width / 2 + 250 && mouseY > 350 && mouseY < 450) {
      weight -= saunaTempWeightLoss;
      saunaResultText = "のぼせる前に出ることが出来た！";
      isSaunaFinished = true;
    }
  } else {
    // 「次へ」ボタン
    if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 && mouseY > 450 && mouseY < 530) {
      saunaRound = 1;
      saunaTempWeightLoss = 0;
      isSaunaFinished = false;
      
      gameState = 1;
      isNextWeek = true;
    }
  }
}

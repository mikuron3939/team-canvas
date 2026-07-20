//---筋トレミニゲーム用の変数---
int setCount = 0;       //セット数をカウント
float situpProgress = 0;  //腹筋の起き上がり度合い（0:寝てる ～ 100:起ききった）
boolean isReturning = false; //起ききった後、自動で戻っている最中か
boolean isTrainingFinished = false; //5セット終わったか

// 筋トレゲームの初期化
void resetTraining() {
  setCount = 0;
  situpProgress = 0;
  isReturning = false;
  isTrainingFinished = false;
}

//筋トレ画面の描画
void TrainingView() {
  background(240); //背景
  
  //カウントの表示
  textAlign(CENTER, CENTER);
  fill(50);
  textSize(26);
  text("【space】で腹筋!", width / 2, 50);
  
  textSize(32);
  fill(0, 100, 250);
  text("セット数: " + setCount + " / 5", width / 2, 110);
  
  //進行度バーの描画
  noStroke();
  fill(200);
  rect(width/2 - 150, 150, 300, 20, 10); //背景のグレーのバー
  fill(255, 100, 100);
  rect(width/2 - 150, 150, situpProgress * 3, 20, 10); //赤い進捗バー
  
  //元の状態に戻る
  if (isReturning) {
    situpProgress -= 4; //戻るスピード
    if (situpProgress <= 0) {
      situpProgress = 0;
      isReturning = false; //再びクリック可能にする
      if (setCount >= 5) {
        isTrainingFinished = true;
      }
    }
  }
  
  //画像切り替え
  //画像の入った配列のインデックスによって画像を変える
  int currentImgIndex = 0;
  if (situpProgress > 30 && situpProgress <= 80) {
    currentImgIndex = 1; //途中まで起きてる
  } else if (situpProgress > 80) {
    currentImgIndex = 2; //完全に起きてる
  }
  // 画像の描画（画面中央に表示）
  imageMode(CENTER);
  if (trainingImgs[currentImgIndex] != null) {
    image(trainingImgs[currentImgIndex], width / 2, 350, 250, 250);
  }
  imageMode(CORNER);
  
  //終了画面
  if (isTrainingFinished) {
    //画面全体を薄く覆う
    fill(255, 255, 255, 200);
    rect(0, 0, width, height);
    
    fill(250, 50, 50);
    textSize(40);
    text("筋トレ完了！", width / 2, height / 2 - 20);
    
    fill(50);
    textSize(20);
    text("画面をクリックでホームに戻る", width / 2, height / 2 + 50); 
  }
}

// spaceが押された時の処理
void trainingSpacePressed() {
  //すでに5回終わっている、または自動で戻っている最中は無効
  if (isTrainingFinished || isReturning)
    return;
  //spaceが押されるごとに起き上がる
  situpProgress += 15;
  // 100に達したら、自動で戻る
  if (situpProgress >= 100) {
    situpProgress = 100;
    setCount++;
    isReturning = true;
  }
}

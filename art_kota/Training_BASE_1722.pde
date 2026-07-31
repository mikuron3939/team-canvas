//====================
// 筋トレミニゲーム
//====================

//ゲージ
float gaugeVal;
float gaugeSpeed;

//判定
float targetMin = 70;
float targetMax = 90;

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
}

//------------------------
// 画面
//------------------------
void TrainingView() {

imageMode(CORNER);

if(trainingBgImg != null){
  image(trainingBgImg, 0, 0, width, height);
}

  //ゲージ減少
  if (!isTrainingFinished) {
    gaugeVal -= gaugeSpeed;
    gaugeVal = constrain(gaugeVal, 0, 100);
  }

    // 半透明の黒いシート
noStroke();
fill(0, 150);   // 黒、透明度150（0～255）
rect(180, 20, 440, 90, 15);   // x, y, 幅, 高さ, 角丸

  textAlign(CENTER, CENTER);

  fill(255);
  textSize(28);
  text("SPACE連打！", width/2, 50);

  textSize(18);
  text("緑でENTER！", width/2, 90);

  //------------------
  //ゲージ
  //------------------

  float gx = 650;
  float gy = 120;
  float gw = 40;
  float gh = 300;

  fill(220);
  noStroke();
  rect(gx, gy, gw, gh, 10);

  //成功ゾーン
  fill(100,255,100);

  float zoneY = gy + gh * (1 - targetMax/100.0);
  float zoneH = gh * ((targetMax-targetMin)/100.0);

  rect(gx, zoneY, gw, zoneH);

  //現在ゲージ
  fill(255,100,100);

  float fillH = gh * (gaugeVal/100.0);

  rect(gx, gy+gh-fillH, gw, fillH);

  stroke(0);
  noFill();
  rect(gx, gy, gw, gh,10);
  noStroke();


  //------------------
  //結果表示
  //------------------

  if (isTrainingFinished) {

    fill(255,255,255,180);
    rect(0,0,width,height);

    fill(trainingResultColor);
    textSize(40);
    text(trainingResultStr,width/2,height/2-20);

    fill(0);
    textSize(22);
    text("クリックでホームへ",width/2,height/2+40);

  }

}

//------------------------
// SPACE連打
//------------------------
void trainingSpacePressed() {

  if (isTrainingFinished) return;

  gaugeVal += 8;
  gaugeVal = constrain(gaugeVal,0,100);

}

//------------------------
// ENTER決定
//------------------------
void stopTraining() {

  isTrainingFinished = true;

  if (gaugeVal >= targetMin && gaugeVal <= targetMax) {

    trainingResultStr = "PERFECT!!";
    trainingResultColor = color(0,200,0);

  }
  else if (gaugeVal < targetMin) {

    trainingResultStr = "BAD";
    trainingResultColor = color(255,0,0);

  }
  else {

    trainingResultStr = "NICE!";
    trainingResultColor = color(255,180,0);

  }

}

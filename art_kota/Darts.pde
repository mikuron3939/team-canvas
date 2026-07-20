//ダーツミニゲーム用の変数
float meterX = 200;//ゲージの左端の座標
float meterY = 500;//ゲージの縦位置
float meter_yoko = 400;//ゲージの横幅
float meter_tate = 30;//ゲージの高さ

float barX;//動くバーのX座標
float barSpeed = 8;//バーの動く速度

//的の位置とサイズ
float targetX = 400;
float targetY = 300;
float target_yoko = 300;
float target_tate = 450;

// ダーツの刺さった位置（-999はまだ刺さっていない状態）
float dartX = -999;
float dartY = -999;

boolean isDartsFinished = false;//ミニゲームが終わったか
String dartsResultStr = "";//画面に表示する結果の文字
int dartsResultColor;//結果の文字の色

//ダーツゲームの初期化
void resetDarts(){
  barX = meterX;
  barSpeed = 8;
  dartX = -999;
  dartY = -999;
  isDartsFinished = false;
  dartsResultStr = "";
}

//---ダーツ画面---
void DartsView(){
  //的の描画
  imageMode(CENTER);
  if(targetImg != null){
    image(targetImg,targetX,targetY,target_yoko,target_tate);
  }
  imageMode(CORNER);
  
  //下部のタイミングゲージの描画
  //普通の黄色
  fill(240, 240, 100);
  noStroke();
  rect(meterX, meterY, meter_yoko, meter_tate, 5);
  //パーフェクトの黄緑
  fill(150, 230, 150);
  rect(meterX + meter_yoko * 0.2, meterY, meter_yoko * 0.6, meter_tate);
  //悪い灰色
  fill(50, 50, 50);
  rect(meterX + meter_yoko * 0.35, meterY, meter_yoko * 0.3, meter_tate);
  
  //動くバーの更新と描画
  if (!isDartsFinished) {
    barX += barSpeed;
    //ゲージの端に達したら跳ね返る
    if (barX < meterX || barX > meterX + meter_yoko) {
      barSpeed *= -1;
    }
  }
  
  //動くバー本体
  stroke(0);
  strokeWeight(4);
  line(barX, meterY - 5, barX, meterY + meter_tate + 5);
  
  //刺さったダーツの描画
  if (dartX != -999){
    //矢の形の代わりに、シンプルな「X」マークとピンで表現
    stroke(50);
    strokeWeight(3);
    line(dartX - 10, dartY - 10, dartX + 10, dartY + 10);
    line(dartX + 10, dartY - 10, dartX - 10, dartY + 10);
    fill(255, 0, 0);
    noStroke();
    ellipse(dartX, dartY, 8, 8);
  }
  
  if (!isDartsFinished && dartHandImg != null) {
    imageMode(CENTER);
    //右下の位置
    image(dartHandImg, 80, 500, 300, 300);
    imageMode(CORNER);
  }
  
  //結果テキストと案内表示
  textAlign(CENTER, CENTER);
  if (isDartsFinished){
    fill(dartsResultColor);
    textSize(36);
    text(dartsResultStr, width / 2, targetY / 2);
    
    fill(50);
    textSize(20);
    text("画面をクリックでホームに戻る", width / 2, 580);
  } else {
    fill(50);
    textSize(22);
    text("タイミングよく【SPACEキー】を押せ！", width / 2, 50);
  }
}

//スペースキーが押された時のダーツ判定処理
void stopDartsBar(){
  isDartsFinished = true;
  
  // バーの中心（ゲージの真ん中）からの距離を計算
  float meterCenter = meterX + meter_yoko / 2;
  float distanceCenter = abs(barX - meterCenter);
  // ゲージの幅に対する割合で判定（真ん中ほど0に近い）
  float maxDistance = meter_yoko / 2;
  float scoreRatio = distanceCenter / maxDistance;
  
  if (scoreRatio < 0.3){
    //ダメ
    dartsResultStr = "BAD";
    dartsResultColor = color(50, 50, 50);
    //ほぼ中心に刺さる
    dartX = targetX + random(-target_yoko * 0.04, target_yoko * 0.04);
    dartY = targetY + random(-target_tate * 0.04, target_tate * 0.04);
    weight -= 5;
  } 
  else if(scoreRatio < 0.6){
    //大成功
    dartsResultStr = "PERFECT!!";
    dartsResultColor = color(250, 50, 50);
    //やや中心から離れた場所に刺さる
    float signX = random(1) < 0.5 ? -1 : 1;
    float signY = random(1) < 0.5 ? -1 : 1;
    dartX = targetX + signX * random(target_yoko * 0.06, target_yoko * 0.28);
    dartY = targetY + signY * random(target_tate * 0.06, target_tate * 0.28);
    weight -= 12;
  } 
  else{
    //普通
    dartsResultStr = "NICE!";
    dartsResultColor = color(200, 200, 0);
    //もっと中心から離れた場所に刺さる
    float signX = random(1) < 0.5 ? -1 : 1;
    float signY = random(1) < 0.5 ? -1 : 1;
    dartX = targetX + signX * random(target_yoko * 0.32, target_yoko * 0.45);
    dartY = targetY + signY * random(target_tate * 0.32, target_tate * 0.45);
    weight -= 10;
  }
}

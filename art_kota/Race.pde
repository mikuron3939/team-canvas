//---レースゲーム用の変数---
float playerX, playerY, playerV;//プレイヤーの位置と縦速度
float gravity = 0.8;//重力
int slowTimer = 0;
boolean isGround = true; //地面にいるか

float kabeX, kabeY;//障害物の位置
float kabeSpeed = 10;//障害物の速度
float kabe_yoko = 30;       
float kabe_tate = 60;       
int mutekiTimer = 0; //無敵時間タイマー
boolean isHit = false;

// ゴールに関する変数
float goalX;//ゴールテープのX座標
float goalLine = 10000;//ゴールまでの距離
float runDistance = 0;//走った距離
boolean isGoalSpawned = false;

//ドリンクアイテム
int drinkTimer = 0;//ドリンクの効果時間
float drinkBoost = 0;

//レースゲームの変数を初期化
void resetRace(){
  playerX = 400;
  playerY = 450;
  playerV = 0;
  isGround = true;
  kabeX = width + 200;
  kabeY = 450;
  mutekiTimer = 0;
  slowTimer = 0;
  runDistance = 0;
  isGoalSpawned = false;
  isHit = false;
  
  isDrinkUsed = false;
  drinkTimer = 0;
  drinkBoost = 0;
}
//---レース画面---
void RaceView() {
  stroke(80);
  strokeWeight(3);
  line(0, 450, width, 450);//地面
  //ぶつかった時に減速
  float currentSpeed = kabeSpeed + drinkBoost;
  if(slowTimer > 0){
    currentSpeed = 2.0;
    slowTimer--;
  } else if (mutekiTimer > 0) {
    currentSpeed = 1.5; 
  }
  //ドリンクアイテムの処理
  if (drinkTimer > 0){
    drinkTimer--;
    if (drinkTimer <= 0){
      drinkBoost = 0; // タイマー終了で加速終了
    }
  }
  //走行距離のカウント
  if (!isGoalSpawned) {//ゴールしてないとき
    runDistance += currentSpeed;
    if (runDistance >= goalLine) {
      isGoalSpawned = true;
      goalX = width + 100; // 画面の右外にゴールを出現させる
    }
  }
  //プレイヤーのジャンプ処理
  playerV += gravity;
  playerY += playerV;
  if (playerY >= 450) {
    playerY = 450;
    playerV = 0;
    isGround = true;
  }
  //無敵タイマーのカウントダウン
  if (mutekiTimer > 0) {
    mutekiTimer--;
  }
  fill(50,200,50);
  noStroke();
  rect(playerX - 25, playerY - 80, 50, 80);
  
//--- 障害物の処理 ---
  if (!isGoalSpawned) {
    kabeX -= currentSpeed;
    if (kabeX < -max(kabe_yoko,kabe_tate)) {
      kabeX = width + random(150, 400);
      isHit = false;
    }
    // 障害物の描画
    fill(50);
    noStroke();
    if(!isHit){
      rect(kabeX, kabeY - kabe_tate, kabe_yoko, kabe_tate);
    }else{
      rect(kabeX, kabeY - 20, kabe_tate, 20);
    } 
    
    //当たり判定(無敵時間中でないとき)
    if (mutekiTimer == 0) {
      if (kabeX < playerX + 25 && kabeX + kabe_yoko > playerX - 25) {
        if (playerY > kabeY - kabe_tate){
          //障害物にあたったとき
          slowTimer = 60;
          mutekiTimer = 60;//約1秒間の無敵時間
          isHit =  true;
        }
      }
    }
  }
  //ゴールテープの処理
  if (isGoalSpawned){
    goalX -= currentSpeed;// ゴールテープが左に流れてくる
    // ゴールテープ（赤い線）の描画
    stroke(250, 50, 50);
    strokeWeight(8);
    line(goalX, 350, goalX, 450);
    fill(250, 50, 50);
    textSize(20);
    text("GOAL", goalX, 330);
    //プレイヤーがゴールテープを通過したらクリア
    if (playerX > goalX){
      gameState = 3;
    }
  }
  // UI表示
  fill(50);
  textSize(20);
  textAlign(LEFT, TOP);
  //進行度の表示
  float progress = min(runDistance / goalLine, 1.0);
  text("進捗:" + int(progress * 100) + "%", 30, 20);
  
  textAlign(CENTER, CENTER);
  text("【SPACEキー】でジャンプ！", width / 2, 50);
  
  //ドリンクアイテムのUI
  fill(50);
  textSize(16);
  textAlign(RIGHT, TOP);
  String drinkStatus = "なし";
  if (drinkLevel > 0) {
    if (isDrinkUsed) drinkStatus = "使用済み";
    else drinkStatus = "【E】キーで加速";
  }
  text("ドリンク:" + drinkStatus, width - 30, 20);
  // ドリンク効果中の演出（バーを表示するなど）
  if (drinkTimer > 0){
    noStroke(); fill(100, 255, 100, 150); // 薄い緑色
    rect(30, 50, drinkTimer, 10, 5); // 残り時間バー
  }
  textAlign(CENTER, CENTER); // textAlignを元に戻す
}

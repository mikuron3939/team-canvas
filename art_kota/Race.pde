//---レースゲーム用の変数---
float playerX, playerY, playerV;//プレイヤーの位置と縦速度
float playerBack =0;//プレイヤーのノックバック
float gravity = 0.8;//重力
float jump = -14;//ジャンプ力
boolean isGround = true; //地面にいるか

float kabeX, kabeY;//障害物の位置
float kabeSpeed = 6;    //障害物の速度
float kabe_yoko = 30;       
float kabe_tate = 60;       
int mutekiTimer = 0; // ノックバック後の無敵時間タイマー

// ゴールに関する変数
float goalX;//ゴールテープのX座標
float goalLine = 10000;//ゴールまでの距離
float runDistance = 0;//走った距離
boolean isGoalSpawned = false;

//レースゲームの変数を初期化
void resetRace(){
  playerX = 400;
  playerY = 450;
  playerV = 0;
  isGround = true;
  kabeX = width + 200;
  kabeY = 450;
  mutekiTimer = 0;
  runDistance = 0;
  isGoalSpawned = false;
}
//---レース画面---
void RaceView() {
  stroke(80);
  strokeWeight(3);
  line(0, 450, width, 450);//地面
  //ぶつかった時に減速
  float currentSpeed = kabeSpeed;
  if (mutekiTimer > 0) {
    currentSpeed = 1.5; 
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
  //ノックバック
  playerX += playerBack; //ノックバック速度
  if (mutekiTimer > 0) {
    playerBack *= 0.85; 
  } else {
    //通常時に元の位置より後ろにいたら、前に戻る
    playerBack = 0;
    if (playerX < 400) {
      playerX += 1.5;
      if (playerX > 400) playerX = 400;
    }
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
    if (kabeX < -kabe_yoko) {
      kabeX = width + random(150, 400);
    }
    // 障害物の描画
    fill(50);
    noStroke();
    rect(kabeX, kabeY - kabe_tate, kabe_yoko, kabe_tate);
    
    //当たり判定(無敵時間中でないとき)
    if (mutekiTimer == 0) {
      if (kabeX < playerX + 25 && kabeX + kabe_yoko > playerX - 25) {
        if (playerY > kabeY - kabe_tate){
          //ノックバック発生
          playerBack = -30;//左に吹き飛ばす
          kabeX = playerX + 30;
          mutekiTimer = 60;//約1秒間の無敵時間
        }
      }
    }
    if (mutekiTimer > 0 && kabeX < playerX + 25 && kabeX + kabe_yoko > playerX - 25){
      if (playerY > kabeY - kabe_tate) {
        playerX = kabeX - 25; // 壁の左端に密着させる
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
}

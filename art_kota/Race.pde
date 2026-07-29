//---レースゲーム用の変数---
float playerX, playerY, playerV;//プレイヤーの位置と縦速度
float gravity = 0.8;//重力
int slowTimer = 0;
boolean isGround = true; //地面にいるか
boolean isRaceStarted = false;
boolean hasDoubleJump = false;//能力を買ったか
boolean canDoubleJump = false;
boolean isSecondJumping = false;//２回目のジャンプを行ったか
//障害物の変数
float kabeX, kabeY;//障害物の位置
float kabeSpeed = 10;//障害物の速度
float kabe_yoko = 30;       
float kabe_tate = 60;       
int mutekiTimer = 0; //無敵時間タイマー
boolean isHit = false;

//落とし穴
float anaX,ana_yoko = 200;
boolean isAnaSpawned = false;

// ゴールに関する変数
float goalX;//ゴールテープのX座標
float goalLine = 10000;//ゴールまでの距離
float runDistance = 0;//走った距離
boolean isGoalSpawned = false;

//スタートダッシュの変数
int startDashTimer = 0;//スタートダッシュの受付用タイマー
String startMessage = "";//「PERFECT!」などの表示用
int startDashColor;
boolean isStartDashed = false;//判定が済んだか
int DashCountDown = 0;
float raceBar = 0;
int raceBarDir = 1;

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
  
  startDashTimer = 600;
  startMessage = "";
  isStartDashed = false;
  isRaceStarted = false;
  DashCountDown = 0;
  
  raceBar = 0;
  raceBarDir = 1;
  
  anaX = width + 200;
  isAnaSpawned = false;
  
  canDoubleJump = false;
  isSecondJumping = false;

}
//---レース画面---
void RaceView() {
  imageMode(CORNER);
  image(raceBackImg,0 , 0, width, height);
  // 1. スタートダッシュ前の待機中処理
  if (!isRaceStarted) {
    if(!isStartDashed){
    //まだスペースを押していない（3秒間の受付中）
      if (startDashTimer > 0) {
        startDashTimer--;
        //バーを高速で往復させる処理（かける数字で速さを調節）
        raceBar += 0.08 * raceBarDir;
        if (raceBar >= 1.0) {
          raceBar = 1.0;
          raceBarDir = -1; // 下向きに反転
        } else if (raceBar <= 0.0) {
          raceBar = 0.0;
          raceBarDir = 1;  // 上向きに反転
        }
      } else {
      // 時間切れで自動的に「LATE」扱いでレーススタート
          isStartDashed = true;
          startMessage = "LATE...";
          startDashColor = color(150, 150, 150);
          drinkBoost = 0;
          DashCountDown = 180;
        }
     }else{
       if(DashCountDown > 0){
         DashCountDown--;
      }else{
          isRaceStarted = true; 
        }
      }
    }

  // 速度の計算（レースが始まっていないときはスピード0）
  float currentSpeed = 0;
  if (isRaceStarted) {
    currentSpeed = kabeSpeed + drinkBoost;
    //ぶつかった時に減速
    if(slowTimer > 0){
      currentSpeed = 2.0;
      slowTimer--;
    } else if (mutekiTimer > 0) {
      currentSpeed = 1.5; 
    }
  }
  //ドリンクアイテムの処理
  if (drinkTimer > 0){
    drinkTimer--;
    if (drinkTimer <= 0){
      drinkBoost = 0; // タイマー終了で加速終了
    }
  }
  //スタートダッシュタイマー
  if (startDashTimer > 0) {
    startDashTimer--;
  }
  //最初の一定距離の間は、穴も障害物も出さない
  boolean isSafeZone = (runDistance < 500);
  //落とし穴
  if (!isGoalSpawned && !isSafeZone){
    anaX -= currentSpeed;
    if (anaX < -ana_yoko) {
      anaX = width + random(300, 700); //一定間隔で穴が出現
      isAnaSpawned = false;
    }
    //穴の暗い部分を描画
    fill(20);
    noStroke();
    ellipse(anaX+100, 450, 300, 20);
  } else {
    // ゴール後は普通の地面を描く
    stroke(80);
    strokeWeight(3);
    line(0, 450, width, 450);
  }
  //走行距離のカウント
  if (isRaceStarted && !isGoalSpawned) {//ゴールしてないとき
    runDistance += currentSpeed;
    if (runDistance >= goalLine) {
      isGoalSpawned = true;
      goalX = width + 100; // 画面の右外にゴールを出現させる
    }
  }
  //プレイヤーのジャンプ処理
  playerV += gravity;
  playerY += playerV;
  // 穴の中心X座標
  float anaCenterX = anaX + ana_yoko / 2;
  //穴の右端（先のX座標）
  //判定：プレイヤーの左端がすでに穴の始まりを超えているか
  boolean isFalling = (playerX >= anaX && playerX <= anaX + ana_yoko && !isGoalSpawned);
  if (playerY >= 450) {
    if(isFalling){
      isGround = false;
      playerX += (anaCenterX - playerX)*0.2;
      playerV = 15;

      if(playerY > 600){
        gameState = 9;
      }
    }else{
      playerY = 450;
      playerV = 0;
      isGround = true;
      canDoubleJump = true;
    }
  }
  //無敵タイマーのカウントダウン
  if (mutekiTimer > 0) {
    mutekiTimer--;
  }
  
//--- 障害物の処理 ---
  if (!isGoalSpawned && !isSafeZone) {
    kabeX -= currentSpeed;
    if (kabeX < -max(kabe_yoko,kabe_tate)) {
      kabeX = width + random(150, 400);
      if (abs(kabeX - anaX) < 400) {
        kabeX = anaX + random(400, 700);
      }
      isHit = false;
    }
    //障害物の描画
    imageMode(CORNER);
    //通常時の障害物画像
    if(!isHit){
       image(hardleImg, kabeX-75, kabeY - 90, 130, 130);fill(50);
    }else{//ぶつかった後
        image(hardle_hitImg, kabeX-75, kabeY - 85, 130, 130);
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
  
  //左側のスタートダッシュ用バー---
  if (!isRaceStarted) {
    // 画面中央の案内メッセージ
    fill(255, 255, 100);
    textSize(40);
    textAlign(CENTER, CENTER);
    if (!isStartDashed) {
      text("【SPACE】でスタートダッシュを決めろ！", width / 2, 100);
    }
    
    // 判定結果の表示
    if (!startMessage.equals("")) {
      fill(startDashColor);
      textSize(35);
      text(startMessage, width / 2, 150);
    }
    
    // 画面左側に縦長のバーを描画
    float barX = 80;
    float barY = 180;
    float barW = 40;
    float barH = 250;
    
    // バーの枠
    stroke(100);
    strokeWeight(2);
    fill(240);
    rect(barX, barY, barW, barH);
    
    // 一番上の黄緑ゾーン（ベスト：上から0%〜20%のエリア）
    noStroke();
    fill(100, 255, 100);
    rect(barX, barY, barW, barH * 0.2);
    
    // 現在位置を示すインジケーター（または動くバー）
    float indicatorY = map(raceBar, 1.0, 0.0, barY, barY + barH);
    
    fill(50, 50, 250);
    rect(barX - 5, indicatorY - 5, barW + 10, 10);
    
    fill(50);
    textSize(14);
    textAlign(LEFT, CENTER);
    text("BEST", barX + barW + 10, barY + 25);
    
    //3・2・1のカウントダウン表示
    if (isStartDashed && DashCountDown > 0) {
      int countNum = ceil(DashCountDown / 60.0);
      //画面全体を薄い黒で覆う
      fill(0, 0, 0, 100); 
      noStroke();
      rect(0, 0, width, height);
      fill(255, 50, 50); //赤色で強調
      textSize(160);
      textAlign(CENTER, CENTER);
      text(countNum, width / 2, height / 2);
    }
  }
  
  //プレイヤーの描画
  //穴に落ちている最中、隠れていくようにクリッピング領域を設定する
  if (isFalling && playerY > 450) {
  //地面（Y=450）より下にいく部分を消す
    clip(0,0,width, 450);
  }

  //プレイヤー本体の描画
  fill(50, 200, 50);
  noStroke();
  rect(playerX - 25, playerY - 80, 50, 80);

  // クリッピングをかけた場合は、必ず元に戻す
  if (isFalling && playerY > 450) {
    noClip();
  }
  
  //ブースト中の演出
  if (drinkTimer > 0 && isRaceStarted && mutekiTimer == 0) {
    noStroke();
    // 残像1
    fill(50, 200, 50, 150); 
    rect(playerX - 25, playerY - 80, 50, 80);
    // 残像2
    fill(50, 200, 50, 100);  
    rect(playerX - 50, playerY - 80, 50, 80);
    
    //線のスタイル設定
    stroke(255, 200);
    strokeWeight(4);
    //ランダムな横線を複数本描く
    for (int i = 0; i < 5; i++) {
      //プレイヤーの少し後方から前へ向かって流れる線
      float lineX = playerX - 60 + random(-100, 50);
      float lineY = playerY - 30 + random(-80, 80);
      float lineLength = random(30, 80);
      line(lineX, lineY, lineX + lineLength, lineY);
    }
  }
  
  //UI表示
  fill(50);
  textSize(20);
  textAlign(LEFT, TOP);
  //進行度の表示
  float progress = min(runDistance / goalLine, 1.0);
  text("進捗:" + int(progress * 100) + "%", 30, 20);
  if(isRaceStarted){
    textAlign(CENTER, CENTER);
    text("【SPACEキー】でジャンプ！", width / 2, 50);
  }
  
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
  //ドリンク効果中の演出（バーを表示するなど）
  if (drinkTimer > 0 && isRaceStarted){
    noStroke(); fill(100, 255, 100, 150); // 薄い緑色
    rect(30, 50, drinkTimer, 10, 5); // 残り時間バー
  }
  fill(50);
  textSize(16);
  textAlign(RIGHT, TOP);
  String jumpStatus = "なし";
  if (hasDoubleJump) {
    if (canDoubleJump || isGround) {
      jumpStatus = "【使用可能】";
    } else {
      jumpStatus = "【使用済み】";
    }
  }
  text("二段ジャンプ: " + jumpStatus, width - 30, 50);
  textAlign(CENTER, CENTER); // textAlignを元に戻す
}

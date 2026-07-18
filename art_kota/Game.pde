// 画面の状態を管理する変数（0ならスタート画面,1ならホーム画面,2ならレース,）
int gameState = 0;
int turnCount = 5;//ターンの変数
// ボタンの配置やサイズ
float start_yoko, start_tate, startX, startY;
float[] circleX = new float[4];//X座標しか変わらないから
float circleY, circleR;
//お金の初期値
int money = 50000;
//画像を保存する変数
PImage charaImg;
PImage[] selectImgs = new PImage[4];//選択肢用

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

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  PFont font = createFont("MS Gothic", 24); //日本語でも文字化けしないように
  textFont(font);
  //画像の読み込み
  charaImg = loadImage("syuzinkou_tmp.jpg");
  
  selectImgs[0] = loadImage("manjaro_tmp.png");
  selectImgs[1] = loadImage("kari.png");
  selectImgs[2] = loadImage("kari2.png");
  selectImgs[3] = loadImage("kari3.png");
  
  //スタートボタンの位置とサイズ設定
  start_yoko = 200;
  start_tate = 60;
  startX = width / 2 - start_yoko / 2;
  startY = height * 0.7; //画面のやや下
  
  //ホーム画面の4つの丸ボタンの設定
  circleY = height * 0.85;   //画面の下らへん
  circleR = 150;             //丸の直径
  float space = width / 5; //画面を５等分
  for (int i = 0; i < 4; i++) {
    circleX[i] = space * (i + 1);
  }
}

void draw() {
  background(240); //画面の背景色をクリア
  if (gameState == 0) {
    StartView();
  } else if (gameState == 1) {
    HomeView();
  } else if (gameState == 2) {
    RaceView();
  } else if (gameState == 3) {
    GameClearView();
  }
}

//---スタート画面---
void StartView() {
  // タイトル
  fill(50);
  textSize(48);
  text("ここにタイトル", width / 2, height * 0.3);
  // STARTボタンの描画
  // マウスがボタンの上にある時は色を変える
  if ((mouseX > startX && mouseX < startX + start_yoko) && (mouseY > startY && mouseY < startY + start_tate)) {
    fill(180);
  } else {
    fill(220);
  }
  stroke(50);
  strokeWeight(2);
  rect(startX, startY, start_yoko, start_tate, 10); //角丸の四角
  //ボタンの文字
  fill(50);
  textSize(24);
  text("START", width / 2, startY + start_tate / 2);
}

//---ホーム画面---
void HomeView() {
  //中央のキャラクター（仮の画像）
  imageMode(CENTER);//画像の中心を基準位置に
  if (charaImg != null) { //画像が正しく読み込めていれば
    image(charaImg, width / 2, height / 2, 250, 400);
  }
  //左上に残りターン数
  imageMode(CORNER);
  textAlign(LEFT, TOP);
  fill(250, 50, 50);
  textSize(26);
  text("残り日数:" + turnCount + "日", 30, 20);
  
  //右上の所持金表示
  textAlign(RIGHT, TOP); //右上を基準に文字を書く設定に変更
  fill(50);
  textSize(24);
  //nf()で使うことで3桁区切りのカンマを自動で
  text("所持金:￥" + nf(money, 0), width - 30, 20); 
  textAlign(CENTER, CENTER);

  // 画面下の4つの丸ボタンの描画
  for (int i = 0; i < 4; i++) {
    // マウスが丸の中にあるか判定（距離で計算）
    float d = dist(mouseX, mouseY, circleX[i], circleY);
    
    imageMode(CENTER);
    if (selectImgs[i] != null) {//画像が読み込めていたら
      image(selectImgs[i], circleX[i], circleY, circleR, circleR);
    }
    
    if (d < circleR / 2) {
      noStroke();
      fill(255, 255, 255, 10); //マウスが上にあれば光る
      ellipse(circleX[i], circleY, circleR, circleR);
    } else {//マウスが上になければ暗く
      noStroke();
      fill(0, 0, 0, 100);
      ellipse(circleX[i], circleY, circleR, circleR);
    }
    //選択肢の枠
    noFill();             // 中身は塗らない
    stroke(0);           // 線の色
    strokeWeight(3);      // 線の太さ
    ellipse(circleX[i], circleY, circleR, circleR);
    //選択肢の名前
    imageMode(CORNER);
    fill(0);
    textSize(20);
    if(i==0)
      text("マンジャロ", circleX[i], circleY - 40);
    else if(i==2)
       text("ランニング", circleX[i], circleY-40);
  }
}
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

//---ゲームクリア画面---
void GameClearView(){
  fill(50, 180, 50);
  textSize(64);
  text("GAME CLEAR!", width / 2, height * 0.4);
  fill(50);
  textSize(24);
  text("無事にゴールしました！", width / 2, height * 0.55);
  text("クリックでタイトルへ戻る", width / 2, height * 0.7);
}

//マウスクリック時の判定
void mousePressed() {
  //スタート画面のとき
  if (gameState == 0) {
    if ((mouseX > startX && mouseX < startX + start_yoko) && (mouseY > startY && mouseY < startY + start_tate)) {
      turnCount = 5;//日数をリセット
      gameState = 1;//ホーム画面へ切り替え
    }
  } 
  //ホーム画面のとき
  else if (gameState == 1){
    for (int i = 0; i < 4; i++){
      float d = dist(mouseX, mouseY, circleX[i], circleY);
      if (d < circleR / 2){
        // ここにミニゲーム開始の処理を書いていく
        println("ミニゲーム " + (i + 1) + " が押されました！");
        
        turnCount--;
        if(i == 0)
          money -= 10000;
        if(turnCount <= 0){
          resetRace();
          gameState = 2;
        }
      }
    }
  }
  else if(gameState == 3){
    money = 50000;
    gameState = 0;
  }
}
void keyPressed() {
  if (gameState == 2 && key == ' ' && isGround){
    playerV = jump;
    isGround = false;
  }
}

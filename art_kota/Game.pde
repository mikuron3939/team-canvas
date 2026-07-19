//画面の状態を管理する変数（0ならスタート画面,1ならホーム画面,2ならレース,3ならクリア）
int gameState = 0;
int turnCount = 5;//ターンの変数
//ボタンの配置やサイズ
float start_yoko, start_tate, startX, startY;
float[] circleX = new float[4];//X座標しか変わらないから
float circleY, circleR;
//お金の初期値
int money = 50000;
//体重の初期化
int weight = 120;
//画像を保存する変数
PImage charaImg;
PImage[] selectImgs = new PImage[4];//選択肢用
PImage targetImg;
PImage dartHandImg;
PImage[] trainingImgs = new PImage[3];//筋トレ用

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  PFont font = createFont("MS Gothic", 24); //日本語でも文字化けしないように
  textFont(font);
  //画像の読み込み
  charaImg = loadImage("syuzinkou_tmp.jpg");
  
  selectImgs[0] = loadImage("manjaro_tmp.png");
  selectImgs[1] = loadImage("kari1.png");
  selectImgs[2] = loadImage("kari2.png");
  selectImgs[3] = loadImage("kari3.png");
  
  targetImg = loadImage("target.png");
  dartHandImg = loadImage("darts_hand.png");
  
  trainingImgs[0] = loadImage("training1.png");
  trainingImgs[1] = loadImage("training2.png");
  trainingImgs[2] = loadImage("training3.png");
  
  //スタートボタンの位置とサイズ設定
  start_yoko = 200;
  start_tate = 60;
  startX = width / 2 - start_yoko / 2;
  startY = height * 0.7;
  
  //ホーム画面の4つの丸ボタンの設定
  circleY = height * 0.85;   //画面の下らへん
  circleR = 150;             //丸の直径
  float space = width / 5; //画面を５等分
  for (int i = 0; i < 4; i++) {
    circleX[i] = space * (i + 1);
  }
}

void draw() {
  background(0,50,200); //画面の背景色をクリア
  if (gameState == 0) {
    StartView();
  } else if (gameState == 1) {
    HomeView();
  } else if (gameState == 2) {
    RaceView();
  } else if (gameState == 3) {
    GameClearView();
  } else if (gameState == 4) {
    DartsView();
  } else if (gameState == 5) {
    TrainingView();
  }
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
        //ミニゲーム開始の処理を書いていく
        if(i == 0){
          money -= 10000;
          resetDarts();
          gameState = 4;
          turnCount--;
        } 
        else if(i == 1){
          resetTraining();
          gameState = 5;
          turnCount--;
        }
        else{
          turnCount--;
        }
      }
    }
  }
  else if(gameState == 3){
    money = 50000;
    gameState = 0;
  }
  else if (gameState == 4){
    if(isDartsFinished){
      gameState = 1;
    //もしダーツ側の終了処理でgameStateが1（ホーム）に戻っており、かつターンが0ならレースへ
      if (gameState == 1 && turnCount <= 0){
        resetRace();
        gameState = 2;
      }
    }
  }
  else if (gameState == 5){
    //筋トレが完了している状態でクリックされたらホームへ
    if (isTrainingFinished) {
      gameState = 1; 
      //もしターンが0ならそのままレースへ
      if (turnCount <= 0) {
        resetRace();
        gameState = 2;
      }
    }
  }
}
void keyPressed(){
  if (gameState == 2 && key == ' ' && isGround){
    playerV = jump;
    isGround = false;
  }
  else if (gameState == 4 && key == ' '){
    if (!isDartsFinished){
      stopDartsBar();
    }
  }
  else if (gameState == 5 && key == ' '){
    if (!isTrainingFinished){
      trainingSpacePressed();
    }
  }
}

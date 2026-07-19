//画面の状態を管理する変数（0ならスタート画面,1ならホーム画面,2ならレース,3ならクリア）
int gameState = 0;
int turnCount = 5;//ターンの変数
//ボタンの配置やサイズ
float start_yoko, start_tate, startX, startY;
float[] circleX = new float[4];//X座標しか変わらないから
float circleY, circleR;
//お金の初期値
int money = 50000;
//画像を保存する変数
PImage charaImg;
PImage[] selectImgs = new PImage[4];//選択肢用
PImage targetImg;
PImage dartHandImg;

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
  
  targetImg = loadImage("target.png");
  dartHandImg = loadImage("darts_hand.png");
  
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
  background(240); //画面の背景色をクリア
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
        // ここにミニゲーム開始の処理を書いていく
        println("ミニゲーム " + (i + 1) + " が押されました！");
        
        if(i == 0){
          money -= 10000;
          resetDarts();
          gameState = 4;
          turnCount--;
        } else{
          turnCount--;
          if(i == 1){}
        }
         if(turnCount <= 0 && gameState == 1){//最後のミニゲームに割り込まないように
          resetRace();//Raceタブから開かれる
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
  else if (gameState == 4 && key == ' ') {
    stopDartsBar();
    if (gameState == 1 && turnCount <= 0) {
      resetRace();
      gameState = 2;
    }
  }
}

//画面の状態を管理する変数
//（0ならスタート画面,1ならホーム画面,
//2ならレース,3ならクリア,4ならダーツ,5なら筋トレ,8ならアイテム購入）
int gameState = 0;
int turnCount = 5;//ターンの変数
//ボタンの配置やサイズ
float start_yoko, start_tate, startX, startY;
float[] circleX = new float[4];//X座標しか変わらないから
float circleY, circleR;
//お金の初期値
int money = 50000;
//体重の初期化
int weight = 100;
//OP
boolean isFirst = true;
boolean isNextWeek = false;
//shop
//shoes
int shoesLevel = 0;//靴のランク
int[] shoesPrices = {0,5000,10000,15000};//靴の価格
float jumpPower = 0;//最終的なジャンプ力
float nextX,nextY,next_yoko,next_tate;
//drink
int drinkLevel = 0;
int[] drinkPrices = {0,5000,10000,15000};
boolean isDrinkUsed = false;

//画像を保存する変数
PImage start_image;
PImage start_logo;
PImage opImg;
PImage[] charaImg = new PImage[4];
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
  start_image = loadImage("start_image.png");
  start_logo = loadImage("start_logo.png");
  
  opImg = loadImage("op.png");
  
  charaImg[0] = loadImage("100kg.png");
  charaImg[1] = loadImage("80kg.png");
  charaImg[2] = loadImage("65kg.png");
  charaImg[3] = loadImage("50kg.png");
  
  selectImgs[0] = loadImage("manjaro.png");
  selectImgs[1] = loadImage("kari1.png");
  selectImgs[2] = loadImage("kari2.png");
  selectImgs[3] = loadImage("kari3.png");
  
  targetImg = loadImage("target.png");
  dartHandImg = loadImage("darts_hand.png");
  
  trainingImgs[0] = loadImage("training1.png");
  trainingImgs[1] = loadImage("training2.png");
  trainingImgs[2] = loadImage("training3.png");
  
  //進むボタン
  next_yoko = 160;
  next_tate = 50;
  nextX = width - next_yoko - 30;
  nextY = height - next_tate - 30;
}

void draw() {
  background(255); //画面の背景色をクリア
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
  } else if (gameState == 8) {
    ShopView();
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
    //設定の説明OP
    if (isFirst) {
      isFirst = false;
      return;
    }
    if(isNextWeek){
      isNextWeek = false;
      if(turnCount <= 0){
        gameState = 8;
      }
      return;
    }
    for (int i = 0; i < 4; i++){
      float d = dist(mouseX, mouseY, circleX[i], circleY);
      if (d < circleR / 2){
        //ミニゲーム開始の処理
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
  //ホーム
  else if(gameState == 3){
    money = 50000;
    gameState = 0;
  }
  //ダーツ
  else if (gameState == 4){
    if(isDartsFinished){
      gameState = 1;
      isNextWeek = true;
    }
  }
  //筋トレ
  else if (gameState == 5){
    //筋トレが完了している状態でクリックされたらホームへ
    if (isTrainingFinished) {
      weight -= 10;
      kabeSpeed += 1;
      gameState = 1; 
      isNextWeek = true;
    }
  }
  //shop
  else if (gameState == 8) {
    float botan_yoko = 180;
    float botan_tate = 80;
    float shoesY = height * 0.3;
    
    // 3つの靴ボタンの判定
    for (int i = 0; i < 3; i++) {
      float botanX = 60 + i * (botan_yoko + 40);
      if (mouseX > botanX && mouseX < botanX + botan_yoko && mouseY > shoesY && mouseY < shoesY + botan_tate) {
        int targetLevel = i + 1; //1～3段階
        int price = shoesPrices[targetLevel];
        // お金が足りていて、まだ持っていない上位の靴なら購入
        if (money >= price && shoesLevel < targetLevel) {
          money -= price;
          shoesLevel = targetLevel;
        }
      }
    }
    float drinkY = height * 0.6;
    for (int i = 0; i < 3; i++) {
      float botanX = 60 + i * (botan_yoko + 40);
      if (mouseX > botanX && mouseX < botanX + botan_yoko && mouseY > drinkY && mouseY < drinkY + botan_tate) {
        int targetLevel = i + 1;
        int price = drinkPrices[targetLevel];
        
        // お金が足りていて、まだ持っていない上位のドリンクなら購入
        if (money >= price && drinkLevel < targetLevel) {
          money -= price;
          drinkLevel = targetLevel;
        }
      }
    }
    //レースへ進むボタン
    if (mouseX > nextX && mouseX < nextX + next_yoko && mouseY > nextY && mouseY < nextY + next_tate) {
      
      //体重と靴のレベルからジャンプ力を計算
      float baseJump = 15 + (shoesLevel * 2); 
      float weightPenalty = (weight - 60)*0.5; // 体重60kg基準で、重いほどペナルティ
      jumpPower = baseJump - weightPenalty;
      
      //ジャンプ力の最低値を保証（重すぎて飛べないのを防ぐ）
      if (jumpPower < 3) 
        jumpPower = 3; 
      //レース開始処理へ
      resetRace();
      gameState = 2;
    }
  }
}
void keyPressed(){
  if (gameState == 2 && key == ' ' && isGround){
    playerV = -jumpPower;
    isGround = false;
  } else if (gameState == 2 && (key == 'e' || key == 'E')){
    //ドリンクを持ってる&まだ使っていない&ゴール前で、被弾中でない
    if (drinkLevel > 0 && !isDrinkUsed && !isGoalSpawned && mutekiTimer == 0) {
      isDrinkUsed = true;
      drinkTimer = 180;//約3秒間
      //レベルに応じて加速力を変える
      if (drinkLevel == 1) drinkBoost = 3;//小加速
      else if (drinkLevel == 2) drinkBoost = 6;//中加速
      else if (drinkLevel == 3) drinkBoost = 10;//大加速
    }
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

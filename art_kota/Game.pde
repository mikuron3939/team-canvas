//画面の状態を管理する変数
//（0ならスタート画面,1ならホーム画面,
//2レース,3クリア,4ダーツ,5筋トレ,6食制限,8ならアイテム購入）
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

//画像を保存する変数
PImage start_image;
PImage start_logo;
PImage opImg;
PImage[] charaImg = new PImage[4];
PImage[] selectImgs = new PImage[4];//選択肢用
PImage moneyImg;
PImage calenderImg;
PImage[] targetImgs = new PImage[4];
PImage dartHandImg;
PImage dartTextImg;
PImage[] trainingImgs = new PImage[3];//筋トレ用
PImage trainingBgImg;
PImage hardleImg;
PImage hardle_hitImg;
PImage raceBackImg;

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  //フォント
  PFont font = createFont("KiwiMaru-Regular.ttf", 24);
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
  selectImgs[1] = loadImage("training.png");
  selectImgs[2] = loadImage("kari2.png");
  selectImgs[3] = loadImage("kari3.png");

  moneyImg = loadImage("money.png");
  calenderImg = loadImage("calender.png");

  targetImgs[0] = loadImage("target100kg.png");
  targetImgs[1] = loadImage("target80kg.png");
  targetImgs[2] = loadImage("target65kg.png");
  targetImgs[3] = loadImage("target50kg.png");

  dartHandImg = loadImage("darts_hand.png");
  dartTextImg = loadImage("dartText.png");

  trainingBgImg= loadImage("trainingBg.png");

  hardleImg = loadImage("hardle.png");
  hardle_hitImg = loadImage("hardleHit.png");
  raceBackImg = loadImage("raceBack.png");

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
  } else if (gameState == 6) {
    drawEat();
  } else if (gameState == 7) {
    drawSauna();
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
  else if (gameState == 1) {
    //設定の説明OP
    if (isFirst) {
      isFirst = false;
      return;
    }
    if (isNextWeek) {
      isNextWeek = false;
      if (turnCount <= 0) {
        gameState = 8;
      }
      return;
    }
    for (int i = 0; i < 4; i++) {
      float d = dist(mouseX, mouseY, circleX[i], circleY);
      if (d < circleR / 2) {
        //ミニゲーム開始の処理
        if (i == 0) {
          money -= 10000;
          resetDarts();
          gameState = 4;
          turnCount--;
        } else if (i == 1) {
          resetTraining();
          gameState = 5;
          turnCount--;
        } else if (i == 2) {
          resetEat();
          gameState = 6;
          turnCount--;
        } else {
          saunaRound = 1;
          saunaTempWeightLoss = 0;
          isSaunaFinished = false;
          saunaResultText = "";
          
          gameState = 7; 
          turnCount--;
        }
      }
    }
  }
  //ホーム
  else if (gameState == 3) {
    money = 50000;
    gameState = 0;
  }
  //ダーツ
  else if (gameState == 4) {
    if (isDartsFinished) {
      if (dartsResultStr.equals("BAD")) {
        weight -= 5;
      } else if (dartsResultStr.equals("PERFECT!!")) {
        weight -= 12;
      } else if (dartsResultStr.equals("NICE!")) {
        weight -= 10;
      }
      gameState = 1;
      isNextWeek = true;
    }
  }
//筋トレ
else if (gameState == 5){

  if(isTrainingFinished){

    if(trainingResultStr.equals("BAD")){
      weight -= 5;
    }
    else if(trainingResultStr.equals("NICE!")){
      weight -= 8;
    }
    else if(trainingResultStr.equals("PERFECT!!")){
      weight -= 10;
    }

    kabeSpeed += 1;
    gameState = 1;
    isNextWeek = true;
  }

}
  //食制限
  else if (gameState == 6) {
    eatCheckClick();
    if (isEatFinished) {
      if (score >= 200) {
        weight -= 8; // 高得点なら体重がたくさん減る
      } else {
        weight -= 4;
      }
      gameState = 1;
      isNextWeek = true;
    }
  }
  //サウナ
  else if (gameState == 7) { 
    mousePressedSauna(); 
  }
  //shop
  else if (gameState == 8) {
    float botan_yoko = 180;
    float botan_tate = 80;
    float shoesY = height * 0.3;
 
    //3つの靴ボタンの判定
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
    //3つのドリンクボタンの判定
    float drinkY = 290;
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
    //特殊能力
    float itemSelect_yoko = 180;
    float itemSelect_tate = 60;
    float jumpItemX = 60;
    float jumpY = 420;
    int jumpPrice = 3000;
  
    if (mouseX >= jumpItemX && mouseX <= jumpItemX + itemSelect_yoko &&
        mouseY >= jumpY && mouseY <= jumpY + itemSelect_tate) {
      if (!ownDoubleJump && money >= jumpPrice) {
        money -= jumpPrice;
        ownDoubleJump = true; // 購入完了！
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
void keyPressed() {
  if (gameState == 2) {
    //レース前
    if (!isRaceStarted && !isStartDashed) {
      if (key == ' ') {
        isStartDashed = true;
        DashCountDown = 180;
        //スタートダッシュに応じてブーストを決定
        if (raceBar >=  0.8) {
          startMessage = "SUPER START!!";
          startDashColor = color(50, 255, 50);
          drinkBoost = 10; // 強力な加速
          drinkTimer = 360; // 約2秒持続
        } else if (raceBar >= 0.4) {
          startMessage = "GOOD START!";
          startDashColor = color(50, 200, 50);
          drinkBoost = 5; // 中くらいの加速
          drinkTimer = 300;
        } else {
          startMessage = "LATE...";
          startDashColor = color(150, 150, 150);
          drinkBoost = 0; // 加速なし
        }
      }
      return;
    }
    //レース中
    //通常ジャンプ
    if (isRaceStarted){
      if (key == ' ') {
        if (isGround) {
          playerV = -jumpPower;
          isGround = false;
          canDoubleJump = true;
        } else if(ownDoubleJump && canDoubleJump) {
            playerV = -jumpPower + jumpPower/3; // 空中ジャンプの強さ
            canDoubleJump = false; // 使い切ったので消す
            isSecondJumping = true;
        }
      }
      else if (key == 'e' || key == 'E'){
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
    }
  }
   else if (gameState == 4 && key == ' ') {
    if (!isDartsFinished) {
      stopDartsBar();
    }
  } else if (gameState == 5) {
    if (key == ' ') {
      trainingSpacePressed();
    }
    if (keyCode == ENTER || keyCode == RETURN) {
      stopTraining();
    }
  }
}

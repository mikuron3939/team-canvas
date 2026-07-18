// 画面の状態を管理する変数（0ならスタート画面,1ならホーム画面）
int gameState = 0;
// ボタンの配置やサイズ
float start_yoko, start_tate, startX, startY;
float[] circleX = new float[4];//X座標しか変わらないから
float circleY, circleR;
//お金の初期値
int money = 50000;
//画像を保存する変数
PImage charaImg;
PImage[] selectImgs = new PImage[4];//選択肢用

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

//マウスクリック時の判定
void mousePressed() {
  //スタート画面のとき
  if (gameState == 0) {
    if ((mouseX > startX && mouseX < startX + start_yoko) && (mouseY > startY && mouseY < startY + start_tate)) {
      gameState = 1; // ホーム画面へ切り替え
    }
  } 
  // ホーム画面のとき
  else if (gameState == 1) {
    for (int i = 0; i < 4; i++) {
      float d = dist(mouseX, mouseY, circleX[i], circleY);
      if (d < circleR / 2) {
        // ここにミニゲーム開始の処理を書いていく
        println("ミニゲーム " + (i + 1) + " が押されました！");
      }
    }
  }
}

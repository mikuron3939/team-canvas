//---ホーム画面---
void HomeView() {
  //中央のキャラクター
  imageMode(CORNER);
  if(weight <= 50){
    if (charaImg != null) { //画像が正しく読み込めていれば
      image(charaImg[3],0 , 0, width, height);
    }
  }else if(weight <= 65){
    if (charaImg != null) { //画像が正しく読み込めていれば
      image(charaImg[2],0 , 0, width, height);
    }
  }else if(weight <= 80){
    if (charaImg != null) { //画像が正しく読み込めていれば
      image(charaImg[1],0 , 0, width, height);
    }
  }else{
    if (charaImg != null) { //画像が正しく読み込めていれば
      image(charaImg[0],0 , 0, width, height);
      }
  }
  
  //左上に残りターン数
  textAlign(LEFT, TOP);
  fill(250, 50, 50);
  textSize(26);
  text("残り日数:" + turnCount + "日", 30, 20);
  
  //右上の所持金表示
  textAlign(RIGHT, TOP); //右上を基準に文字を書く設定に変更
  fill(50);
  textSize(35);
  //nf()で使うことで3桁区切りのカンマを自動で
  text("所持金:￥" + nf(money, 0), width - 30, 20); 
  textAlign(CENTER, CENTER);
  //右上に体重を表示
  textAlign(RIGHT, TOP); //右上を基準に文字を書く設定に変更
  fill(50);
  textSize(35);
  text("体重:" + weight + "kg", width - 50, 60); 
  textAlign(CENTER, CENTER);

  //ホーム画面の4つの丸ボタンの設定
    circleY = height * 0.85;   //画面の下らへん
    circleR = 150;             //丸の直径
    float space = width / 5; //画面を５等分
    for (int i = 0; i < 4; i++) {
      circleX[i] = space * (i + 1);
    }
  
  // 画面下の4つの丸ボタンの描画
  for (int i = 0; i < 4; i++) {
    // マウスが丸の中にあるか判定（距離で計算）
    float d = dist(mouseX, mouseY, circleX[i], circleY);
    
    imageMode(CENTER);
    if (selectImgs[i] != null) {//画像が読み込めていたら
      if(i == 0){
        fill(230,0,230);
      }else{
        fill(255, 255, 255);
      }
      ellipse(circleX[i], circleY, circleR, circleR);
      image(selectImgs[i], circleX[i], circleY, circleR, circleR);
    }
    
    if (d < circleR / 2) {
      noStroke();
      fill(255, 255, 255, 10); //マウスが上にあれば光る
      ellipse(circleX[i], circleY, circleR, circleR);
      if(i == 0){
        fill(0,200);
        rect(circleX[i]-100, circleY - 130,circleX[i] + 50,50);
        fill(255);
        stroke(0); 
        textSize(30);
        text("マンジャロ", circleX[i], circleY - 120);
        textSize(20);
        fill(255,0,0);
        text("-10,000円", circleX[i] - 40, circleY - 90);
        fill(80,255,0);
        text("-??kg", circleX[i] + 40, circleY - 90);
      }
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
    fill(255);
    stroke(0); 
    textSize(20);
    if(i==1)
       text("筋トレ", circleX[i], circleY-40);
    else if(i==2)
       text("", circleX[i], circleY-40);
  }
  //OP
  if (isFirst){
    //画面全体を薄い黒で覆う
    fill(0, 0, 0, 250); 
    noStroke();
    rect(0, 0, width, height);
    //説明テキスト
    textAlign(CENTER, CENTER);
    fill(255); // 文字は白
    textSize(32);
    text("〜設定の説明〜", width / 2, height * 0.3);
    // 閉じる案内
    fill(250, 250, 100); // 目立つ黄色
    textSize(18);
    text("【 画面をクリックしてゲームを始める 】", width / 2, height * 0.8);
    textAlign(CENTER, CENTER); // 設定を戻しておく
  }
}

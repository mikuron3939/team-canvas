void ShopView() {
  background(40, 50, 60);//ショップの背景
  //Shopの名前
  fill(255);
  textSize(32);
  text("ーーItem_Shopーー", width / 2, 50);
  //所持金と現在の体重表示
  textSize(20);
  fill(255, 215, 0);
  text("所持金:" + money + "円", width / 2, 100);
  fill(200, 230, 255);
  text("体重:" + weight + "kg", width / 2, 130);
  
  float itemSelect_yoko = 180;
  float itemSelect_tate = 70;
  float shoesY = height * 0.3; //靴ボタンの縦位置
  float drinkY = height * 0.6;
  
  //靴のラインナップ描画
  String[] shoesNames = {"サンダル", "スニーカー", "ランニングシューズ"};
  String[] shoesPop = {"普通のジャンプ力", "高く跳べる軽量シューズ", "驚異の反発力を持つ最高級品"};
  //ドリンクのラインナップ
  String[] drinkNames = {"水", "スポーツドリンク", "最高級スポドリ"};
  String[] drinkPop = {"少しだけ加速する", "そこそこ加速する", "猛烈に加速する(1回)"};
  
  fill(255); 
  textSize(22);
  textAlign(LEFT, CENTER);
  text("▼シューズ(ジャンプ力UP)", 60, shoesY - 30);
  textAlign(CENTER, CENTER);
  
  for (int i = 0; i < 3; i++) {
    int currentLv = i + 1;
    float itemSelectX = 60 + i * (itemSelect_yoko + 40);
    
    // ボタンの背景色（すでに購入済みなら緑、お金不足なら暗い赤、買えるならグレー）
    if (shoesLevel >= currentLv) {
      fill(50, 150, 50); // 購入済み
    } else if (money < shoesPrices[currentLv]) {
      fill(100, 50, 50); // お金足りない
    } else {
      fill(250, 250, 0); // 購入可能
    }
    
    stroke(255);
    strokeWeight(2);
    rect(itemSelectX, shoesY, itemSelect_yoko, itemSelect_tate, 10);
    
    // ボタンのテキスト
    fill(0);
    textSize(20);
    text(shoesNames[i], itemSelectX + itemSelect_yoko/2, shoesY + 20);
    textSize(16);
    if (shoesLevel >= currentLv) {
      text("購入済み", itemSelectX + itemSelect_yoko/2, shoesY + 55);
    } else {
      text(shoesPrices[currentLv] + "円",itemSelectX + itemSelect_yoko/2, shoesY + 50);
    }
    
    // 説明文
    fill(255);
    textSize(14);
    text(shoesPop[i], itemSelectX + itemSelect_yoko/2, shoesY + itemSelect_tate + 25);
  }
  
  fill(255); 
  textSize(22); 
  textAlign(LEFT, CENTER);
  text("▼ ドリンク (【E】キーで使用)", 60, drinkY - 30);
  textAlign(CENTER, CENTER);
  
  for (int i = 0; i < 3; i++) {
    int currentLv = i + 1;
    float itemSelectX = 60 + i * (itemSelect_yoko + 40);
    
    //ボタンの背景色判定（ドリンク)
    // 変数名 drinkLevel と drinkPrices は追加したものを使用します
    if (drinkLevel >= currentLv) {
      fill(50, 150, 50); // 購入済み
    } else if (money < drinkPrices[currentLv]) {
      fill(100, 50, 50); // お金足りない
    } else {
      fill(100, 110, 120); // 購入可能
    }
    stroke(255);
    strokeWeight(2);
    rect(itemSelectX, drinkY, itemSelect_yoko, itemSelect_tate, 10);
    
    // --- ボタン内のテキスト ---
    fill(255);
    textSize(19);
    text(drinkNames[i], itemSelectX + itemSelect_yoko/2, drinkY + 22);
    
    textSize(15);
    if (drinkLevel >= currentLv) {
      text("購入済み", itemSelectX + itemSelect_yoko/2, drinkY + 50);
    } else {
      // 追加した drinkPrices を参照
      text(drinkPrices[currentLv] + " 円", itemSelectX + itemSelect_yoko/2, drinkY + 50);
    }
    
    // --- 説明文（ボタンの下） ---
    fill(210);
    textSize(13);
    text(drinkPop[i], itemSelectX + itemSelect_yoko/2, drinkY + itemSelect_tate + 25);
  }
  
  //現在の装備ステータス
  fill(255);
  textSize(18);
  String currentShoes = "裸足";
  if(shoesLevel == 1) currentShoes = "サンダル";
  if(shoesLevel == 2) currentShoes = "スニーカー";
  if(shoesLevel == 3) currentShoes = "ランニングシューズ";
  text("現在の装備: " + currentShoes, width / 2, height * 0.85);
  
  String currentDrink = "なし";
  if(drinkLevel == 1) currentDrink = "水";
  if(drinkLevel == 2) currentDrink = "スポーツドリンク";
  if(drinkLevel == 3) currentDrink = "最高級のスポーツドリンク";
  text("現在の装備: " + currentDrink, width / 2, height * 0.95);
  
  //レースへ進む
  fill(200, 80, 40);
  if (shoesLevel == 0) fill(120); // 靴を買わない選択のときは少し控えめな色に
  rect(nextX, nextY, next_yoko, next_tate, 8);
  fill(255);
  textSize(18);
  text("レースへ進む ➔", nextX + next_yoko/2, nextY + next_tate/2);
}

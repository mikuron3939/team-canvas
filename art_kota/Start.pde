//---スタート画面---
void StartView() {
  if(start_image != null){
    image(start_image,0,0,width,height);
  }
  //タイトルロゴ
  if(start_logo != null){
    image(start_logo,width * 0.08, height * 0.1,600,600);
  }
  
  //スタートボタンの位置とサイズ設定
  start_yoko = 200;
  start_tate = 60;
  startX = width / 2 - start_yoko / 2 + 30;
  startY = height * 0.8;
  // STARTボタンの描画
  // マウスがボタンの上にある時は色を変える
  if ((mouseX > startX && mouseX < startX + start_yoko) && (mouseY > startY && mouseY < startY + start_tate)) {
    fill(180,180,0,200);
  } else {
    fill(255,255,0,200);
  }
  stroke(50);
  strokeWeight(2);
  rect(startX, startY, start_yoko, start_tate); //角丸の四角
  //ボタンの文字
  fill(50);
  textSize(50);
  text("START", width / 2 + 30, startY + start_tate / 2);
  }

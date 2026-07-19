//---スタート画面---
void StartView() {
  //タイトル
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

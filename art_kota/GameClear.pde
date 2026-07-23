//---ゲームクリア画面---
void GameClearView(){
  fill(50, 180, 50);
  textSize(64);
  text("GAME CLEAR!", width / 2, height * 0.3);
  fill(255, 0, 0);
   text("Time 00:00秒!", width / 2, height * 0.45);
  fill(50);
  textSize(24);
  text("成績...秀!!", width / 2, height * 0.55);
  text("クリックでタイトルへ戻る", width / 2, height * 0.7);
  imageMode(CORNER);
}

//---ゲームクリア画面---
void GameClearView(){
  fill(50, 180, 50);
  textSize(64);
  text("GAME CLEAR!", width / 2, height * 0.4);
  fill(50);
  textSize(24);
  text("無事にゴールしました！", width / 2, height * 0.55);
  text("クリックでタイトルへ戻る", width / 2, height * 0.7);
}

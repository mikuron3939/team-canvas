//---ゲームクリア画面---
void GameClearView() {
  String ClearTime = nf( resultRaceTime/60, 2, 2); //ゴールタイムを小数点第二位までに調整
  int ShuTime = 500;
  int YuTime = 600;
  int RyoTime = 700;
  int KaTime = 800;//値は仮
  //成績評価
  fill(255, 0, 0);
  if (resultRaceTime <= ShuTime) {
    text("成績...秀!!", width / 2, height * 0.55);
  } else if (resultRaceTime <= YuTime) {
    text("成績...優!!", width / 2, height * 0.55);
  } else if (resultRaceTime <= RyoTime) {
    text("成績...良!!", width / 2, height * 0.55);
  } else if (resultRaceTime <= KaTime) {
    text("成績...可!!", width / 2, height * 0.55);
  } else {
    text("成績...不可…", width / 2, height * 0.55);
  }
  if (KaTime >= resultRaceTime) {
    fill(50, 180, 50);
    textSize(64);
    text("GAME CLEAR!", width / 2, height * 0.3);
  }else{
    fill(25, 25, 200);
    textSize(64);
    text("GAME OVER…", width / 2, height * 0.3);
  }
    
    fill(255, 0, 0);
    text("Time " + ClearTime + "!!", width / 2, height * 0.45);
    fill(50);
    textSize(24);
    text("クリックでタイトルへ戻る", width / 2, height * 0.7);
    imageMode(CORNER);

weight = 100;//体重リセット
}

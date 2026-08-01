//---チュートリアル画面 (gameState = 9)---
void TutorialView() {
  background(255); // 背景の初期化
  
  // ページ状態に応じた画像の描画
  if (tutorialPage == 1) {
    if (tutorial1Img != null) {
      image(tutorial1Img, 0, 0, width, height);
    }
  } else if (tutorialPage == 2) {
    if (tutorial2Img != null) {
      image(tutorial2Img, 0, 0, width, height);
    }
  }
}

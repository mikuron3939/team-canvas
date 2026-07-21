<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>動作確認</title>
</head>
<body>
  <h1>こんにちは！</h1>
  <p>HTMLの動作確認ページです。</p>

  <button onclick="changeText()">クリック</button>
  <p id="message"></p>

  <script>
    function changeText() {
      document.getElementById("message").textContent = "ボタンがクリックされました！";
    }
  </script>
</body>
</html>

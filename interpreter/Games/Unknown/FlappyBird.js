var birdY = 30, birdVel = 0, gravity = 0.5, jump = -5;
var pipes = [], gap = 60, pipeWidth = 20, pipeSpeed = 2;
var score = 0, gameOver = false;

function resetGame() {
  birdY = 30;
  birdVel = 0;
  pipes = [];
  score = 0;
  gameOver = false;
}

function drawBird() {
  // Yellow body
  drawFillRect(10, birdY, 10, 10, color(255, 255, 0));
  // Longer orange beak
  drawFillRect(19, birdY + 4, 3, 2, color(255, 165, 0));
  // Eye
  drawPixel(12, birdY + 2, color(255, 255, 255));
}

function drawCloud(x, y) {
  // Bigger cloud
  var c = color(255, 255, 255);
  drawPixel(x, y, c);
  drawPixel(x + 1, y, c);
  drawPixel(x + 2, y, c);
  drawPixel(x + 3, y, c);
  drawPixel(x + 1, y - 1, c);
  drawPixel(x + 2, y - 1, c);
  drawPixel(x + 1, y + 1, c);
  drawPixel(x + 2, y + 1, c);
}

function drawSky() {
  fillScreen(color(135, 206, 250)); // light blue sky
  drawCloud(20, 10);
  drawCloud(60, 18);
  drawCloud(110, 6);
  drawCloud(140, 14);
}

function drawPipes() {
  var green = color(0, 100, 0); // darker green
  for (var i = 0; i < pipes.length; i++) {
    var pipe = pipes[i];
    drawFillRect(pipe.x, 0, pipeWidth, pipe.top, green);
    drawFillRect(pipe.x, pipe.bottom, pipeWidth, height() - pipe.bottom, green);
  }
}

function updatePipes() {
  for (var i = 0; i < pipes.length; i++) {
    pipes[i].x -= pipeSpeed;
    if (pipes[i].x + pipeWidth < 0) {
      pipes.splice(i, 1);
      i--;
    }
  }

  if (pipes.length === 0 || pipes[pipes.length - 1].x < width() - 100) {
    var top = Math.random() * (height() - gap - 20) + 10;
    pipes.push({ x: width(), top: top, bottom: top + gap });
  }
}

function checkCollision() {
  for (var i = 0; i < pipes.length; i++) {
    var pipe = pipes[i];
    if (
      10 < pipe.x + pipeWidth &&
      10 + 10 > pipe.x &&
      (birdY < pipe.top || birdY + 10 > pipe.bottom)
    ) {
      return true;
    }
  }
  return birdY < 0 || birdY + 10 > height();
}

function drawScore() {
  setTextSize(1);
  setTextColor(color(255, 255, 255));
  drawString("Score: " + score, 10, 10);
}

function gameLoop() {
  if (!gameOver) {
    drawSky();
    birdVel += gravity;
    birdY += birdVel;

    if (getSelPress()) birdVel = jump;
    if (getPrevPress()) {
      dialogMessage("Game exited!");
      return;
    }

    updatePipes();
    drawBird();
    drawPipes();
    drawScore();

    if (checkCollision()) {
      gameOver = true;
      dialogMessage("Game Over! Score: " + score);
      delay(2000);
      resetGame();
    }

    for (var i = 0; i < pipes.length; i++) {
      if (pipes[i].x + pipeWidth === 10) score++;
    }
  }

  delay(50);
  gameLoop();
}

resetGame();
gameLoop();
var paddleX = 60;
var paddleWidth = 40;
var paddleHeight = 6;
var ballX = 80;
var ballY = 60;
var ballSize = 5;
var ballSpeedX = 2;
var ballSpeedY = -2;
var score = 0;

// Colors
var paddleColor = 0x00FF00;
var borderColor = 0xFFFFFF;
var ballColor = 0xFFFFFF;

fillScreen(0);
setTextSize(1);
drawString('Scroll CW = Right', 5, 10);
drawString('Prev = Left', 5, 25);
drawString('Press M5 to Start', 5, 50);

// Wait for M5 to start
while (true) {
    if (getSelPress()) {
        delay(300);
        break;
    }
}

while (true) {
    fillScreen(0);

    // Left and Right Borders
    drawFillRect(0, 0, 2, 135, borderColor);
    drawFillRect(158, 0, 2, 135, borderColor);

    // Controls
    if (getNextPress() && paddleX + paddleWidth < 158) {
        paddleX += 4; // Faster movement
        delay(20);
    }
    if (getPrevPress() && paddleX > 2) {
        paddleX -= 4;
        delay(20);
    }

    // Draw paddle
    drawFillRect(paddleX, 125, paddleWidth, paddleHeight, paddleColor);
    drawFillRect(paddleX, 125, paddleWidth, 1, borderColor); // White top line

    // Draw white ball with outline
    drawFillRect(ballX, ballY, ballSize, ballSize, ballColor);
    drawFillRect(ballX, ballY, 1, ballSize, borderColor);  // Left outline
    drawFillRect(ballX, ballY, ballSize, 1, borderColor);  // Top outline

    // Ball movement
    ballX += ballSpeedX;
    ballY += ballSpeedY;

    // Bounce logic
    if (ballX <= 2 || ballX + ballSize >= 158) ballSpeedX *= -1;
    if (ballY <= 0) ballSpeedY *= -1;

    // Paddle bounce
    if (
        ballY + ballSize >= 125 &&
        ballX + ballSize > paddleX &&
        ballX < paddleX + paddleWidth
    ) {
        ballSpeedY *= -1;
        score++;
    }

    // Game over
    if (ballY > 135) {
        dialogMessage("Game Over! Score: " + score);
        delay(2000);
        break;
    }

    // Show score
    drawString("Score: " + String(score), 5, 5);

    // Exit with M5
    if (getSelPress()) {
        delay(300);
        break;
    }

    delay(20);
}
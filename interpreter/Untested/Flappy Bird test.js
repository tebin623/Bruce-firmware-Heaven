var g = Graphics.createArrayBuffer(135, 240, 16);

var birdY, velocity, gravity, jump, pipes, score, gameRunning, bestScore;
var bgX = 0;

bestScore = require("Storage").read("highscore") || 0;

function resetGame() {
    birdY = 120;
    velocity = 0;
    gravity = 0.5;
    jump = -6;
    pipes = [];
    score = 0;
    gameRunning = false;
    drawMenu();
}

function drawMenu() {
    g.clear();
    g.setColor(0, 0, 1);
    g.fillRect(0, 0, 135, 240);

    g.setColor(1, 1, 0);
    g.drawString("FLAPPY BIRD", 30, 50);
    g.drawString("High Score: " + bestScore, 10, 80);
    g.drawString("Press A to start", 20, 120);

    g.flip();
}

function draw() {
    g.clear();
    g.setColor(0, 0, 1);
    g.fillRect(0, 0, 135, 240);
    bgX = (bgX - 1) % 135;  
    g.setColor(0, 0.5, 0); 
    g.fillRect(bgX, 230, bgX + 135, 240);

    g.setColor(1, 1, 0);
    g.fillCircle(25, birdY + 5, 6);

    g.setColor(0, 1, 0);
    pipes.forEach(pipe => {
        g.fillRect(pipe.x, 0, pipe.x + 20, pipe.gapY);
        g.fillRect(pipe.x, pipe.gapY + 50, pipe.x + 20, 240);
    });

    g.setColor(1, 1, 1);
    g.drawString("Score: " + score, 5, 5);

    g.flip();
}

function update() {
    if (!gameRunning) return;

    velocity += gravity;
    birdY += velocity;
    pipes.forEach(pipe => { pipe.x -= 2; });

    if (pipes.length === 0 || pipes[pipes.length - 1].x < 80) {
        let gapY = Math.random() * 140 + 40;
        pipes.push({ x: 135, gapY: gapY });
    }

    if (pipes.length > 0 && pipes[0].x < -20) {
        pipes.shift();
        score++;
    }

    if (birdY < 0 || birdY > 230) gameOver();
    pipes.forEach(pipe => {
        if (20 < pipe.x + 20 && 30 > pipe.x) {
            if (birdY < pipe.gapY || birdY > pipe.gapY + 50) gameOver();
        }
    });

    draw();
}

function playSound(frequency, duration) {
    if (typeof analogWrite !== "undefined") {
        analogWrite(DAC1, 0.5, { freq: frequency });
        setTimeout(() => analogWrite(DAC1, 0), duration);
    }
}

function flap() {
    if (!gameRunning) {
        startGame();
    } else {
        velocity = jump;
        playSound(1000, 100);
    }
}

function startGame() {
    birdY = 120;
    velocity = 0;
    pipes = [];
    score = 0;
    gameRunning = true;
    setInterval(update, 30);
}

function gameOver() {
    gameRunning = false;

    if (score > bestScore) {
        bestScore = score;
        require("Storage").write("highscore", bestScore);
    }

    g.drawString("Game Over! High Score: " + bestScore, 10, 100);
    g.drawString("Press A to retry", 10, 130);
    g.flip();
}

setWatch(flap, BTN_A, { repeat: true, edge: "rising" });

resetGame();
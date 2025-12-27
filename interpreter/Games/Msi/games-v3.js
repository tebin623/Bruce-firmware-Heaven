var WIDTH = 240;
var HEIGHT = 135;
var BLACK = 0;
var WHITE = 16777215;
var RED = 16711680;
var GREEN = 65280;
var BLUE = 255;
var YELLOW = 16776960;
var CYAN = 65535;
var MAGENTA = 16711935;
var ORANGE = 16753920;
var PURPLE = 8388736;
var DARKBLUE = 128;
var DARKRED = 8388608;
var LIGHTGREEN = 8453888;
var STATE_MAIN_MENU = 0;
var STATE_BREAKOUT = 1;
var STATE_SNAKE = 2;
var STATE_SPACE_SHOOTER = 3;
var STATE_SLOTS = 4;
var gameState = STATE_MAIN_MENU;
var menuSelection = 0;
var menuOptions = ["BREAKOUT", "SNAKE", "SPACE SHOOTER", "SLOTS", "QUIT"];
var menuStaticDrawn = false;
var menuLastSelState = false;
var menuLastSelection = -1;
var PADDLE_WIDTH = 40;
var PADDLE_HEIGHT = 6;
var BALL_SIZE = 5;
var BRICK_WIDTH = 20;
var BRICK_HEIGHT = 10;
var BRICK_MARGIN = 2;
var BRICK_ROWS = 5;
var BRICK_COLS = 10;
var BRICK_COLORS = [RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE];
var BREAKOUT_STATE_START = 0;
var BREAKOUT_STATE_PLAYING = 1;
var BREAKOUT_STATE_GAME_OVER = 2;
var BREAKOUT_STATE_WIN = 3;
var BREAKOUT_STATE_NEXT_LEVEL = 4;
var breakoutState = BREAKOUT_STATE_START;
var paddle = { x: WIDTH / 2 - PADDLE_WIDTH / 2, y: HEIGHT - 15, width: PADDLE_WIDTH, height: PADDLE_HEIGHT, speed: 12, color: WHITE, lastX: WIDTH / 2 - PADDLE_WIDTH / 2, lastY: HEIGHT - 15 };
var ball = { x: WIDTH / 2, y: HEIGHT - 20 - BALL_SIZE, size: BALL_SIZE, speedX: 0, speedY: 0, color: WHITE, stuck: true, lastX: WIDTH / 2, lastY: HEIGHT - 20 - BALL_SIZE };
var bricks = [];
var breakoutScore = 0;
var breakoutLives = 3;
var breakoutLevel = 1;
var breakoutStaticDrawn = false;
var breakoutLastStaticDrawnState = -1;
var breakoutSelPressCount = 0;
var breakoutSelPressWindowStart = -1;
var breakoutSelPressWindow = 400;
var breakoutSelPressThreshold = 4;
var breakoutLastSelState = false;
var breakoutIsPaused = false;
var breakoutPauseDrawn = false;
var breakoutWasPaused = false;
var GRID_SIZE = 10;
var HUD_HEIGHT = 20;
var COLS = Math.floor(WIDTH / GRID_SIZE);
var ROWS = Math.floor((HEIGHT - HUD_HEIGHT) / GRID_SIZE);
var cApple = 10079232;
var SNAKE_STATE_MENU = 0;
var SNAKE_STATE_GAME = 1;
var SNAKE_STATE_PAUSED = 2;
var SNAKE_STATE_GAME_OVER = 3;
var snakeState = SNAKE_STATE_MENU;
var snake = [];
var direction = 0;
var nextDirection = 0;
var food = { x: 8, y: 4 };
var snakeScore = 0;
var snakeHighScore = 0;
var snakeFrameCounter = 0;
var snakeSpeed = 10;
var snakeSpeedIncrease = true;
var snakeStaticDrawn = false;
var snakeLastStaticDrawnState = -1;
var snakeLastSelState = false;
var snakeTotalDelay = 400;
var snakeDelayTime = snakeTotalDelay;
var snakeCanMove = true;
var snakeTime = now();
var snakePrevTime = now();
var snakeErasePos = null;
var snakeLastScore = -1;
var snakeLastHighScore = -1;
var snakeForceHudRedraw = false;
var PLAYER_SIZE = 16;
var ENEMY_SIZE = 14;
var BULLET_SIZE = 5;
var POWERUP_SIZE = 10;
var EXPLOSION_MAX_SIZE = 22;
var SPACE_STATE_MENU = 0;
var SPACE_STATE_GAME = 1;
var SPACE_STATE_GAME_OVER = 2;
var SPACE_STATE_LEVEL_UP = 3;
var spaceState = SPACE_STATE_MENU;
var player = { x: WIDTH / 2, y: HEIGHT - 25, width: PLAYER_SIZE, height: PLAYER_SIZE, speed: 7, lives: 3, weaponLevel: 1, weaponTime: 0, invincible: false, invincibleTime: 0, lastX: WIDTH / 2, lastY: HEIGHT - 25 };
var bullets = [];
var enemies = [];
var enemyBullets = [];
var explosions = [];
var stars = [];
var powerups = [];
var spaceScore = 0;
var spaceHighScore = 0;
var spaceLevel = 1;
var spaceFrameCounter = 0;
var enemySpawnRate = 50;
var enemyShootRate = 100;
var bossActive = false;
var boss = null;
var killCount = 0;
var levelUpThreshold = 20;
var fireRate = 6;
var lastFireTime = 0;
var spaceLastSelState = false;
var spaceIsPaused = false;
var spaceStaticDrawn = false;
var spaceLastStaticDrawnState = -1;
var spacePauseDrawn = false;
var enemyTypes = [
  { color: BLUE, detailColor: PURPLE, health: 1, speed: 1.2, points: 10, shootRate: 0, shape: "triangle" },
  { color: LIGHTGREEN, detailColor: DARKBLUE, health: 2, speed: 1.8, points: 20, shootRate: 100, shape: "square" },
  { color: ORANGE, detailColor: MAGENTA, health: 1, speed: 2.5, points: 15, shootRate: 0, shape: "diamond" },
  { color: BLUE, detailColor: YELLOW, health: 3, speed: 0.9, points: 30, shootRate: 70, shape: "circle" }
];
var powerupTypes = [
  { type: "health", color: WHITE },
  { type: "weapon", color: YELLOW }
];
var SLOT_STATE_MENU = 0;
var SLOT_STATE_SPIN = 1;
var SLOT_STATE_GAME_OVER = 2;
var slotState = SLOT_STATE_MENU;
var slotMoney = 300;
var slotBetOptions = [1, 2, 3, 5, 10, 20];
var slotBetIndex = 0;
var slotReels = [0, 0, 0];
var slotSymbols = ["7", "BAR", "Bell", "Chy", "Lem"];
var slotStaticDrawn = false;
var slotLastSelState = false;
var slotMessage = "";
var slotMessageTimer = 0;

function drawMainMenu() {
  if (!menuStaticDrawn || menuSelection !== menuLastSelection) {
    fillScreen(BLACK);

    setTextSize(2);
    setTextColor(WHITE);
    var title = "ARCADE MENU";
    var titleWidth = title.length * 12;
    var titleX = (WIDTH - titleWidth) / 2;
    drawString(title, titleX, 10); // Title at y = 10

    // Adjust frame dimensions to fit all items without going out of screen bounds
    var frameX = 10;
    var frameY = 34; // Start just below the title with some padding
    var frameWidth = WIDTH - 20;
    var frameHeight = 98; // Adjusted height to fit within screen with reduced spacing
    drawRect(frameX, frameY, frameWidth, frameHeight, BLUE);

    setTextSize(1);
    var maxVisibleOptions = 5; // Now showing all 5 options
    var startIndex = 0;

    for (var i = 0; i < maxVisibleOptions; i++) {
      var optionIndex = i;
      if (optionIndex >= menuOptions.length) break;

      var optionText = menuOptions[optionIndex];
      var optionWidth = optionText.length * 6;
      var optionX = frameX + 20;
      var optionY = frameY + 10 + i * 18; // Reduced spacing from 20px to 18px

      if (optionIndex === menuSelection) {
        setTextColor(YELLOW);
        drawString("> " + optionText, optionX, optionY);
      } else {
        setTextColor(WHITE);
        drawString("  " + optionText, optionX, optionY);
      }

      if (i < maxVisibleOptions - 1 && optionIndex < menuOptions.length - 1) {
        setTextColor(WHITE);
        drawString("→", frameX + frameWidth - 20, optionY);
      }
    }

    menuStaticDrawn = true;
    menuLastSelection = menuSelection;
  }
}

function resetBreakout() {
  paddle.x = WIDTH / 2 - PADDLE_WIDTH / 2;
  ball.x = paddle.x + paddle.width / 2;
  ball.y = paddle.y - ball.size;
  ball.stuck = true;
  resetBall();
  if (breakoutState === BREAKOUT_STATE_START || breakoutState === BREAKOUT_STATE_GAME_OVER) {
    breakoutScore = 0;
    breakoutLives = 3;
    breakoutLevel = 1;
    fillScreen(BLACK);
    breakoutStaticDrawn = false;
    breakoutLastStaticDrawnState = -1;
  }
  createBricks();
  breakoutState = BREAKOUT_STATE_PLAYING;
  breakoutPauseDrawn = false;
  breakoutWasPaused = false;
}

function resetBall() {
  ball.speedX = (Math.random() * 2 - 1) * 2;
  ball.speedY = -3;
}

function createBricks() {
  bricks = [];
  for (var i = 0; i < BRICK_ROWS; i++) {
    for (var j = 0; j < BRICK_COLS; j++) {
      var colorIndex = i % BRICK_COLORS.length;
      var strength = 1;
      if (Math.random() < 0.1 * breakoutLevel) strength = 2;
      bricks.push({ x: j * (BRICK_WIDTH + BRICK_MARGIN) + 10, y: i * (BRICK_HEIGHT + BRICK_MARGIN) + 20, width: BRICK_WIDTH, height: BRICK_HEIGHT, color: BRICK_COLORS[colorIndex], strength: strength, hit: false, changed: true });
    }
  }
}

function breakoutNextLevel() {
  breakoutLevel++;
  paddle.width = Math.max(PADDLE_WIDTH - (breakoutLevel - 1) * 3, 20);
  resetBall();
  ball.stuck = true;
  breakoutState = BREAKOUT_STATE_NEXT_LEVEL;
  breakoutStaticDrawn = false;
  breakoutLastStaticDrawnState = -1;
  tone(700, 200);
  tone(900, 200);
}

function drawBreakout() {
  switch (breakoutState) {
    case BREAKOUT_STATE_START: drawBreakoutStartScreen(); break;
    case BREAKOUT_STATE_PLAYING:
      if (!breakoutIsPaused) {
        if (breakoutWasPaused) {
          fillScreen(BLACK);
          breakoutLastStaticDrawnState = -1;
        }
        drawBreakoutPlayScreen();
        breakoutStaticDrawn = false;
        breakoutPauseDrawn = false;
      } else if (!breakoutPauseDrawn) {
        drawBreakoutPauseScreen();
        breakoutPauseDrawn = true;
      }
      breakoutWasPaused = breakoutIsPaused;
      break;
    case BREAKOUT_STATE_GAME_OVER: drawBreakoutGameOverScreen(); break;
    case BREAKOUT_STATE_WIN: drawBreakoutWinScreen(); break;
    case BREAKOUT_STATE_NEXT_LEVEL: drawBreakoutNextLevelScreen(); break;
  }
}

function drawBreakoutStartScreen() {
  if (!breakoutStaticDrawn || breakoutState !== breakoutLastStaticDrawnState) {
    fillScreen(BLACK);
    setTextSize(2);
    setTextColor(YELLOW);
    drawString("BREAKOUT", WIDTH / 2 - 48, 10);
    setTextSize(1);
    setTextColor(WHITE);
    drawString("PREV: Go Left", WIDTH / 2 - 39, 45);
    drawString("NEXT: Go Right", WIDTH / 2 - 42, 61);
    drawString("M5 (Press): Release Ball", WIDTH / 2 - 69, 77);
    drawString("M5 (Hold): Pause", WIDTH / 2 - 48, 93);
    setTextColor(GREEN);
    drawString("Press M5 to Begin", WIDTH / 2 - 51, 125);
    breakoutStaticDrawn = true;
    breakoutLastStaticDrawnState = breakoutState;
  }
}

function drawBreakoutPlayScreen() {
  setTextSize(1);
  setTextColor(WHITE);
  var lastScore = lastScore || -1;
  if (breakoutScore !== lastScore) {
    drawFillRect(0, 0, 150, 20, BLACK);
    drawString("Score: " + breakoutScore, 10, 5);
    drawString("Level: " + breakoutLevel, 100, 5);
    lastScore = breakoutScore;
  }
  var lastLives = lastLives || -1;
  if (breakoutLives !== lastLives) {
    drawFillRect(180, 0, WIDTH, 20, BLACK);
    drawString("Lives:", 180, 5);
    for (var i = 0; i < breakoutLives; i++) drawFillRect(215 + i * 8, 5, 5, 5, GREEN);
    lastLives = breakoutLives;
  }
  for (var i = 0; i < bricks.length; i++) {
    if (!bricks[i].hit) {
      if (bricks[i].changed || breakoutState !== breakoutLastStaticDrawnState) {
        drawFillRect(bricks[i].x, bricks[i].y, bricks[i].width, bricks[i].height, BLACK);
        drawFillRect(bricks[i].x, bricks[i].y, bricks[i].width, bricks[i].height, bricks[i].color);
        if (bricks[i].strength > 1) drawRect(bricks[i].x + 2, bricks[i].y + 2, bricks[i].width - 4, bricks[i].height - 4, WHITE);
        bricks[i].changed = false;
      }
    } else drawFillRect(bricks[i].x, bricks[i].y, bricks[i].width, bricks[i].height, BLACK);
  }
  if (paddle.x !== paddle.lastX || paddle.y !== paddle.lastY || breakoutState !== breakoutLastStaticDrawnState) {
    drawFillRect(paddle.lastX, paddle.lastY, paddle.width, paddle.height, BLACK);
    drawFillRect(paddle.x, paddle.y, paddle.width, paddle.height, paddle.color);
    paddle.lastX = paddle.x;
    paddle.lastY = paddle.y;
  }
  if (ball.x !== ball.lastX || ball.y !== ball.lastY || breakoutState !== breakoutLastStaticDrawnState) {
    drawFillRect(ball.lastX - ball.size / 2, ball.lastY - ball.size / 2, ball.size, ball.size, BLACK);
    if (ball.y - ball.size / 2 < 20) ball.y = 20 + ball.size / 2;
    drawFillRect(ball.x - ball.size / 2, ball.y - ball.size / 2, ball.size, ball.size, ball.color);
    ball.lastX = ball.x;
    ball.lastY = ball.y;
  }
  breakoutLastStaticDrawnState = breakoutState;
}

function drawBreakoutGameOverScreen() {
  if (!breakoutStaticDrawn || breakoutState !== breakoutLastStaticDrawnState) {
    fillScreen(BLACK);
    setTextSize(2);
    setTextColor(WHITE);
    drawString("GAME OVER", WIDTH / 2 - 54, 40);
    setTextSize(1);
    setTextColor(WHITE);
    drawString("Score: " + breakoutScore, WIDTH / 2 - 24, 80);
    setTextColor(YELLOW);
    drawString("M5 to Play Again", 72, 100);
    drawString("PREV to Menu", 84, 115);
    breakoutStaticDrawn = true;
    breakoutLastStaticDrawnState = breakoutState;
    tone(400, 300);
    tone(300, 300);
  }
}

function drawBreakoutWinScreen() {
  if (!breakoutStaticDrawn || breakoutState !== breakoutLastStaticDrawnState) {
    fillScreen(BLACK);
    setTextSize(2);
    setTextColor(GREEN);
    drawString("YOU WIN!", WIDTH / 2 - 48, 40);
    setTextSize(1);
    setTextColor(WHITE);
    drawString("Score: " + breakoutScore, WIDTH / 2 - 24, 80);
    setTextColor(YELLOW);
    drawString("M5 to Play Again", WIDTH / 2 - 66, 100);
    drawString("PREV to Menu", WIDTH / 2 - 30, 115);
    breakoutStaticDrawn = true;
    breakoutLastStaticDrawnState = breakoutState;
    tone(800, 200);
    tone(1000, 200);
  }
}

function drawBreakoutNextLevelScreen() {
  if (breakoutState !== breakoutLastStaticDrawnState) {
    fillScreen(BLACK);
    breakoutLastStaticDrawnState = breakoutState;
  }
  if (!breakoutStaticDrawn || breakoutState !== breakoutLastStaticDrawnState) {
    setTextSize(2);
    setTextColor(WHITE);
    drawString("LEVEL " + breakoutLevel, WIDTH / 2 - 36, 40);
    setTextSize(1);
    setTextColor(WHITE);
    drawString("Congratulations!", WIDTH / 2 - 48, 80);
    setTextColor(WHITE);
    drawString("Press M5 to Continue", WIDTH / 2 - 60, 110);
    breakoutStaticDrawn = true;
  }
}

function drawBreakoutPauseScreen() {
  fillScreen(BLACK);
  setTextSize(2);
  setTextColor(WHITE);
  drawString("PAUSED", WIDTH / 2 - 36, 40);
  setTextSize(1);
  setTextColor(YELLOW);
  drawString("NEXT to Resume", 85, 70);
  drawString("PREV to Menu", 85, 90);
}

function updateBreakout() {
  if (breakoutState !== BREAKOUT_STATE_PLAYING || breakoutIsPaused) return;
  if (getPrevPress()) paddle.x -= paddle.speed;
  else if (getNextPress()) paddle.x += paddle.speed;
  if (paddle.x < 0) paddle.x = 0;
  if (paddle.x + paddle.width > WIDTH) paddle.x = WIDTH - paddle.width;
  if (ball.stuck) {
    ball.x = paddle.x + paddle.width / 2;
    ball.y = paddle.y - ball.size;
    return;
  }
  ball.x += ball.speedX;
  ball.y += ball.speedY;
  if (ball.x - ball.size / 2 < 0 || ball.x + ball.size / 2 > WIDTH) {
    ball.speedX = -ball.speedX;
    tone(500, 100);
  }
  if (ball.y - ball.size / 2 < 0) {
    ball.speedY = -ball.speedY;
    tone(500, 100);
  }
  if (ball.y - ball.size / 2 < 20) {
    ball.y = 20 + ball.size / 2;
    ball.speedY = Math.abs(ball.speedY);
    tone(500, 100);
  }
  if (ball.y + ball.size / 2 > HEIGHT) {
    breakoutLives--;
    if (breakoutLives <= 0) breakoutState = BREAKOUT_STATE_GAME_OVER;
    else ball.stuck = true;
    return;
  }
  if (ball.y + ball.size / 2 > paddle.y - 2 && ball.y - ball.size / 2 < paddle.y + paddle.height && ball.x + ball.size / 2 > paddle.x && ball.x - ball.size / 2 < paddle.x + paddle.width) {
    var hitPos = (ball.x - (paddle.x + paddle.width / 2)) / (paddle.width / 2);
    ball.speedX = hitPos * 4;
    ball.speedY = -Math.abs(ball.speedY) * 1.05;
    tone(600, 150);
  }
  for (var i = 0; i < bricks.length; i++) {
    if (!bricks[i].hit && ball.x + ball.size / 2 > bricks[i].x && ball.x - ball.size / 2 < bricks[i].x + bricks[i].width && ball.y + ball.size / 2 > bricks[i].y && ball.y - ball.size / 2 < bricks[i].y + bricks[i].height) {
      bricks[i].strength--;
      bricks[i].changed = true;
      if (bricks[i].strength <= 0) {
        bricks[i].hit = true;
        breakoutScore += 10 * breakoutLevel;
        tone(700, 100);
      } else {
        breakoutScore += 5;
        tone(650, 100);
      }
      var overlapLeft = ball.x + ball.size / 2 - bricks[i].x;
      var overlapRight = bricks[i].x + bricks[i].width - (ball.x - ball.size / 2);
      var overlapTop = ball.y + ball.size / 2 - bricks[i].y;
      var overlapBottom = bricks[i].y + bricks[i].height - (ball.y - ball.size / 2);
      var minOverlap = Math.min(overlapLeft, overlapRight, overlapTop, overlapBottom);
      if (minOverlap === overlapLeft || minOverlap === overlapRight) ball.speedX = -ball.speedX;
      else ball.speedY = -ball.speedY;
      break;
    }
  }
  var remainingBricks = 0;
  for (var i = 0; i < bricks.length; i++) if (!bricks[i].hit) remainingBricks++;
  if (remainingBricks === 0) {
    if (breakoutLevel < 5) breakoutNextLevel();
    else breakoutState = BREAKOUT_STATE_WIN;
  }
}

function resetSnake() {
  snake = [{ x: 4, y: 4 }];
  direction = 3;
  nextDirection = 3;
  snakeScore = 0;
  snakeFrameCounter = 0;
  placeFood();
  snakeState = SNAKE_STATE_GAME;
  snakeStaticDrawn = false;
  snakeLastStaticDrawnState = -1;
  snakeDelayTime = snakeTotalDelay;
  snakeErasePos = null;
  snakeLastScore = -1;
  snakeLastHighScore = -1;
  snakeForceHudRedraw = true;
}

function placeFood() {
  var validPos = false;
  while (!validPos) {
    food.x = Math.floor(Math.random() * COLS);
    food.y = Math.floor(Math.random() * ROWS);
    validPos = true;
    for (var i = 0; i < snake.length; i++) {
      if (snake[i].x === food.x && snake[i].y === food.y) {
        validPos = false;
        break;
      }
    }
  }
}

function drawSnake() {
  switch (snakeState) {
    case SNAKE_STATE_MENU: drawSnakeMenu(); break;
    case SNAKE_STATE_GAME:
      if (!snakeStaticDrawn || snakeState !== snakeLastStaticDrawnState) {
        fillScreen(BLACK);
        snakeStaticDrawn = true;
        snakeLastStaticDrawnState = snakeState;
        snakeForceHudRedraw = true;
      }
      if (snakeErasePos) drawFillRect(snakeErasePos.x * GRID_SIZE, snakeErasePos.y * GRID_SIZE + HUD_HEIGHT, GRID_SIZE, GRID_SIZE, BLACK);
      if (snake.length > 0) {
        drawFillRect(snake[0].x * GRID_SIZE, snake[0].y * GRID_SIZE + HUD_HEIGHT, GRID_SIZE, GRID_SIZE, YELLOW);
        for (var i = 1; i < snake.length; i++) drawFillRect(snake[i].x * GRID_SIZE, snake[i].y * GRID_SIZE + HUD_HEIGHT, GRID_SIZE, GRID_SIZE, GREEN);
      }
      drawFillRect(food.x * GRID_SIZE, food.y * GRID_SIZE + HUD_HEIGHT, GRID_SIZE, GRID_SIZE, cApple);
      if (snakeScore !== snakeLastScore || snakeHighScore !== snakeLastHighScore || snakeForceHudRedraw || !snakeStaticDrawn) {
        drawSnakeScore();
        snakeLastScore = snakeScore;
        snakeLastHighScore = snakeHighScore;
        snakeForceHudRedraw = false;
      }
      break;
    case SNAKE_STATE_PAUSED: drawSnakePause(); break;
    case SNAKE_STATE_GAME_OVER: drawSnakeGameOver(); break;
  }
}

function drawSnakeMenu() {
  if (!snakeStaticDrawn || snakeState !== snakeLastStaticDrawnState) {
    fillScreen(BLACK);
    setTextSize(3);
    setTextColor(GREEN);
    drawString("SNAKE", 75, 10);
    setTextSize(1);
    setTextColor(WHITE);
    drawString("PRESS M5 TO START", 66, 55);
    drawString("PREV: TURN LEFT", 75, 80);
    drawString("NEXT: TURN RIGHT", 72, 95);
    drawString("M5: PAUSE", 90, 110);
    snakeStaticDrawn = true;
    snakeLastStaticDrawnState = snakeState;
  }
}

function drawSnakeScore() {
  drawFillRect(0, 0, WIDTH, HUD_HEIGHT, BLACK);
  setTextSize(1);
  setTextColor(WHITE);
  drawString("SCORE: " + snakeScore, 5, 5);
  drawString("HIGH SCORE: " + snakeHighScore, 150, 5);
}

function drawSnakePause() {
  if (!snakeStaticDrawn || snakeState !== snakeLastStaticDrawnState) {
    fillScreen(BLACK);
    setTextSize(2);
    setTextColor(WHITE);
    drawString("PAUSED", 80, 50);
    setTextSize(1);
    setTextColor(YELLOW);
    drawString("NEXT to Resume", 74, 80);
    drawString("PREV to Menu", 80, 95);
    snakeStaticDrawn = true;
    snakeLastStaticDrawnState = snakeState;
  }
}

function drawSnakeGameOver() {
  if (!snakeStaticDrawn || snakeState !== snakeLastStaticDrawnState) {
    fillScreen(BLACK);
    setTextSize(3);
    setTextColor(YELLOW);
    drawString("GAME OVER", 40, 30);
    setTextSize(2);
    setTextColor(WHITE);
    drawString("SCORE: " + snakeScore, 65, 60);
    if (snakeScore > snakeHighScore) {
      setTextColor(YELLOW);
      drawString("NEW HIGH SCORE!", 70, 85);
      tone(800, 200);
      tone(1000, 200);
    }
    setTextSize(1);
    setTextColor(YELLOW);
    drawString("M5 to Play Again", 65, 110);
    drawString("PREV to Menu", 77, 125);
    snakeStaticDrawn = true;
    snakeLastStaticDrawnState = snakeState;
    tone(400, 300);
    tone(300, 300);
  }
}

function updateSnakeDelayTime() {
  var timePassed = snakeTime - snakePrevTime;
  if (timePassed == 0) {
    snakeTime = now();
    return;
  }
  snakePrevTime = snakeTime;
  snakeTime = now();
  snakeDelayTime -= timePassed;
}

function updateSnake() {
  if (snakeState !== SNAKE_STATE_GAME || snake.length === 0) return;
  updateSnakeDelayTime();
  if (snakeDelayTime < 0) {
    snakeCanMove = true;
    var prevX = snake[0].x;
    var prevY = snake[0].y;
    switch (direction) {
      case 0: snake[0].y -= 1; break;
      case 1: snake[0].y += 1; break;
      case 2: snake[0].x -= 1; break;
      case 3: snake[0].x += 1; break;
    }
    if (snake[0].x < 0 || snake[0].x >= COLS || snake[0].y < 0 || snake[0].y >= ROWS) {
      snakeGameOver();
      return;
    }
    for (var i = 1; i < snake.length; i++) {
      if (snake[0].x === snake[i].x && snake[0].y === snake[i].y) {
        snakeGameOver();
        return;
      }
    }
    if (snake.length > 1) snakeErasePos = { x: snake[snake.length - 1].x, y: snake[snake.length - 1].y };
    else snakeErasePos = { x: prevX, y: prevY };
    if (snake[0].x === food.x && snake[0].y === food.y) {
      snakeScore += 10;
      if (snakeScore > snakeHighScore) snakeHighScore = snakeScore;
      placeFood();
      snake.push({ x: prevX, y: prevY });
      tone(600, 150);
    } else {
      for (var i = snake.length - 1; i > 0; i--) {
        if (i - 1 >= 0) {
          snake[i].x = snake[i - 1].x;
          snake[i].y = snake[i - 1].y;
        }
      }
      if (snake.length > 1) {
        snake[1].x = prevX;
        snake[1].y = prevY;
      }
    }
    direction = nextDirection;
    snakeDelayTime = snakeTotalDelay;
  }
}

function snakeGameOver() {
  snakeState = SNAKE_STATE_GAME_OVER;
  snakeStaticDrawn = false;
}

function resetSpaceShooter() {
  player.x = WIDTH / 2;
  player.y = HEIGHT - 25;
  player.lastX = player.x;
  player.lastY = player.y;
  player.lives = 3;
  player.weaponLevel = 1;
  player.weaponTime = 0;
  player.invincible = false;
  player.invincibleTime = 0;
  bullets = [];
  enemies = [];
  enemyBullets = [];
  explosions = [];
  powerups = [];
  boss = null;
  spaceScore = 0;
  spaceLevel = 1;
  spaceFrameCounter = 0;
  enemySpawnRate = 50;
  enemyShootRate = 100;
  bossActive = false;
  killCount = 0;
  lastFireTime = 0;
  spaceLastSelState = false;
  spaceIsPaused = false;
  createStars();
  spaceState = SPACE_STATE_GAME;
  spaceStaticDrawn = false;
  spaceLastStaticDrawnState = -1;
  spacePauseDrawn = false;
}

function createStars() {
  stars = [];
  for (var i = 0; i < 60; i++) stars.push({ x: Math.random() * WIDTH, y: Math.random() * HEIGHT, size: Math.random() * 2.5 + 1, speed: Math.random() * 0.8 + 0.3, lastX: 0, lastY: 0 });
}

function updateStars() {
  for (var i = 0; i < stars.length; i++) {
    var star = stars[i];
    star.y += star.speed * 0.1;
    if (star.y > HEIGHT) star.y -= HEIGHT;
  }
}

function drawStars() {
  for (var i = 0; i < stars.length; i++) {
    var star = stars[i];
    drawFillRect(star.lastX - 1, star.lastY - 1, star.size + 2, star.size + 2, BLACK);
    var brightness = (spaceFrameCounter + i * 10) % 100;
    var color = brightness < 50 ? WHITE : CYAN;
    if (i % 7 === 0) color = YELLOW;
    if (i % 11 === 0) color = MAGENTA;
    drawFillRect(star.x, star.y, star.size, star.size, color);
    star.lastX = star.x;
    star.lastY = star.y;
  }
}

function drawSpaceShooter() {
  switch (spaceState) {
    case SPACE_STATE_MENU: drawSpaceMenu(); break;
    case SPACE_STATE_GAME:
      if (!spaceIsPaused) drawSpaceGameplay();
      else drawSpacePause();
      break;
    case SPACE_STATE_GAME_OVER: drawSpaceGameOver(); break;
    case SPACE_STATE_LEVEL_UP: drawSpaceLevelUp(); break;
  }
}

function drawSpaceMenu() {
  if (!spaceStaticDrawn || spaceState !== spaceLastStaticDrawnState) {
    fillScreen(BLACK);
    setTextSize(3);
    setTextColor(CYAN);
    drawString("SPACE", 75, 15);
    setTextColor(ORANGE);
    drawString("SHOOTER", 60, 40);
    setTextSize(1);
    setTextColor(WHITE);
    drawString("PREV: GO LEFT", 10, 100);
    drawString("NEXT: GO RIGHT", 140, 100);
    drawString("M5: PAUSE", 105, 120);
    if (spaceFrameCounter % 30 < 20) {
      setTextColor(WHITE);
      drawString("PRESS M5 TO START", 70, 75);
    }
    spaceStaticDrawn = true;
    spaceLastStaticDrawnState = spaceState;
  }
}

function drawSpaceGameplay() {
  if (!spaceStaticDrawn || spaceState !== spaceLastStaticDrawnState) {
    fillScreen(BLACK);
    spaceStaticDrawn = true;
    spaceLastStaticDrawnState = spaceState;
  }
  if (spaceFrameCounter % 10 === 0) {
    updateStars();
    drawStars();
  }
  drawEnemies();
  drawBullets();
  drawEnemyBullets();
  drawExplosions();
  drawPowerups();
  if (player.x !== player.lastX || player.y !== player.lastY) {
    drawFillRect(player.lastX - player.width/2 - 6, player.lastY - 5, player.width + 12, player.height + 15, BLACK);
    player.lastX = player.x;
    player.lastY = player.y;
  }
  drawPlayer(player.x, player.y, player.weaponLevel);
  drawSpaceHUD();
}

function drawSpaceGameOver() {
  if (!spaceStaticDrawn || spaceState !== spaceLastStaticDrawnState) {
    fillScreen(BLACK);
    drawStars();
    setTextSize(2);
    setTextColor(YELLOW);
    drawString("GAME OVER", 70, 50);
    setTextSize(1);
    setTextColor(WHITE);
    drawString("Score: " + spaceScore, 90, 80);
    drawString("M5 to Restart", 70, 100);
    drawString("PREV to Menu", 70, 120);
    spaceStaticDrawn = true;
    spaceLastStaticDrawnState = spaceState;
    tone(400, 300);
    tone(300, 300);
  }
}

function drawSpaceLevelUp() {
  if (!spaceStaticDrawn || spaceState !== spaceLastStaticDrawnState) {
    fillScreen(BLACK);
    drawStars();
    setTextSize(2);
    setTextColor(YELLOW);
    drawString("LEVEL UP!", 80, 50);
    setTextSize(1);
    setTextColor(WHITE);
    drawString("Press M5 to Continue", 70, 110);
    spaceStaticDrawn = true;
    spaceLastStaticDrawnState = spaceState;
    tone(700, 200);
    tone(900, 200);
  }
}

function drawSpacePause() {
  if (!spacePauseDrawn) {
    fillScreen(BLACK);
    setTextSize(2);
    setTextColor(YELLOW);
    drawString("PAUSED", 90, 50);
    setTextSize(1);
    setTextColor(WHITE);
    drawString("NEXT to Resume", 70, 100);
    drawString("PREV to Menu", 70, 120);
    spacePauseDrawn = true;
  }
}

function drawPlayer(x, y, weaponLevel) {
  drawFillRect(x - player.width/2, y, player.width, player.height, BLUE);
  drawFillRect(x - player.width/2 + 3, y + 3, player.width - 6, player.height - 8, CYAN);
  drawFillRect(x - 4, y - 5, 8, 5, WHITE);
  if (spaceFrameCounter % 6 < 3) {
    drawFillRect(x - 6, y + player.height, 12, 4, ORANGE);
    drawFillRect(x - 4, y + player.height + 4, 8, 3, YELLOW);
  } else {
    drawFillRect(x - 5, y + player.height, 10, 5, ORANGE);
    drawFillRect(x - 3, y + player.height + 3, 6, 2, YELLOW);
  }
  if (weaponLevel > 1) {
    drawFillRect(x - player.width/2 - 4, y + 3, 4, 4, YELLOW);
    drawFillRect(x + player.width/2, y + 3, 4, 4, YELLOW);
    drawFillRect(x - player.width/2 - 2, y + 5, 2, 6, RED);
    drawFillRect(x + player.width/2 + 1, y + 5, 2, 6, RED);
  }
  if (weaponLevel > 2) {
    drawFillRect(x - player.width/2 - 4, y + 10, 4, 4, YELLOW);
    drawFillRect(x + player.width/2, y + 10, 4, 4, YELLOW);
  }
  if (player.invincible && spaceFrameCounter % 6 < 3) drawRect(x - player.width/2 - 2, y - 2, player.width + 4, player.height + 4, WHITE);
}

function drawEnemies() {
  for (var i = 0; i < enemies.length; i++) {
    var enemy = enemies[i];
    if (enemy && enemy.active) {
      drawFillRect(enemy.lastX - 5, enemy.lastY - 5, enemy.width + 10, enemy.height + 10, BLACK);
      drawFillRect(enemy.x, enemy.y, enemy.width, enemy.height, enemy.type.color);
      enemy.lastX = enemy.x;
      enemy.lastY = enemy.y;
    }
  }
  if (bossActive && boss) {
    drawFillRect(boss.lastX - 5, boss.lastY - 5, boss.width + 10, boss.height + 10, BLACK);
    drawFillRect(boss.x, boss.y, boss.width, boss.height, MAGENTA);
    boss.lastX = boss.x;
    boss.lastY = boss.y;
  }
}

function drawBullets() {
  for (var i = 0; i < bullets.length; i++) {
    var bullet = bullets[i];
    if (bullet && bullet.active) {
      if (!bullet.lastX) bullet.lastX = bullet.x;
      if (!bullet.lastY) bullet.lastY = bullet.y;
      if (bullet.x !== bullet.lastX || bullet.y !== bullet.lastY) {
        drawFillRect(bullet.lastX - bullet.width / 2, bullet.lastY, bullet.width, bullet.height + 2, BLACK);
        drawFillRect(bullet.x - bullet.width / 2, bullet.y, bullet.width, bullet.height, GREEN);
        bullet.lastX = bullet.x;
        bullet.lastY = bullet.y;
      }
    }
  }
}

function drawEnemyBullets() {
  for (var i = 0; i < enemyBullets.length; i++) {
    var bullet = enemyBullets[i];
    if (bullet && bullet.active) {
      if (!bullet.lastX) bullet.lastX = bullet.x;
      if (!bullet.lastY) bullet.lastY = bullet.y;
      if (bullet.x !== bullet.lastX || bullet.y !== bullet.lastY) {
        drawFillRect(bullet.lastX - bullet.width / 2, bullet.lastY, bullet.width, bullet.height, BLACK);
        drawFillRect(bullet.x - bullet.width / 2, bullet.y, bullet.width, bullet.height, YELLOW);
        bullet.lastX = bullet.x;
        bullet.lastY = bullet.y;
      }
    }
  }
}

function drawExplosions() {
  for (var i = 0; i < explosions.length; i++) {
    var explosion = explosions[i];
    if (explosion && explosion.active) drawFillRect(explosion.x - explosion.size / 2, explosion.y - explosion.size / 2, explosion.size, explosion.size, YELLOW);
  }
}

function drawPowerups() {
  for (var i = 0; i < powerups.length; i++) {
    var powerup = powerups[i];
    if (powerup && powerup.active) {
      if (!powerup.lastX) powerup.lastX = powerup.x;
      if (!powerup.lastY) powerup.lastY = powerup.y;
      if (powerup.x !== powerup.lastX || powerup.y !== powerup.lastY) {
        drawFillRect(powerup.lastX - powerup.width / 2 - 2, powerup.lastY - 2, powerup.width + 4, powerup.height + 4, BLACK);
        drawFillRect(powerup.x - powerup.width / 2, powerup.y, powerup.width, powerup.height, powerup.type.color);
        powerup.lastX = powerup.x;
        powerup.lastY = powerup.y;
      }
    }
  }
}

function drawSpaceHUD() {
  drawFillRect(0, 0, WIDTH, 10, BLACK);
  setTextSize(1);
  setTextColor(WHITE);
  drawString("SCORE: " + spaceScore, 5, 5);
  drawString("LEVEL: " + spaceLevel, 100, 5);
  drawString("LIVES: " + player.lives, 180, 5);
}

function updateSpaceShooter() {
  if (spaceState !== SPACE_STATE_GAME || spaceIsPaused) return;
  spaceFrameCounter++;
  if (spaceFrameCounter - lastFireTime >= fireRate) {
    fireBullet();
    lastFireTime = spaceFrameCounter;
  }
  updateBullets();
  updateEnemies();
  updateEnemyBullets();
  updateExplosions();
  updatePowerups();
  checkCollisions();
  checkLevelProgress();
}

function updateBullets() {
  for (var i = 0; i < bullets.length; i++) {
    if (bullets[i] && bullets[i].active) {
      bullets[i].y -= bullets[i].speed;
      if (bullets[i].y + bullets[i].height < 0) bullets[i].active = false;
    }
  }
}

function updateEnemies() {
  if (spaceFrameCounter % enemySpawnRate === 0 && !bossActive) spawnEnemy();
  for (var i = 0; i < enemies.length; i++) {
    if (enemies[i] && enemies[i].active) {
      enemies[i].y += enemies[i].type.speed;
      if (enemies[i].y > HEIGHT) {
        drawFillRect(enemies[i].lastX - 5, enemies[i].lastY - 5, enemies[i].width + 10, enemies[i].height + 10, BLACK);
        enemies[i].active = false;
      }
      if (enemies[i].type.shootRate > 0 && spaceFrameCounter % enemies[i].type.shootRate === 0) spawnEnemyBullet(enemies[i].x + enemies[i].width / 2, enemies[i].y + enemies[i].height);
    }
  }
  if (bossActive && boss) {
    boss.y += boss.speed;
    if (boss.y + boss.height > HEIGHT) {
      boss.y = HEIGHT - boss.height;
      boss.speed = -1.5;
    } else if (boss.y < 0) {
      boss.y = 0;
      boss.speed = 1.5;
    }
    if (spaceFrameCounter % 50 === 0) spawnEnemyBullet(boss.x + boss.width / 2, boss.y + boss.height);
  }
}

function updateEnemyBullets() {
  for (var i = 0; i < enemyBullets.length; i++) {
    if (enemyBullets[i] && enemyBullets[i].active) {
      enemyBullets[i].y += enemyBullets[i].speed;
      if (enemyBullets[i].y > HEIGHT) enemyBullets[i].active = false;
    }
  }
}

function updateExplosions() {
  for (var i = 0; i < explosions.length; i++) {
    if (explosions[i] && explosions[i].active && explosions[i].life > 0) {
      explosions[i].life--;
      if (explosions[i].life <= 0) {
        explosions[i].active = false;
        drawFillRect(explosions[i].x - explosions[i].size / 2, explosions[i].y - explosions[i].size / 2, explosions[i].size, explosions[i].size, BLACK);
      }
    }
  }
}

function updatePowerups() {
  for (var i = 0; i < powerups.length; i++) {
    if (powerups[i] && powerups[i].active) {
      powerups[i].y += 1;
      if (powerups[i].y > HEIGHT) powerups[i].active = false;
    }
  }
}

function spawnEnemy() {
  var type = enemyTypes[Math.floor(Math.random() * enemyTypes.length)];
  enemies.push({ x: Math.random() * (WIDTH - ENEMY_SIZE), y: 0, width: ENEMY_SIZE, height: ENEMY_SIZE, type: type, active: true, lastX: 0, lastY: 0 });
}

function spawnEnemyBullet(x, y) {
  enemyBullets.push({ x: x, y: y, width: BULLET_SIZE, height: BULLET_SIZE, speed: 3, active: true, lastX: 0, lastY: 0 });
}

function spawnBoss() {
  var bossWidth = Math.min(28 + (spaceLevel - 1) * 4, 56);
  var bossHeight = Math.min(28 + (spaceLevel - 1) * 4, 56);
  boss = { x: WIDTH / 2 - bossWidth / 2, y: -bossHeight, width: bossWidth, height: bossHeight, health: 25 * spaceLevel, active: true, speed: 1.5, lastX: WIDTH / 2 - bossWidth / 2, lastY: -bossHeight };
  bossActive = true;
}

function spawnPowerup(x, y) {
  if (powerups.length < 5 && Math.random() < 0.1) {
    var type = powerupTypes[Math.floor(Math.random() * powerupTypes.length)];
    powerups.push({ x: x, y: y, width: POWERUP_SIZE, height: POWERUP_SIZE, type: type, active: true, lastX: x, lastY: y });
  }
}

function fireBullet() {
  bullets.push({ x: player.x, y: player.y - player.height / 2, width: BULLET_SIZE, height: BULLET_SIZE, speed: 5, active: true, lastX: player.x, lastY: player.y - player.height / 2 });
}

function checkCollisions() {
  for (var i = 0; i < bullets.length; i++) {
    if (!bullets[i] || !bullets[i].active) continue;
    var bullet = bullets[i];
    for (var j = 0; j < enemies.length; j++) {
      if (!enemies[j] || !enemies[j].active) continue;
      var enemy = enemies[j];
      if (checkRectCollision(bullet.x - bullet.width/2, bullet.y - bullet.height/2, bullet.width, bullet.height, enemy.x, enemy.y, enemy.width, enemy.height)) {
        bullet.active = false;
        drawFillRect(bullet.lastX - bullet.width / 2, bullet.lastY, bullet.width, bullet.height + 2, BLACK);
        enemy.active = false;
        drawFillRect(enemy.lastX - 5, enemy.lastY - 5, enemy.width + 10, enemy.height + 10, BLACK);
        spaceScore += enemy.type.points;
        killCount++;
        createExplosion(enemy.x + enemy.width/2, enemy.y + enemy.height/2);
        spawnPowerup(enemy.x, enemy.y);
      }
    }
    if (bossActive && boss && checkRectCollision(bullet.x - bullet.width/2, bullet.y - bullet.height/2, bullet.width, bullet.height, boss.x, boss.y, boss.width, boss.height)) {
      bullet.active = false;
      drawFillRect(bullet.lastX - bullet.width / 2, bullet.lastY, bullet.width, bullet.height + 2, BLACK);
      boss.health--;
      if (boss.health <= 0) {
        bossActive = false;
        spaceScore += 500;
        killCount += 5;
        createExplosion(boss.x + boss.width/2, boss.y + boss.height/2);
        spaceLevelUp();
      }
    }
  }
  if (!player.invincible) {
    for (var j = 0; j < enemies.length; j++) {
      if (!enemies[j] || !enemies[j].active) continue;
      var enemy = enemies[j];
      if (checkRectCollision(player.x - player.width/2, player.y, player.width, player.height, enemy.x, enemy.y, enemy.width, enemy.height)) {
        enemy.active = false;
        drawFillRect(enemy.lastX - 5, enemy.lastY - 5, enemy.width + 10, enemy.height + 10, BLACK);
        player.lives--;
        createExplosion(player.x, player.y + player.height, true);
        player.invincible = true;
        player.invincibleTime = 60;
        tone(500, 200);
        if (player.lives <= 0) {
          spaceState = SPACE_STATE_GAME_OVER;
          if (spaceScore > spaceHighScore) spaceHighScore = spaceScore;
        }
        break;
      }
    }
    for (var j = 0; j < enemyBullets.length; j++) {
      if (!enemyBullets[j] || !enemyBullets[j].active) continue;
      var bullet = enemyBullets[j];
      if (checkRectCollision(player.x - player.width/2, player.y, player.width, player.height, bullet.x - bullet.width/2, bullet.y, bullet.width, bullet.height)) {
        bullet.active = false;
        player.lives--;
        createExplosion(player.x, player.y + player.height, true);
        player.invincible = true;
        player.invincibleTime = 60;
        tone(500, 200);
        if (player.lives <= 0) {
          spaceState = SPACE_STATE_GAME_OVER;
          if (spaceScore > spaceHighScore) spaceHighScore = spaceScore;
        }
        break;
      }
    }
    if (bossActive && boss && checkRectCollision(player.x - player.width/2, player.y, player.width, player.height, boss.x, boss.y, boss.width, boss.height)) {
      player.lives--;
      createExplosion(player.x, player.y + player.height, true);
      player.invincible = true;
      player.invincibleTime = 60;
      tone(500, 200);
      if (player.lives <= 0) {
        spaceState = SPACE_STATE_GAME_OVER;
        if (spaceScore > spaceHighScore) spaceHighScore = spaceScore;
      }
    }
  }
  for (var i = 0; i < powerups.length; i++) {
    if (!powerups[i] || !powerups[i].active) continue;
    var powerup = powerups[i];
    if (checkRectCollision(player.x - player.width/2, player.y, player.width, player.height, powerup.x - powerup.width/2, powerup.y, powerup.width, powerup.height)) {
      powerup.active = false;
      drawFillRect(powerup.lastX - powerup.width / 2 - 2, powerup.lastY - 2, powerup.width + 4, powerup.height + 4, BLACK);
      if (powerup.type.type === "health" && player.lives < 3) player.lives++;
      else if (powerup.type.type === "weapon" && player.weaponLevel < 3) {
        player.weaponLevel++;
        player.weaponTime = 300;
      }
    }
  }
  if (player.invincible) {
    player.invincibleTime--;
    if (player.invincibleTime <= 0) player.invincible = false;
  }
  if (player.weaponTime > 0) {
    player.weaponTime--;
    if (player.weaponTime <= 0) player.weaponLevel = 1;
  }
}

function checkLevelProgress() {
  if (!bossActive && killCount >= levelUpThreshold) spawnBoss();
}

function spaceLevelUp() {
  spaceLevel++;
  killCount = 0;
  spaceScore += spaceLevel * 100;
  enemies = [];
  enemyBullets = [];
  enemySpawnRate = Math.max(20, 50 - spaceLevel * 5);
  enemyShootRate = Math.max(40, 100 - spaceLevel * 10);
  spaceState = SPACE_STATE_LEVEL_UP;
}

function createExplosion(x, y, isPlayerExplosion) {
  if (explosions.length < 10) {
    var explosion = { x: x, y: y, size: EXPLOSION_MAX_SIZE, active: true, life: 10 };
    if (isPlayerExplosion) explosion.size = 16;
    explosions.push(explosion);
    tone(600, 150);
  }
}

function checkRectCollision(x1, y1, w1, h1, x2, y2, w2, h2) {
  return x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2;
}

function resetSlots() {
  slotMoney = 300;
  slotBetIndex = 0;
  slotReels = [0, 0, 0];
  slotState = SLOT_STATE_SPIN;
  slotStaticDrawn = false;
  slotMessage = "";
  slotMessageTimer = 0;
}

function drawSlots() {
  if (!slotStaticDrawn) {
    fillScreen(BLACK);
    setTextSize(1);
    if (slotState === SLOT_STATE_MENU) {
      setTextSize(2);
      setTextColor(YELLOW);
      drawString("SLOTS", 90, 20);
      setTextSize(1);
      setTextColor(WHITE);
      drawString("M5: Bet", 100, 50);
      drawString("NEXT: Bet", 95, 70);
      drawString("Press M5 to Start", 80, 90);
    } else if (slotState === SLOT_STATE_SPIN) {
      setTextColor(WHITE);
      drawString("Money: " + slotMoney, 10, 10);
      drawString("PREV: Menu", 10, 30);
      drawString("Bet: " + slotBetOptions[slotBetIndex], 100, 10);
      setTextSize(2);
      setTextColor(CYAN);
      var reel1 = slotSymbols[slotReels[0]].length === 1 ? " " + slotSymbols[slotReels[0]] + " " : slotSymbols[slotReels[0]];
      var reel2 = slotSymbols[slotReels[1]].length === 1 ? " | " + slotSymbols[slotReels[1]] + " |" : " |" + slotSymbols[slotReels[1]] + "|";
      var reel3 = slotSymbols[slotReels[2]].length === 1 ? " " + slotSymbols[slotReels[2]] + " " : slotSymbols[slotReels[2]];
      var reelWidth = 45;
      var totalReelWidth = reelWidth * 3 + 30;
      var startX = (WIDTH - totalReelWidth) / 2 - 20;
      drawString(String.fromCharCode(91), startX, 60);
      drawString(reel1, startX + 10, 60);
      drawString(reel2, startX + 55, 60);
      drawString(reel3, startX + 135, 60);
      drawString(String.fromCharCode(93), startX + 180, 60);
      setTextSize(1);
      setTextColor(WHITE);
      drawString("M5: Spin", 10, 110);
      drawString("NEXT: Bet", 170, 110);
      if (slotMessageTimer > 0 && slotMessage !== "") {
        setTextColor(YELLOW);
        setTextSize(2);
        var centerX = 120 - 20;
        if (slotMessage === "JACKPOT!") drawString(slotMessage, centerX - 40, 110);
        else if (slotMessage === "WIN!") drawString(slotMessage, centerX - 20, 110);
        else if (slotMessage === "Pair!") drawString(slotMessage, centerX - 20, 110);
        else if (slotMessage === "So Close!") drawString(slotMessage, centerX - 40, 110);
        slotMessageTimer--;
        if (slotMessageTimer <= 0) slotMessage = "";
      }
    } else if (slotState === SLOT_STATE_GAME_OVER) {
      setTextSize(2);
      setTextColor(MAGENTA);
      drawString("BUSTED!", 80, 50);
      setTextSize(1);
      setTextColor(WHITE);
      drawString("M5 to Retry", 70, 90);
      drawString("PREV to Menu", 70, 110);
    }
    slotStaticDrawn = true;
  }
}

function updateSlots(selPressed) {
  if (slotState !== SLOT_STATE_SPIN) return;
  var bet = slotBetOptions[slotBetIndex];
  if (slotMoney < bet) slotBetIndex = Math.max(0, slotBetIndex - 1);
  if (selPressed) {
    slotMoney -= bet;
    slotReels = [Math.floor(Math.random() * 5), Math.floor(Math.random() * 5), Math.floor(Math.random() * 5)];
    slotMessage = "";
    if (slotReels[0] === 0 && slotReels[1] === 0 && slotReels[2] === 0) {
      slotMoney += bet * 50;
      slotMessage = "JACKPOT!";
      slotMessageTimer = 30;
      tone(1000, 500);
    } else if (slotReels[0] === slotReels[1] && slotReels[1] === slotReels[2]) {
      var multiplier = (slotReels[0] === 1 || slotReels[0] === 2) ? 20 : 10;
      slotMoney += bet * multiplier;
      slotMessage = "WIN!";
      slotMessageTimer = 20;
      tone(800, 300);
    } else if (slotReels[0] === slotReels[1] || slotReels[1] === slotReels[2]) {
      slotMoney += bet * 2;
      slotMessage = "Pair!";
      slotMessageTimer = 15;
      tone(600, 200);
    } else {
      var twoMatch = (slotReels[0] === slotReels[1] && slotReels[1] !== slotReels[2]) || (slotReels[1] === slotReels[2] && slotReels[0] !== slotReels[1]);
      if (twoMatch) {
        slotMessage = "So Close!";
        slotMessageTimer = 15;
      }
    }
    if (slotMoney <= 0) slotState = SLOT_STATE_GAME_OVER;
    slotStaticDrawn = false;
  }
}

function handleInput() {
  var currentSelState = getSelPress();
  var shouldExit = false;
  switch (gameState) {
    case STATE_MAIN_MENU:
      if (getPrevPress()) {
        menuSelection = (menuSelection - 1 + menuOptions.length) % menuOptions.length;
        menuStaticDrawn = false;
      }
      if (getNextPress()) {
        menuSelection = (menuSelection + 1) % menuOptions.length;
        menuStaticDrawn = false;
      }
      if (currentSelState && !menuLastSelState) {
        if (menuSelection === 0) {
          gameState = STATE_BREAKOUT;
          breakoutState = BREAKOUT_STATE_START;
        } else if (menuSelection === 1) {
          gameState = STATE_SNAKE;
          snakeState = SNAKE_STATE_MENU;
        } else if (menuSelection === 2) {
          gameState = STATE_SPACE_SHOOTER;
          spaceState = SPACE_STATE_MENU;
        } else if (menuSelection === 3) {
          gameState = STATE_SLOTS;
          slotState = SLOT_STATE_MENU;
        } else if (menuSelection === 4) return true;
      }
      menuLastSelState = currentSelState;
      break;
    case STATE_BREAKOUT:
      switch (breakoutState) {
        case BREAKOUT_STATE_START:
          if (currentSelState && !breakoutLastSelState) {
            resetBreakout();
            breakoutStaticDrawn = false;
            breakoutLastStaticDrawnState = -1;
          }
          break;
        case BREAKOUT_STATE_PLAYING:
          if (!breakoutIsPaused) {
            if (getPrevPress()) paddle.x -= paddle.speed;
            if (getNextPress()) paddle.x += paddle.speed;
            if (currentSelState && !breakoutLastSelState) {
              if (ball.stuck) ball.stuck = false;
              breakoutSelPressCount++;
              breakoutSelPressWindowStart = Date.now();
            }
            if (breakoutSelPressWindowStart !== -1 && Date.now() - breakoutSelPressWindowStart > breakoutSelPressWindow) {
              if (breakoutSelPressCount >= breakoutSelPressThreshold) {
                breakoutIsPaused = true;
                breakoutPauseDrawn = false;
              }
              breakoutSelPressCount = 0;
              breakoutSelPressWindowStart = -1;
            }
          } else {
            if (getNextPress()) {
              breakoutIsPaused = false;
              breakoutStaticDrawn = false;
              breakoutPauseDrawn = false;
            }
            if (getPrevPress()) {
              gameState = STATE_MAIN_MENU;
              menuStaticDrawn = false;
              shouldExit = true;
            }
          }
          break;
        case BREAKOUT_STATE_GAME_OVER:
          if (currentSelState && !breakoutLastSelState) {
            breakoutState = BREAKOUT_STATE_START;
            breakoutStaticDrawn = false;
            breakoutLastStaticDrawnState = -1;
          }
          if (getPrevPress()) {
            gameState = STATE_MAIN_MENU;
            menuStaticDrawn = false;
            shouldExit = true;
          }
          break;
        case BREAKOUT_STATE_WIN:
          if (currentSelState && !breakoutLastSelState) {
            breakoutState = BREAKOUT_STATE_START;
            breakoutStaticDrawn = false;
            breakoutLastStaticDrawnState = -1;
          }
          if (getNextPress()) {
            gameState = STATE_MAIN_MENU;
            menuStaticDrawn = false;
            shouldExit = true;
          }
          break;
        case BREAKOUT_STATE_NEXT_LEVEL:
          if (currentSelState && !breakoutLastSelState) {
            resetBreakout();
            breakoutStaticDrawn = false;
            breakoutLastStaticDrawnState = -1;
          }
          break;
      }
      breakoutLastSelState = currentSelState;
      break;
    case STATE_SNAKE:
      switch (snakeState) {
        case SNAKE_STATE_MENU:
          if (currentSelState && !snakeLastSelState) resetSnake();
          if (getPrevPress()) {
            gameState = STATE_MAIN_MENU;
            menuStaticDrawn = false;
            shouldExit = true;
          }
          break;
        case SNAKE_STATE_GAME:
          if (snakeCanMove) {
            if (currentSelState && !snakeLastSelState) {
              snakeState = SNAKE_STATE_PAUSED;
              snakeStaticDrawn = false;
            }
            if (getPrevPress()) {
              nextDirection = (direction + 3) % 4;
              snakeCanMove = false;
            } else if (getNextPress()) {
              nextDirection = (direction + 1) % 4;
              snakeCanMove = false;
            }
          }
          break;
        case SNAKE_STATE_PAUSED:
          if (getNextPress()) {
            snakeState = SNAKE_STATE_GAME;
            snakeStaticDrawn = false;
            snakeForceHudRedraw = true;
          }
          if (getPrevPress()) {
            gameState = STATE_MAIN_MENU;
            menuStaticDrawn = false;
            shouldExit = true;
          }
          break;
        case SNAKE_STATE_GAME_OVER:
          if (currentSelState && !snakeLastSelState) {
            snakeState = SNAKE_STATE_MENU;
            snakeStaticDrawn = false;
          }
          if (getPrevPress()) {
            gameState = STATE_MAIN_MENU;
            menuStaticDrawn = false;
            shouldExit = true;
          }
          break;
      }
      snakeLastSelState = currentSelState;
      break;
    case STATE_SPACE_SHOOTER:
      switch (spaceState) {
        case SPACE_STATE_MENU:
          if (currentSelState && !spaceLastSelState) resetSpaceShooter();
          if (getPrevPress()) {
            gameState = STATE_MAIN_MENU;
            menuStaticDrawn = false;
            shouldExit = true;
          }
          break;
        case SPACE_STATE_GAME:
          if (!spaceIsPaused) {
            if (getPrevPress()) player.x -= player.speed;
            if (getNextPress()) player.x += player.speed;
            if (player.x < player.width/2) player.x = player.width/2;
            if (player.x > WIDTH - player.width/2) player.x = WIDTH - player.width/2;
            if (currentSelState && !spaceLastSelState) {
              spaceIsPaused = true;
              spacePauseDrawn = false;
            }
          } else {
            if (getNextPress()) {
              spaceIsPaused = false;
              spaceStaticDrawn = false;
              spacePauseDrawn = false;
            }
            if (getPrevPress()) {
              gameState = STATE_MAIN_MENU;
              menuStaticDrawn = false;
              shouldExit = true;
            }
          }
          break;
        case SPACE_STATE_LEVEL_UP:
          if (currentSelState && !spaceLastSelState) {
            spaceState = SPACE_STATE_GAME;
            spaceStaticDrawn = false;
          }
          break;
        case SPACE_STATE_GAME_OVER:
          if (currentSelState && !spaceLastSelState) {
            spaceState = SPACE_STATE_MENU;
            spaceStaticDrawn = false;
          }
          if (getPrevPress()) {
            gameState = STATE_MAIN_MENU;
            menuStaticDrawn = false;
            shouldExit = true;
          }
          break;
      }
      spaceLastSelState = currentSelState;
      break;
    case STATE_SLOTS:
      switch (slotState) {
        case SLOT_STATE_MENU:
          if (currentSelState && !slotLastSelState) {
            resetSlots();
            slotStaticDrawn = false;
          }
          if (getPrevPress()) {
            gameState = STATE_MAIN_MENU;
            menuStaticDrawn = false;
            shouldExit = true;
          }
          break;
        case SLOT_STATE_SPIN:
          if (getPrevPress()) {
            gameState = STATE_MAIN_MENU;
            menuStaticDrawn = false;
            shouldExit = true;
          }
          if (getNextPress()) {
            slotBetIndex = (slotBetIndex + 1) % slotBetOptions.length;
            slotStaticDrawn = false;
          }
          updateSlots(currentSelState && !slotLastSelState);
          break;
        case SLOT_STATE_GAME_OVER:
          if (currentSelState && !slotLastSelState) {
            resetSlots();
            slotStaticDrawn = false;
          }
          if (getPrevPress()) {
            gameState = STATE_MAIN_MENU;
            menuStaticDrawn = false;
            shouldExit = true;
          }
          break;
      }
      slotLastSelState = currentSelState;
      break;
  }
  return shouldExit ? false : (gameState === STATE_MAIN_MENU && menuSelection === 4 && currentSelState && !menuLastSelState);
}

function main() {
  gameState = STATE_MAIN_MENU;
  createStars();
  while (true) {
    var startTime = Date.now();
    if (handleInput()) break;
    switch (gameState) {
      case STATE_MAIN_MENU: drawMainMenu(); break;
      case STATE_BREAKOUT: updateBreakout(); drawBreakout(); break;
      case STATE_SNAKE: updateSnake(); drawSnake(); break;
      case STATE_SPACE_SHOOTER: updateSpaceShooter(); drawSpaceShooter(); break;
      case STATE_SLOTS: updateSlots(false); drawSlots(); break;
    }
    var frameTime = Date.now() - startTime;
    delay(Math.max(1, 33 - frameTime));
  }
}

main();
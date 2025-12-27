var display = require("display");
var keyboard = require("keyboard");
var audio = require("audio");

var width = 135;
var height = 240;
var gray = [0x0000, 0x4208, 0x8410, 0xC618, 0xFFFF];

function rand(min, max) {
  return min + (now() % (max - min));
}

function playNoise() {
  var f = rand(400, 3000);
  var d = rand(10, 20);
  audio.tone(f, d);
}

function fadeEffect(steps, delayMs, fadeIn) {
  for (var i = 0; i < steps; i++) {
    var intensity = fadeIn ? (i / steps) : ((steps - i) / steps);
    drawNoiseFrame(intensity);
    delay(delayMs);
  }
}

function drawNoiseFrame(brightness) {
  for (var y = 0; y < height; y += 2) {
    for (var x = 0; x < width; x += 2) {
      var g = rand(0, gray.length);
      var base = gray[g];
      var finalColor = adjustBrightness(base, brightness);
      display.drawFillRect(x, y, 2, 2, finalColor);
    }
  }

  if (rand(0, 10) < 2) {
    var gy = rand(0, height);
    for (var gx = 0; gx < width; gx += 5) {
      var glitchColor = gray[rand(0, gray.length)];
      display.drawFillRect(gx, gy, 5, 2, glitchColor);
    }
  }
}

function adjustBrightness(color, brightness) {
  var r = (color >> 11) & 0x1F;
  var g = (color >> 5) & 0x3F;
  var b = color & 0x1F;

  r = Math.min(31, Math.floor(r * brightness));
  g = Math.min(63, Math.floor(g * brightness));
  b = Math.min(31, Math.floor(b * brightness));

  return (r << 11) | (g << 5) | b;
}

fadeEffect(20, 30, true);

while (true) {
  if (keyboard.getPrevPress()) break;
  drawNoiseFrame(1);
  playNoise();
  delay(30);
}

fadeEffect(20, 30, false);

// T-Embed CC1101 Calculator UI
// Created by https://github.com/AnunnakiG0d - 2025

var display = require('display');
var keyboard = require('keyboard');

// === GRID LAYOUT CONFIGURATION ===
var grid = [
    ['7','8','9','/'],
    ['4','5','6','*'],
    ['1','2','3','-'],
    ['0','C','=','+']
];

// === LAYOUT SETTINGS ===
var cfg = {
    w: 70,
    h: 25,
    x0: 5,
    y0: 60,
    sx: 10,
    sy: 2
};

// === COLORS ===
var bg = display.color(0, 0, 0);
var btn = display.color(0, 44, 61);
var txt = display.color(255, 255, 255);
var highlightColor = display.color(0, 255, 205);

// Calculator state
var expr = '';
var idx = 0;
var rows = grid.length;
var cols = grid[0].length;

// Draw entire screen: expression, buttons, highlight
function draw() {
    // Clear background
    display.drawFillRect(0, 0, display.width(), display.height(), bg);
    
    // Draw current expression at top
    var displayExpr = expr || '0';  // Show '0' if empty
    display.drawString(displayExpr, cfg.x0, 5, txt);
    
    // Draw grid of buttons
    for (var r = 0; r < rows; r++) {
        for (var c = 0; c < cols; c++) {
            var x = cfg.x0 + c * (cfg.w + cfg.sx);
            var y = cfg.y0 + r * (cfg.h + cfg.sy);
            
            // Draw button background
            display.drawFillRect(x, y, cfg.w - 2, cfg.h - 2, btn);
            
            // Draw button text (centered)
            var buttonText = grid[r][c];
            var tx = x + cfg.w / 2 - 5;
            var ty = y + cfg.h / 2 - 5;
            display.drawString(buttonText, tx, ty, txt);
        }
    }
    
    // Draw highlight around selected button
    var hr = Math.floor(idx / cols);
    var hc = idx % cols;
    var hx = cfg.x0 + hc * (cfg.w + cfg.sx);
    var hy = cfg.y0 + hr * (cfg.h + cfg.sy);
    
    // Draw highlight border
    display.drawRect(hx, hy, cfg.w - 2, cfg.h - 2, highlightColor);
}

// Handle button press logic
function handleButtonPress(key) {
    if (key === 'C') {
        expr = '';
    } else if (key === '=') {
        if (expr === '') return;  // Don't evaluate empty expression
        try {
            var result = eval(expr);
            expr = expr + ' = ' + result.toString();
        } catch (e) {
            expr = 'ERROR';
            // Clear error after a delay
            setTimeout(function() {
                expr = '';
                draw();
            }, 1500);
        }
    } else {
        // Clear error state when typing new input
        if (expr === 'ERROR') {
            expr = '';
        }
        // If we just showed a calculation result, start fresh
        if (expr.indexOf(' = ') !== -1) {
            expr = key;
        } else {
            expr += key;
        }
    }
}



// Main program loop
function main() {
    draw();
    console.log("Calculator ready");
    
    while (true) {
        // Exit on TOP button (Escape)
        if (keyboard.getEscPress(true)) {
            console.log("Escape pressed → exit");
            display.drawString("Exiting...", display.width() - 80, 5, txt);
            delay(500);
            break;
        }
        
        // Rotate encoder clockwise: move forward
        if (keyboard.getNextPress(true)) {
            idx = (idx + 1) % (rows * cols);
            draw();
        }
        
        // Rotate encoder counter-clockwise: move back
        if (keyboard.getPrevPress(true)) {
            idx = (idx - 1 + rows * cols) % (rows * cols);
            draw();
        }
        
        // Click encoder button: select key
        if (keyboard.getSelPress(true)) {
            var selectedRow = Math.floor(idx / cols);
            var selectedCol = idx % cols;
            var key = grid[selectedRow][selectedCol];
            
            handleButtonPress(key);
            draw();
        }
        
        delay(50); // Reduced delay for smoother response
    }
}

// Start the calculator
main();

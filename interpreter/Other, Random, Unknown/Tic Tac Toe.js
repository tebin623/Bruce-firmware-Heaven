// Import required modules
var display = require("display");
var keyboard = require("keyboard");

// --- CONFIGURATION ---
var SCREEN_WIDTH = 240;
var SCREEN_HEIGHT = 135;
var BOARD_SIZE = 135;
var CELL_SIZE = BOARD_SIZE / 3;
var INFO_PANEL_X = BOARD_SIZE + 15;

// --- COLORS ---
var COLOR_BACKGROUND = display.color(0, 0, 0);
var COLOR_GRID = display.color(220, 220, 255);
var COLOR_X = display.color(255, 0, 100);
var COLOR_O = display.color(0, 150, 255);
var COLOR_SELECTION = display.color(255, 255, 0);
var COLOR_WIN = display.color(0, 255, 100);
var COLOR_TEXT = display.color(255, 255, 255);
var COLOR_TEXT_INVERTED = display.color(10, 10, 10);

// --- GLOBAL STATE ---
var currentScreen = 'MAIN_MENU'; // 'MAIN_MENU', 'DIFFICULTY_MENU', 'GAME', 'REMATCH'
var menuState = {
    selectedOption: 0,
    rematchSelection: 0
};
var gameState = {
    gameMode: 'PVP',
    botDifficulty: 'EASY', // 'EASY', 'MEDIUM', 'IMPOSSIBLE'
    selectionIndex: 4,
    scoreX: 0,
    scoreO: 0,
    player: 'X',
    winner: null,
    winInfo: null,
    field: [
        [' ', ' ', ' '],
        [' ', ' ', ' '],
        [' ', ' ', ' ']
    ],
};

// --- DRAWING FUNCTIONS ---

function drawCross(x, y, size, color) {
    var padding = size * 0.2;
    display.drawLine(x + padding, y + padding, x + size - padding, y + size - padding, color);
    display.drawLine(x + size - padding, y + padding, x + padding, y + size - padding, color);
}

function drawCircle(x, y, size, color) {
    var radius = (size / 2) * 0.7;
    var centerX = x + size / 2;
    var centerY = y + size / 2;
    display.drawCircle(centerX, centerY, radius, color);
}

function drawMenuButton(text, x, y, width, height, textX, textY, isSelected, color) {
    var textColor;
    var boxColor = color || COLOR_SELECTION;

    if (isSelected) {
        textColor = COLOR_TEXT_INVERTED;
        display.drawFillRoundRect(x, y, width, height, 5, boxColor);
    } else {
        textColor = color || COLOR_TEXT;
        display.drawRoundRect(x, y, width, height, 5, boxColor);
    }
    display.setTextColor(textColor);
    display.drawText(text, textX, textY);
}


function draw_main_menu() {
    display.fill(COLOR_BACKGROUND);
    
    display.setTextSize(3);
    display.setTextColor(COLOR_GRID);
    display.drawText("Tic Tac Toe", 30, 20);
    
    display.setTextSize(2);
    drawMenuButton("Player vs Player", 20, 55, 200, 25, 25, 62, menuState.selectedOption === 0);
    drawMenuButton("Player vs Bot", 20, 90, 200, 25, 45, 97, menuState.selectedOption === 1);

    display.setTextSize(1);
    display.setTextColor(COLOR_GRID);
    display.drawText("made by not.ertis", 5, 125);
}

function draw_difficulty_menu() {
    display.fill(COLOR_BACKGROUND);
    
    display.drawFillRectGradient(0, 0, SCREEN_WIDTH, 40, COLOR_GRID, COLOR_BACKGROUND, "vertical");
    
    display.setTextSize(3);
    display.setTextColor(COLOR_BACKGROUND);
    display.drawText("Select Bot", 40, 12);
    
    display.setTextSize(2);
    
    var easyColor = display.color(0, 200, 0);
    var mediumColor = display.color(255, 150, 0);
    var impossibleColor = display.color(220, 0, 0);

    drawMenuButton("Easy", 40, 50, 160, 20, 95, 55, menuState.selectedOption === 0, easyColor);
    drawMenuButton("Medium", 40, 75, 160, 20, 82, 80, menuState.selectedOption === 1, mediumColor);
    drawMenuButton("Impossible", 40, 100, 160, 20, 60, 105, menuState.selectedOption === 2, impossibleColor);

    display.drawFillCircle(50, 60, 3, (menuState.selectedOption === 0) ? COLOR_TEXT_INVERTED : easyColor);
    display.drawFillCircle(50, 85, 3, (menuState.selectedOption === 1) ? COLOR_TEXT_INVERTED : mediumColor);
    display.drawFillCircle(53, 82, 2, (menuState.selectedOption === 1) ? COLOR_TEXT_INVERTED : mediumColor);
    display.drawFillCircle(50, 110, 3, (menuState.selectedOption === 2) ? COLOR_TEXT_INVERTED : impossibleColor);
    display.drawFillCircle(53, 107, 2, (menuState.selectedOption === 2) ? COLOR_TEXT_INVERTED : impossibleColor);
    display.drawFillCircle(56, 110, 2, (menuState.selectedOption === 2) ? COLOR_TEXT_INVERTED : impossibleColor);
    
    display.setTextSize(1);
    display.setTextColor(COLOR_GRID);
    display.drawText("UP/DOWN - Navigate  SELECT - Choose  ESC - Back", 5, 125);
}

function draw_rematch_screen() {
    display.fill(COLOR_BACKGROUND);

    display.setTextSize(3);
    if (gameState.winner === 'T') {
        display.setTextColor(COLOR_TEXT);
        display.drawText("TIE!", 85, 20);
    } else {
        display.setTextColor(COLOR_WIN);
        display.drawText("WINNER!", 60, 20);
        if (gameState.winner === 'X') {
            drawCross(100, 45, 40, COLOR_X);
        } else {
            drawCircle(100, 45, 40, COLOR_O);
        }
    }

    display.setTextSize(2);
    drawMenuButton("Rematch", 40, 90, 160, 20, 75, 95, menuState.rematchSelection === 0);
    drawMenuButton("Menu", 40, 115, 160, 20, 90, 120, menuState.rematchSelection === 1);
}


function draw_game_screen() {
    display.fill(COLOR_BACKGROUND);

    for (var i = 1; i < 3; i++) {
        display.drawLine(i * CELL_SIZE, 0, i * CELL_SIZE, BOARD_SIZE, COLOR_GRID);
        display.drawLine(0, i * CELL_SIZE, BOARD_SIZE, i * CELL_SIZE, COLOR_GRID);
    }
    for (var row = 0; row < 3; row++) {
        for (var col = 0; col < 3; col++) {
            var cellX = col * CELL_SIZE;
            var cellY = row * CELL_SIZE;
            if (gameState.field[row][col] === 'O') drawCircle(cellX, cellY, CELL_SIZE, COLOR_O);
            else if (gameState.field[row][col] === 'X') drawCross(cellX, cellY, CELL_SIZE, COLOR_X);
        }
    }
    
    display.setTextSize(2);
    if (gameState.winner) {
        if (gameState.winner === 'T') {
            display.setTextColor(COLOR_TEXT);
            display.drawText("TIE!", INFO_PANEL_X, 40);
            drawCross(INFO_PANEL_X + 20, 65, 40, COLOR_X);
            drawCircle(INFO_PANEL_X + 20, 65, 40, COLOR_O);
        } else {
            display.setTextColor(COLOR_WIN);
            display.drawText("WINNER!", INFO_PANEL_X, 40);
            if (gameState.winner === 'X') drawCross(INFO_PANEL_X + 20, 65, 40, COLOR_X);
            else drawCircle(INFO_PANEL_X + 20, 65, 40, COLOR_O);
            if (gameState.winInfo) display.drawLine(gameState.winInfo.x1, gameState.winInfo.y1, gameState.winInfo.x2, gameState.winInfo.y2, COLOR_WIN);
        }
    } else {
        display.setTextColor(COLOR_TEXT);
        display.drawText("Player:", INFO_PANEL_X, 15);
        if (gameState.player === 'X') drawCross(INFO_PANEL_X + 20, 35, 30, COLOR_X);
        else drawCircle(INFO_PANEL_X + 20, 35, 30, COLOR_O);

        display.drawText("SCORE", INFO_PANEL_X, 75);
        display.setTextColor(COLOR_X);
        display.drawText("X: " + to_string(gameState.scoreX), INFO_PANEL_X, 95);
        display.setTextColor(COLOR_O);
        display.drawText("O: " + to_string(gameState.scoreO), INFO_PANEL_X, 115);
        
        var selectedRow = Math.floor(gameState.selectionIndex / 3);
        var selectedCol = gameState.selectionIndex % 3;
        var selBoxX = selectedCol * CELL_SIZE;
        var selBoxY = selectedRow * CELL_SIZE;
        display.drawRect(selBoxX + 1, selBoxY + 1, CELL_SIZE - 2, CELL_SIZE - 2, COLOR_SELECTION);
        display.drawRect(selBoxX + 2, selBoxY + 2, CELL_SIZE - 4, CELL_SIZE - 4, COLOR_SELECTION);
    }
}

// --- GAME LOGIC & AI FUNCTIONS ---

function player_switch() {
    gameState.player = (gameState.player === 'X') ? 'O' : 'X';
}

function clear_game_field() {
    for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
            gameState.field[i][j] = ' ';
        }
    }
    gameState.selectionIndex = 4;
    gameState.winner = null;
    gameState.winInfo = null;
}

function set_starting_player() {
    if (gameState.gameMode === 'PVP') {
        gameState.player = 'X';
        return;
    }
    var totalRounds = gameState.scoreX + gameState.scoreO;
    if (totalRounds % 2 === 0) {
        gameState.player = 'X';
    } else {
        gameState.player = 'O';
    }
}

function handle_round_end() {
    if (gameState.winner === 'X') gameState.scoreX++;
    else if (gameState.winner === 'O') gameState.scoreO++;
    
    clear_game_field();
    set_starting_player();
}

function calculate_win_line(type, index) {
    var halfCell = CELL_SIZE / 2;
    var line = { x1: 0, y1: 0, x2: 0, y2: 0 };
    if (type === 'row') {
        line.x1 = 0; line.y1 = (index * CELL_SIZE) + halfCell;
        line.x2 = BOARD_SIZE; line.y2 = line.y1;
    } else if (type === 'col') {
        line.x1 = (index * CELL_SIZE) + halfCell; line.y1 = 0;
        line.x2 = line.x1; line.y2 = BOARD_SIZE;
    } else if (type === 'diag1') {
        line.x1 = 0; line.y1 = 0; line.x2 = BOARD_SIZE; line.y2 = BOARD_SIZE;
    } else if (type === 'diag2') {
        line.x1 = BOARD_SIZE; line.y1 = 0; line.x2 = 0; line.y2 = BOARD_SIZE;
    }
    return line;
}

function check_winner_logic(player) {
    for (var i = 0; i < 3; i++) {
        if (gameState.field[i][0] === player && gameState.field[i][1] === player && gameState.field[i][2] === player) return { type: 'row', index: i };
        if (gameState.field[0][i] === player && gameState.field[1][i] === player && gameState.field[2][i] === player) return { type: 'col', index: i };
    }
    if (gameState.field[0][0] === player && gameState.field[1][1] === player && gameState.field[2][2] === player) return { type: 'diag1' };
    if (gameState.field[2][0] === player && gameState.field[1][1] === player && gameState.field[0][2] === player) return { type: 'diag2' };
    return null;
}

function find_winning_move(player) {
    for (var r = 0; r < 3; r++) {
        for (var c = 0; c < 3; c++) {
            if (gameState.field[r][c] === ' ') {
                gameState.field[r][c] = player;
                var isWin = check_winner_logic(player) !== null;
                gameState.field[r][c] = ' ';
                if (isWin) return { row: r, col: c };
            }
        }
    }
    return null;
}

function bot_move_easy() {
    var availableCells = [];
    for (var r = 0; r < 3; r++) {
        for (var c = 0; c < 3; c++) {
            if (gameState.field[r][c] === ' ') {
                availableCells.push({ row: r, col: c });
            }
        }
    }
    if (availableCells.length > 0) {
        return availableCells[random(availableCells.length)];
    }
    return null;
}

function bot_move_medium() {
    var winMove = find_winning_move('O');
    if (winMove) return winMove;
    var blockMove = find_winning_move('X');
    if (blockMove) return blockMove;
    return bot_move_easy();
}

function bot_move_impossible() {
    var winMove = find_winning_move('O');
    if (winMove) return winMove;
    
    var blockMove = find_winning_move('X');
    if (blockMove) return blockMove;
    
    var emptySpaces = 0;
    for (var r = 0; r < 3; r++) {
        for (var c = 0; c < 3; c++) {
            if (gameState.field[r][c] === ' ') emptySpaces++;
        }
    }
    
    if (emptySpaces === 9) return { row: 0, col: 0 };
    
    if (emptySpaces === 8) {
        if (gameState.field[1][1] === ' ') return { row: 1, col: 1 };
        var corners = [{row: 0, col: 0}, {row: 0, col: 2}, {row: 2, col: 0}, {row: 2, col: 2}];
        for (var i = 0; i < corners.length; i++) {
            if (gameState.field[corners[i].row][corners[i].col] === ' ') return corners[i];
        }
    }
    
    var forkMove = find_fork_move('O');
    if (forkMove) return forkMove;
    
    var blockForkMove = find_fork_move('X');
    if (blockForkMove) return blockForkMove;
    
    if (gameState.field[1][1] === ' ') return { row: 1, col: 1 };
    
    if (gameState.field[0][0] === 'X' && gameState.field[2][2] === ' ') return { row: 2, col: 2 };
    if (gameState.field[2][2] === 'X' && gameState.field[0][0] === ' ') return { row: 0, col: 0 };
    if (gameState.field[0][2] === 'X' && gameState.field[2][0] === ' ') return { row: 2, col: 0 };
    if (gameState.field[2][0] === 'X' && gameState.field[0][2] === ' ') return { row: 0, col: 2 };
    
    var corners = [{row: 0, col: 0}, {row: 0, col: 2}, {row: 2, col: 0}, {row: 2, col: 2}];
    for (var i = 0; i < corners.length; i++) {
        if (gameState.field[corners[i].row][corners[i].col] === ' ') return corners[i];
    }
    
    var edges = [{row: 0, col: 1}, {row: 1, col: 0}, {row: 1, col: 2}, {row: 2, col: 1}];
    for (var i = 0; i < edges.length; i++) {
        if (gameState.field[edges[i].row][edges[i].col] === ' ') return edges[i];
    }
    
    return bot_move_easy();
}

function find_fork_move(player) {
    for (var r = 0; r < 3; r++) {
        for (var c = 0; c < 3; c++) {
            if (gameState.field[r][c] === ' ') {
                gameState.field[r][c] = player;
                var threatsCount = 0;
                
                for (var i = 0; i < 3; i++) {
                    var playerCount = 0, emptyCount = 0;
                    for (var j = 0; j < 3; j++) {
                        if (gameState.field[i][j] === player) playerCount++;
                        else if (gameState.field[i][j] === ' ') emptyCount++;
                    }
                    if (playerCount === 2 && emptyCount === 1) threatsCount++;
                }
                
                for (var j = 0; j < 3; j++) {
                    var playerCount = 0, emptyCount = 0;
                    for (var i = 0; i < 3; i++) {
                        if (gameState.field[i][j] === player) playerCount++;
                        else if (gameState.field[i][j] === ' ') emptyCount++;
                    }
                    if (playerCount === 2 && emptyCount === 1) threatsCount++;
                }
                
                var playerCount1 = 0, emptyCount1 = 0;
                var playerCount2 = 0, emptyCount2 = 0;
                for (var i = 0; i < 3; i++) {
                    if (gameState.field[i][i] === player) playerCount1++;
                    else if (gameState.field[i][i] === ' ') emptyCount1++;
                    if (gameState.field[i][2-i] === player) playerCount2++;
                    else if (gameState.field[i][2-i] === ' ') emptyCount2++;
                }
                if (playerCount1 === 2 && emptyCount1 === 1) threatsCount++;
                if (playerCount2 === 2 && emptyCount2 === 1) threatsCount++;

                gameState.field[r][c] = ' ';
                
                if (threatsCount >= 2) return { row: r, col: c };
            }
        }
    }
    return null;
}

function bot_move() {
    if (gameState.winner || gameState.player !== 'O') return;

    var move;
    if (gameState.botDifficulty === 'EASY') move = bot_move_easy();
    else if (gameState.botDifficulty === 'MEDIUM') move = bot_move_medium();
    else if (gameState.botDifficulty === 'IMPOSSIBLE') move = bot_move_impossible();

    if (move) {
        gameState.field[move.row][move.col] = 'O';
        player_switch();
    }
}

function update_game_state_after_move() {
    var winCheckX = check_winner_logic('X');
    var winCheckO = check_winner_logic('O');
    if (winCheckX) {
        gameState.winner = 'X';
        gameState.winInfo = calculate_win_line(winCheckX.type, winCheckX.index);
    } else if (winCheckO) {
        gameState.winner = 'O';
        gameState.winInfo = calculate_win_line(winCheckO.type, winCheckO.index);
    } else {
        var is_tie = true;
        for (var r = 0; r < 3; r++) {
            for (var c = 0; c < 3; c++) {
                if (gameState.field[r][c] === ' ') {
                    is_tie = false;
                }
            }
        }
        if (is_tie) gameState.winner = 'T';
    }
}

// --- MAIN LOOPS (STATE MACHINE) ---

function menu_loop() {
    var needsRedraw = true;
    menuState.selectedOption = 0;
    while (currentScreen === 'MAIN_MENU') {
        if (needsRedraw) {
            draw_main_menu();
            needsRedraw = false;
        }
        if (keyboard.getNextPress() || keyboard.getPrevPress()) {
            menuState.selectedOption = 1 - menuState.selectedOption;
            needsRedraw = true;
        }
        if (keyboard.getSelPress()) {
            if (menuState.selectedOption === 0) {
                gameState.gameMode = 'PVP';
                currentScreen = 'GAME';
            } else {
                currentScreen = 'DIFFICULTY_MENU';
            }
            gameState.scoreX = 0;
            gameState.scoreO = 0;
            clear_game_field();
            set_starting_player();
            break;
        }
        if (keyboard.getEscPress()) return false;
        delay(50);
    }
    return true;
}

function difficulty_menu_loop() {
    var needsRedraw = true;
    menuState.selectedOption = 0;
    while (currentScreen === 'DIFFICULTY_MENU') {
        if (needsRedraw) {
            draw_difficulty_menu();
            needsRedraw = false;
        }
        if (keyboard.getNextPress()) {
            menuState.selectedOption = (menuState.selectedOption + 1) % 3;
            needsRedraw = true;
        }
        if (keyboard.getPrevPress()) {
            menuState.selectedOption = (menuState.selectedOption - 1 + 3) % 3;
            needsRedraw = true;
        }
        if (keyboard.getSelPress()) {
            if (menuState.selectedOption === 0) gameState.botDifficulty = 'EASY';
            else if (menuState.selectedOption === 1) gameState.botDifficulty = 'MEDIUM';
            else if (menuState.selectedOption === 2) gameState.botDifficulty = 'IMPOSSIBLE';
            gameState.gameMode = 'BOT';
            currentScreen = 'GAME';
            clear_game_field();
            set_starting_player();
            break;
        }
        if (keyboard.getEscPress()) {
            currentScreen = 'MAIN_MENU';
            break;
        }
        delay(50);
    }
}

function rematch_loop() {
    var needsRedraw = true;
    while (currentScreen === 'REMATCH') {
        if (needsRedraw) {
            draw_rematch_screen();
            needsRedraw = false;
        }

        if (keyboard.getNextPress() || keyboard.getPrevPress()) {
            menuState.rematchSelection = 1 - menuState.rematchSelection;
            needsRedraw = true;
        }

        if (keyboard.getSelPress()) {
            if (menuState.rematchSelection === 0) { // Rematch
                handle_round_end();
                currentScreen = 'GAME';
            } else { // Menu
                currentScreen = 'MAIN_MENU';
            }
            break;
        }
        
        if (keyboard.getEscPress()) {
            currentScreen = 'MAIN_MENU';
            break;
        }
        delay(50);
    }
}

function game_screen_loop() {
    var needsRedraw = true;
    while (currentScreen === 'GAME') {
        if (!gameState.winner) {
            var actionTaken = false;
            if (gameState.gameMode === 'BOT' && gameState.player === 'O') {
                delay(250);
                bot_move();
                actionTaken = true;
            } else {
                if (keyboard.getNextPress()) {
                    gameState.selectionIndex++;
                    actionTaken = true;
                }
                if (keyboard.getPrevPress()) {
                    gameState.selectionIndex--;
                    actionTaken = true;
                }
                if (gameState.selectionIndex > 8) gameState.selectionIndex = 0;
                if (gameState.selectionIndex < 0) gameState.selectionIndex = 8;

                if (keyboard.getSelPress()) {
                    var row = Math.floor(gameState.selectionIndex / 3);
                    var col = gameState.selectionIndex % 3;
                    if (gameState.field[row][col] === ' ') {
                        gameState.field[row][col] = gameState.player;
                        player_switch();
                        actionTaken = true;
                    }
                }
            }
            
            if (actionTaken) {
                update_game_state_after_move();
                needsRedraw = true;
            }
        }
        
        if (keyboard.getEscPress()) {
            currentScreen = 'MAIN_MENU';
            break;
        }
        
        if (needsRedraw) {
            draw_game_screen();
            needsRedraw = false;
        }
        
        if (gameState.winner) {
            delay(1000); 
            currentScreen = 'REMATCH';
            break;
        }

        delay(50);
    }
}

function main() {
    while(true) {
        if (currentScreen === 'MAIN_MENU') {
            if (!menu_loop()) break;
        } else if (currentScreen === 'DIFFICULTY_MENU') {
            difficulty_menu_loop();
        } else if (currentScreen === 'GAME') {
            game_screen_loop();
        } else if (currentScreen === 'REMATCH') {
            rematch_loop();
        }
    }
}

// --- START THE GAME ---
main();
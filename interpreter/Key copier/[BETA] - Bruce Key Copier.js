//Author: github.com/personwithbeans
//Lisence: AGPL-3.0 license

//listen, I know this is probably an orginizational nightmare but it works
//default variables set for kwikset keys
//also currenlty only make to work on lilygo t-embed series of devices or at least ones with 4 differnt input methods
//all function names are self-explanatory , I hope.

//bring modules in
const display = require("display");
const dialog = require("dialog");
const storage = require("storage");

var BGColour = BRUCE_BGCOLOR;       // Currrent BG colour set by bruce
var PriColour = BRUCE_PRICOLOR;     // Currrent Pri colour set by bruce
var screenWidth = width();
var screenHeight = height();        //who knows if this is even usefull or ever will be...      ...Do I even need this????????
var leftBorder = 20;                // Left border for the drawing area in pixels
var rightBorder = 40;               // Right border for the drawing area in pixels
var topBorder = 50;                 // as to be expected its the border for the top
var horizontalTextAllignment = 1;   // 0 | 1 | 2 || left | center | right
var verticalTextAllignment = 0;     // 0 | 1 | 2 || top | middle | bottom
var textSize = 2;//DEAR GOD I TRIED 10, ITS WAY TO BIG. 2 seemes to be the default. 1 is barely visible is there no middle ground!!!?!???!?!?!
var rootDirContents = [storage.readdir({ fs: "sd", path: "/" })];//used to check if the BruceKeys folder exists



var keychoice = "kwikset_kw1";//default
var notches = [0, 0, 0, 0, 0]; // Array to hold key depths
var currentNotch = 1; // Current notch selected of the key | starting at 1 = firstposition from left, Key pointing right
var amountOfNotches = 5; // Number of notches
var maxNotchDepth = 70; // Maximum depth of the notches | also can be the distance between the segments
var amountOfDepths = 7; // 10 for kwikset
var currentNotchDepth = 0; // Current height of the key
var depthPerSegment = (maxNotchDepth / amountOfDepths)
var depthWidth = 2;//total width gets double this value
var verticalLineBuffer = 10;

var cordinates = [//holds the cordinate positions for the line points
    [0, 50],// first two and last two points arnt notches
    [20, 50],// screen size - ~20 seems to be just at the edge for x axis
    [90, 60],// X value from left side of screen | Y value from top of screen (for some reason its that way)
    [110, 40],
    [130, 70],
    [150, 60],
    [170, 60],
    [200, 90],
    [190, 90]//does not draw a line after this
    //final line end point [2 extra for the end lines]
];

var tipCordinates = [//array should be +1 longer than the # of notches
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0]
];

//key profiles [WIP - Additional variables will be needed in these][ill do my best with these but no guarantees]
var Kwikset_KW1 = {
    amountOfNotches: 5,
    amountOfDepths: 7,
    maxNotchDepth: 70,
    leftBorder: 20,
    rightBorder: 40,
    topBorder: 50,
    depthWidth: 2,
    verticalLineBuffer: 10//not sure how usefull this is 
};
var Schlage_SC1 = { //SC1 is the ony version i have
    amountOfNotches: null,
    amountOfDepths: null,
    maxNotchDepth: null,
    leftBorder: null,
    rightBorder: null,
    topBorder: null,
    depthWidth: null,
    verticalLineBuffer: null//not sure how usefull this is 
};
var Arrow_AR4 = {
    amountOfNotches: null,
    amountOfDepths: null,
    maxNotchDepth: null,
    leftBorder: null,
    rightBorder: null,
    topBorder: null,
    depthWidth: null,
    verticalLineBuffer: null//not sure how usefull this is 
};
var Master_Lock_M1 = {
    amountOfNotches: null,
    amountOfDepths: null,
    maxNotchDepth: null,
    leftBorder: null,
    rightBorder: null,
    topBorder: null,
    depthWidth: null,
    verticalLineBuffer: null//not sure how usefull this is 
};
var American_AM7 = {
    amountOfNotches: null,
    amountOfDepths: null,
    maxNotchDepth: null,
    leftBorder: null,
    rightBorder: null,
    topBorder: null,
    depthWidth: null,
    verticalLineBuffer: null//not sure how usefull this is 
};

//most of of the following is probably stupid and hosnesty the fact that it works in magic

function calculateLineSegments() {//calculate individual spacing between each notch and sets
    var spaceToUtilize = screenWidth - (leftBorder + rightBorder)
    var pixelsPerDivision = spaceToUtilize / cordinates.length
    maxNotchDepth = pixelsPerDivision
    for (var i = 0; i < notches.length; i++) {
        cordinates[i + 2][0] = (pixelsPerDivision * (i + 1)) + leftBorder
    }
    cordinates[8][0] = (pixelsPerDivision * 7) + leftBorder
}

function resetDepths() {//whoa who could have guessed it resets the height. NOT LIKE ITS IN THE FREEKIN NAME.
    for (var i = 0; i < notches.length; i++) {
        cordinates[i + 2][1] = topBorder//starting depth from top of screen
    }
    for (var i = 0; i < notches.length; i++) {
        notches[i] = 0
    }
    currentNotchDepth = 0
}

function drawDepthValues() {//display the depth values above
    for (var i = 0; i < notches.length; i++) {
        display.drawString(notches[i], cordinates[i + 2][0], topBorder / 2)
    }

    for (var i = 0; i < notches.length; i++) {//add lines that extend down from these
        var x = cordinates[i + 2][0]
        var y1 = ((topBorder / 2) + verticalLineBuffer + 10); //top y value (+ 10 is a little extra to clear the numbers above)
        var y2 = (cordinates[i + 2][1] - verticalLineBuffer); //bottom y value
        if (y2 - y1 > 0) {
            display.drawLine(
                x, y1, x, y2, PriColour
            );
        }
    }
}

function drawLines() {//WHOOOAAA, you can draw lines????? crazy
    drawString(keychoice, screenWidth - 80, 5);//display type of key selected
    // for (var i = 0; i < cordinates.length - 3; i++) {//go though each point and render
    //     var x1 = cordinates[i + 1][0] + depthWidth;//add space for little platau
    //     var y1 = cordinates[i + 1][1];
    //     var x2 = cordinates[i + 2][0] - depthWidth;//add space for little platau
    //     var y2 = cordinates[i + 2][1];

    //     display.drawLine(
    //         x1, y1, x2, y2, PriColour
    //     );
    // }

    for (var i = 0; i < notches.length; i++) {//add little line in between sloaped lines "\_/""
        var x1 = cordinates[i + 2][0] - depthWidth;
        var y1 = cordinates[i + 2][1];
        var x2 = cordinates[i + 2][0] + depthWidth;
        var y2 = cordinates[i + 2][1];
        display.drawLine(
            x1, y1, x2, y2, PriColour
        );
    }
    //additional lines [kwikset_kw1]
    display.drawLine(cordinates[7][0], cordinates[7][1] - 4, cordinates[7][0], cordinates[7][1] + 6, PriColour)// + 10 need to be writable variable for multiple keys
    display.drawLine(cordinates[7][0], cordinates[7][1] + 6, cordinates[7][0] - 15, cordinates[7][1] + 26, PriColour)//need to change to varaible controlled for multiple keys
    display.drawLine(cordinates[7][0] - 15, cordinates[7][1] + 26, 0, cordinates[7][1] + 26, PriColour)
    display.drawLine(0, topBorder, tipCordinates[0][0], topBorder, PriColour)
}

function DrawTips() {
    for (var i = 0; i < amountOfNotches + 1; i++) {//i wish i could say that desmos was helpfull or understanding this part
        var x01 = cordinates[i + 1][0] + depthWidth;
        var y01 = cordinates[i + 1][1];
        var x02 = cordinates[i + 2][0] - depthWidth;
        var y02 = cordinates[i + 2][1];
      

        tipCordinates[i][0] = ((-(x01 - x02) / 2) + x01 + ((((y01) - (y02)) / 2)))//works, dont ask how [if you are interested just look at this: desmos.com/calculator/apyp2om3ic]

        var tipYVal = ((y01 + y02) / 2) - ((x02 - x01) / 2);

        if (tipYVal >= topBorder) {
            tipCordinates[i][1] = tipYVal
        } else {
            tipCordinates[i][1] = topBorder
        }


        display.drawCircle(tipCordinates[i][0], tipCordinates[i][1], 2, PriColour)
    }
    for (var i = 0; i < amountOfNotches; i++) {
        display.drawLine(tipCordinates[i][0], tipCordinates[i][1], cordinates[i + 2][0] - depthWidth, cordinates[i + 2][1], PriColour)//draw left lines
        display.drawLine(tipCordinates[i + 1][0], tipCordinates[i + 1][1], cordinates[i + 2][0] + depthWidth, cordinates[i + 2][1], PriColour)//draw right lines
    }
}

function mainMenu() {
    var choice = dialogChoice([//how the fuck does this function work
        "[WIP] Change Key Type", "keyChange",
        "Save key", "saveKey",
        "Load key", "loadKey",
        "New Key", "newKey",
        "Exit", "exit"
    ]) || "";
    if (choice == "exit") {
        return choice// returns and main loop checks for exit
    }
    if (choice == "cancel") {
        return;
    }
    if (choice == "saveKey") {
        saveKey()
        return;
    }
    if (choice == "loadKey") {
        loadKey()
        return;
    }
    if (choice == "newKey") {
        resetDepths()
        refreshScreen()
        return;
    }
    if (choice == "keyChange") {
        var keychoice = dialogChoice([//default key whould be kwikset [ONLY GONNA BE WORKED ON AFTER I GET SOMTHING IN PLACE TO DEAL WITH THE FUCKY FUCKY VARIABLES], also how the fuck does this work?
            "Kwikset KW1", "kwikset_kw1",
            "Schlage SC4", "schlage_sc4",
            "Arrow AR4", "arrow_ar4",
            "Master Lock M1", "masterlock_m1",
            "American AM7", "american_am7",
            "Back", "back"
        ]) || "";

        if (keychoice === "back") {
            display.fill(BGColour);
            mainMenu();
        } else {
            display.fill(BGColour);
            return;//returns to main menu
        }
    }
    refreshScreen()//update/refresh the screen on exit of main menu using cancel button
}

function changeSelectedNotch() {//if you are reading these notes why are you doing this to yourself. Haven't someone alredy suffered enough?
    if (currentNotch < amountOfNotches) {
        currentNotch += 1;
    } else if (currentNotch >= amountOfNotches) {
        currentNotch = 1; // Reset to first notch
    }
    currentNotchDepth = notches[currentNotch - 1]
}

function drawHighighter() {//highlights the notch currently sellected to be changed
    var currentNotchX = cordinates[currentNotch + 1][0]// +1 to start on the right point in the array
    var currentNotchY = cordinates[currentNotch + 1][1]
    display.drawCircle(currentNotchX, currentNotchY, 5, PriColour)//x | y | Radius | Colour
}

function updatecurrentNotchHeight() {//updates notch height after value ajusted, no idea if this is even needed
    cordinates[currentNotch + 1][1] = (currentNotchDepth * (maxNotchDepth / amountOfDepths)) + topBorder;//-1 accounts for array// +1 accounts for the end points current notch starts at 1
    notches[currentNotch - 1] = currentNotchDepth
    refreshScreen()
}

function textSetup() {
    display.setTextAlign(horizontalTextAllignment, verticalTextAllignment)
    display.setTextSize(textSize)
    display.setTextColor(display.color(225, 225, 225))
}

function collectKeyData() {//putts all the data into a large array
    var keyData = [keychoice, notches];
    return keyData;
}

function fileCheck() {// Return the first available number
    var DirContents = storage.readdir({ fs: "sd", path: "/BruceKeys" });
    for (var i = 0; i < 100; i++) {
        if (String(i).length == 1) {
            var filename = "KeyCopy_" + "0" + i + ".txt";
            if (DirContents.indexOf(filename) === -1) {
                i = ("0" + String(i))
                return i;
            }
        } else {
            var filename = "KeyCopy_" + i + ".txt";
            if (DirContents.indexOf(filename) === -1) {
                return i;
            }
        }
        // for (var i = 10; i < 100; i++) {

        //     }
    }
    return null; // All slots taken, currently hardcapped to max of 100 to prevents some sort of infinite loop, if you need over 100 saved keys you have an issue
}

function fileDataWrite(filenameEndValue) {//writes the data for a file, don't know if it can create a file though

    if (storage.write({ fs: "sd", path: "/BruceKeys/KeyCopy_" + filenameEndValue + ".txt" }, collectKeyData(), "write")) {
        dialog.success("File saved succesfully in /Brucekeys.");
        delay(500)
    }
}

function dirCheck() {//checks in the BruceKeys folder exists in the sd directory [in future maybe if no sd then divert to small file system, check at start]
    for (var i = 0; i < rootDirContents.length; i++) {//for to loop search trough the array untill it goes through te whole thing for finds the target string
        if (rootDirContents[i] == "BruceKeys") {
            var keysFolderExists = true;
        } else {
            var keysFolderExists = false;
        }
    }
    dialog.success(keysFolderExists);
    delay(500)
    return keysFolderExists;

}

function saveKey() {//main function to save file
    if (dirCheck() == true) {//checks in the BruceKeys folder exists in the sd directory [in future maybe if no sd then divert to small file system, check at start]
        fileDataWrite(fileCheck())//checks what end number it needs to use for the file name to not overwrite another file
    } else {
        storage.mkdir({ fs: "sd", path: "/BruceKeys" });//creates folder if no detected on sd card
        if (dirCheck() == true) { //Double checks if successfully created
            dialog.success("BruceKeys folder created successfully.");
            delay(500);
        }
        fileDataWrite(fileCheck())//checks what end number it needs to use for the file name to not overwrite another file
    }
    return;
}

function loadKey() {//selve explanitory function name
    var chosenFile = dialog.pickFile("/BruceKeys", "txt");//haveu ser select file
    if (!chosenFile) {//if operaiton is canceled display error message
        dialog.error("No file selected.");
        delay(500)
    }
    // Read the file contents
    var fileString = storage.read({ fs: "sd", path: chosenFile });
    var fileData = fileString.split(",");//split into array


    keychoice = fileData[0]
    for (i = 0; i < fileData.length - 1; i++) {//update notch numbers
        notches[i] = Number(fileData[i + 1])
    }
    for (i = 0; i < fileData.length - 1; i++) {//update line endpoint cordinates
        cordinates[i + 2][1] = ((depthPerSegment * Number(fileData[i + 1])) + topBorder)
        dialog.success("Key loaded");
        delay(500)
    }

    refreshScreen();
    return;
}

function refreshScreen() {//refreshes screen/updates any information
    textSetup();
    display.fill(BGColour);
    drawHighighter();
    drawLines();
    drawDepthValues();
    DrawTips();
}

//screen size (320x170) 
// 1.9 inch ST7789V IPS color TFT LCD

//innitial setup
calculateLineSegments()
textSetup()
display.fill(BGColour);
resetDepths()
drawLines()
drawHighighter()
drawDepthValues()
DrawTips()

refreshScreen()//fixes loading issues with the DrawTips() Function

//main loop
while (true) {
    if (getEscPress()) {
        choice = mainMenu()
        textSetup()//why is this here??
        if (choice === "exit") {
            break;
        }
        refreshScreen()
    }
    if (getSelPress()) {
        display.fill(BGColour);
        changeSelectedNotch()
        refreshScreen()

    }
    if (getNextPress() && currentNotchDepth < amountOfDepths) {
        currentNotchDepth += 1;
        updatecurrentNotchHeight()
        refreshScreen()
        delay(20);
    }
    if (getPrevPress() && currentNotchDepth > 0) {
        currentNotchDepth -= 1;
        updatecurrentNotchHeight()
        refreshScreen()
        delay(20);
    }
}
//congrats you've reached the end of my crappy code that somehow works

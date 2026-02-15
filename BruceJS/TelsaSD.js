var storage = require("storage");
var subghz = require("subghz");

var TelsaSubs = {fs: "sd", path: "/BruceRF/Vehicles/Tesla/TeslaJS"};
var shouldExit = false;

try {
    storage.readdir(TelsaSubs.path);
} catch(e) {
    fillScreen(color(0,0,0));
    setTextColor(color(255,0,0));
    setTextSize(2);
    drawString("Missing contents,", 20, 60);
    delay(3000);
    shouldExit = true;
}

function listSubFiles() {
    var files = storage.readdir(TelsaSubs.path);
    var subs = [];
    for (var i = 0; i < files.length; i++) {
        if (files[i].indexOf(".sub") > -1) subs.push(files[i]);
    }
    return subs;
}

function drawMain() {
    fillScreen(color(0,0,0));
    setTextColor(color(0,150,255));
    setTextSize(2);
    drawString("Tesla Brute force", 80, 20);
    setTextColor(color(0,255,100));
    drawString("Start", 130, 70);
    setTextColor(color(255,255,255));
    setTextSize(1);
    drawString("Made by Human", 170, 150);
}

function sendSignals(subs) {
    for (var i = 0; i < subs.length; i++) {
        if (getEscPress()) {
            shouldExit = true;
            break;
        }
        fillScreen(color(0,0,0));
        setTextColor(color(0,150,255));
        setTextSize(2);
        drawString("Sending.. (" + (i+1) + "/" + subs.length + ")", 40, 70);
        subghz.transmitFile(TelsaSubs.path + "/" + subs[i]);
        delay(200);
    }
}

if (!shouldExit) drawMain();

while (!shouldExit) {
    if (getEscPress()) {
        shouldExit = true;
        break;
    }
    if (getSelPress()) {
        var subs = listSubFiles();
        if (subs.length === 0) {
            fillScreen(color(0,0,0));
            setTextColor(color(255,0,0));
            setTextSize(2);
            drawString("No .sub files found!", 40, 70);
            delay(3000);
            shouldExit = true;
            break;
        }
        sendSignals(subs);
        if (!shouldExit) drawMain();
    }
    delay(50);
}

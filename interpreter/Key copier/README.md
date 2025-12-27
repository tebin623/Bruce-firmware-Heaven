## Creator [personwithbeans](https://github.com/personwithbeans/Bruce-Key-Copier/tree/main)

I'n new to JavaScript only realy knew a bit a python so enjoy my probably crappy code

Thank's to icy.1 on discord for providing an example just demonstrating rendering lines for me to start working of off.

## Only device currently intended to be supported is the Lilygo T-Embed series


## Working on
- working on improving the key drawings
- understanding the devices wierd ass coordinate system for drawing lines
- adding support for multiple keys types
- custom file names

## Usage

1. **Setup:**  
  Have Bruce Firmware installed on your device (currently only deisgned for Lillygo T-EMBED CC1101)
2. **Run the Script:**  
   Load  the script in your Bruce JS Interpreter.

3. **Controls:**
   - **Next & Back Button** Controls the height of the selected notch
   - **ESC Button:** Opens the main menu (change key type, save, new, exit).
   - **Select Button:** Cycles through the notches, highlighting the current one. 
   - **Display:** Shows the current key type and a graphical representation of the key profile. -- WIP/Rough Draft

5. **Key Types:**  
   The script supports the following key types by default:
   - Kwikset KW1
   - Schlage SC4 -- not yet supported
   - Arrow AR4 -- not yet supported
   - Master Lock M1 -- not yet supported
   - American AM7 -- not yet supported

## Customization

- **Add More Key Types:**   -- WIP
- **Colour Profiles:**  
  Currently just using the global colour values bruce is set to.

## Requirements

- Version of Bruce with JS interpreter ([github.com/pr3y/Bruce](url))
- 1.9" ST7789V IPS color TFT LCD (or compatible display) -- ( Lillygo T-Embed CC1101 | [lilygo.cc/products/t-embed-cc1101](url))

## Disclaimer

This script is for educational and lawful use only. Copying keys without permission is illegal in many jurisdictions.

---

**Author:**  
PersonWithBeans

**License:**  
AGPL-3.0 license

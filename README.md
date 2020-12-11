<img align="right" width="150" height="150" src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/150/apple/271/rocket_1f680.png">

# Fuselage
Fuselage is a set of tools to run full-fledged Linux (or virtualized Windows) on (almost) any chromebook without the need to press ```CTRL``` ```D``` every boot.
It uses the Brunch framework to generate a ChromeOS ISO, and then gives instructions on how to flash a full UEFI bios to the chromebook.

### Why not use Crostini or Crouton?
Remember, with the full UEFI bios by MrChromebox, there's not many drivers for most peripherals. What this does is take those drivers of a ChromeOS install and gives you, essentialy, *dev mode* ChromeOS without actually pressing ```CTRL``` ```D``` on every boot. **Note**: in one stage of the install you will need to enter dev mode.

## Prerequisites
* Check if your Chromebook is [supported](https://mrchromebox.tech/#devices)
* Intel 7th gen processor or newer / Geminilake
* Order a SuzyQable for 15$ (this allows you to flash a custom bios) from [Sparkfun](https://www.sparkfun.com/products/14746) or [Pimoroni](https://shop.pimoroni.com/products/suzyqable-chromeos-debug-cable)

## Installation
First, we need to flash MrChromebox's custom UEFI bios. As ripped from his [guide here](https://wiki.mrchromebox.tech/Firmware_Write_Protect#Disabling_WP_on_CR50_Devices_via_CCD),

### Enable Developer Mode
* Enter Recovery Mode: press/hold ESC and Refresh, then press Power for ~1s; release all 3 keys
* Press CTRL+D to switch to Developer Mode; confirm when prompted
* Press CTRL+D on Developer Mode splash screen to boot in Developer Mode
* On first boot, system will securely wipe all userdata (this takes a few minutes)

### Open CCD
* Open a crosh shell: CTRL+ALT+T and then type in ```shell``` and press enter
* Check the CCD state
```sudo gsctool -a -I```\
The CCD state should be reported as closed
* Open the CCD:

<img align="right" width="150" height="150" src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/150/apple/271/rocket_1f680.png">

# Fuselage
Fuselage is a set of tools to run full-fledged Linux (or virtualized Windows) on (almost) any new chromebook without the need to press ```CTRL``` ```D``` every boot (and full drivers!).
It uses the Brunch framework to generate a ChromeOS ISO, and then gives instructions on how to flash a full UEFI bios to the chromebook.

### Why not use Crostini or Crouton?
Remember, with the full UEFI bios by MrChromebox, there's not many drivers for most peripherals. What this does is take those drivers of a ChromeOS install and gives you, essentialy, *dev mode* ChromeOS without actually pressing ```CTRL``` ```D``` on every boot. **Note**: in one stage of the install you will need to enter dev mode.

## Prerequisites
* Check if your Chromebook is [supported](https://mrchromebox.tech/#devices) by making sure it has a ✅ under your chromebook name and the \
```UEFI Firmware (Full ROM)```
*  Kabylake / Amberlake Intel CPU **or** an AMD Stoney Ridge CPU
* Order a SuzyQable for 15$ (this allows you to flash a custom bios) from [Sparkfun](https://www.sparkfun.com/products/14746) or [Pimoroni](https://shop.pimoroni.com/products/suzyqable-chromeos-debug-cable)

## Installation

Fire up a [Crostini](https://www.androidcentral.com/how-install-linux-apps-your-chromebook) container and type in:\
```wget https://raw.githubusercontent.com/MilkyDeveloper/fuselage/main/brunch-setup.sh -v && sudo bash brunch-setup.sh```, enter your password and press enter.

Plug in a USB that holds a capacity of 16gb or more. After that, install the [Chromebook Recovery Tool](https://chrome.google.com/webstore/detail/chromebook-recovery-utili/jndclpdbaamdhonoechobihbbiimdgai?hl=en) from the Chrome Web Store and click the settings cog on the top-right and select ```Use local image```. Navigate to the Crostini section's Downloads Folder and select ```chromeos.iso```. Follow the settings on-screen.

### Flashing everything

First, we need to flash MrChromebox's custom UEFI bios. As ripped from his [guide here](https://wiki.mrchromebox.tech/Firmware_Write_Protect#Disabling_WP_on_CR50_Devices_via_CCD),

> The install seems lengthy but it really isn't if you follow the instructions carefully

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
```sudo gsctool -a -o```\
You will be prompted to assert physical presence (PP), which is a fancy way of saying to press the power button. Over the course of ~3 minutes, it will prompt you several times to press the power button. On the last time, the device will abruptly reboot and exit Developer Mode. Switch back to Developer Mode after this.

### Disable WP / Enable Firmware Flashing
At this point, you will need to connect the Suzy-Q cable to your ChromeOS device in a loopback manner - both ends of the cable will be connected to it. The USB-C end needs to be in the debug port (usually the left rear port on devices with multiple USB-C ports) and be facing the correct way (the debug part of the cable is not reversible). The USB-A end of the cable can connect to any open port. On devices with only USB-C ports, an adapter must be used.

* Verify cable connection:
```ls /dev/ttyUSB*```
This command should return 3 items: ttyUSB0, ttyUSB1, and ttyUSB2 \
If not, then your cable is connected to the wrong port or is upside down
* Change to a root shell:
```sudo su -```
* Disable hardware write-protect:\
```echo "wp false" > /dev/ttyUSB0```
```echo "wp false atboot" > /dev/ttyUSB0```
* Enable all CCD functionality always (allows unbricking/recovery in case CCD state is reset):
```echo "ccd reset factory" > /dev/ttyUSB0```
* Verify Changes:
```gsctool -a -I``` \
The CCD state should be opened, and the current value for all CCD flags should be set to Y/Always.
Note: the ccd command shows the current value followed by the default value in parentheses, so you can ignore the latter. \
```crossystem wpsw_cur```
The current WP value should be 0
* Now reboot the system:
```sudo reboot```

Almost done! 🎉

### Flashing the firmware
Open the shell (```CTRL``` ```ALT``` ```T```) and then enter ```shell``` in.

Then, punch in:\
```cd; curl -LO mrchromebox.tech/firmware-util.sh```\
```sudo install -Dt /usr/local/bin -m 755 firmware-util.sh```\
```sudo firmware-util.sh```\

and type in the number corresponding to ```Install/Update UEFI (Full ROM) Firmware```. Note: If the option is greyed out you did something wrong in this guide, redo it **or** double-check if your device is supported.

## Usage

Now all you have to do is plug in that USB. When you've booted, press ```F11``` to enter the BIOS and change the USB Boot Order. Just be sure to wait for the USB to boot for the first time (should take 30 minutes on slow chromebooks) and enable debugging features.

### Ubuntu 20.04 with KDE and all peripherals/drivers working

Fire up crosh (```CTRL``` ```ALT``` ```T```) and type in ```shell```. Now just enter the following commands:

```sudo curl -Lo ~/Downloads/crouton https://goo.gl/fd3zc && sudo install -Dt /usr/local/bin -m 755 ~/Downloads/crouton && sudo crouton``` (to install crouton) \
```sudo crouton -r focal -t xorg,audio,core,gtk-extra,x11,xfce``` (to setup our chroot. If you have a touchscreen chromebook at ```,touch``` at the end of the command) \
```sudo enter-chroot```

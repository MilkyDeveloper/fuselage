#!/bin/bash

# Script to setup a Brunch ISO and flash it to a USB

# Check if script is being ran as root
if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root (sudo at the start of it)."
  exit
fi

# CD to the home directory - just in case
cd ~/Downloads

# This isn't strictly neccessary but is good system maintenance
apt -y upgrade
apt -y update

# Install a few apt packages for building the Brunch ISO
apt -y install pv tar cgpt wget

# Check if the zip file is not downloaded; if so do it
if [ ! -f hatch-kohaku.zip ]; then

  # Important for debugging
  echo "Hatch image file not downloaded; downloading now..."

  # Curl the latest hatch image URL from a Github Gist
  hatchUrl=$(curl https://gist.githubusercontent.com/MilkyDeveloper/505b23bd60ccb52cc7f8fcf9ae8251cb/raw/736556ee8a7558b0cc3c3ab20cf6970e58615480/hatch-url)

  # And now just download it with wget
  wget -O hatch-kohaku.zip $hatchUrl

fi

# Unzip our file (specify -o to overwrite all files - no user input required)
# This method of detecting the zip is pretty fuzzy but fine for normal use
#if [ ! -f chrome ]; then
#  unzip -o hatch-kohaku.zip
#fi

# However, Wildcards need a different method
if compgen -G "*.bin" > /dev/null; then
    echo "Image already has been unzipped, continuing."
else
    echo "Image has not been unzipped, unzipping now."
    unzip -o hatch-kohaku.zip
fi

# Now that we've unzipped the image, we can use ls and some wilcards to find the name
chromeosLoc=$(ls chromeos_*.bin)

# Check if we've already download the brunch image, if not do so
if [ ! -f brunch.tar.gz ]; then
    # Curl the latest brunch URL from a Github Gist
    brunchUrl=$(curl https://gist.githubusercontent.com/MilkyDeveloper/ae6262bb02cd75d3296c8510012e71d7/raw/cfd606be25cb97e55ad6a020883c845f749ab9fa/brunch-url)

    # And now just download it with wget
    wget -O brunch.tar.gz $brunchUrl

    # Unzip it
    tar zxvf brunch.tar.gz
fi

# And now finally run brunch
bash chromeos-install.sh -src $chromeosLoc -dst brunch-chromeos.img

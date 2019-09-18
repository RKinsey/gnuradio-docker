# gnuradio-docker
GNU Radio on Ubuntu with scripts to enable GUI and audio functionality


# Dependencies
* X11 server for GUI
* Pulseaudio for sound

## Mac-specific info
* Recommended X11 server is XQuartz: [https://www.xquartz.org/]
* Homebrew is easiest for pulseaudio: [https://brew.sh]
...* Then use `brew install pulseaudio to install it (the script will handle starting it)
* You MUST have Virtualbox and the extension pack installed for USB passthrough: [https://www.virtualbox.org/wiki/Downloads]
# gnuradio-docker
GNU Radio on Ubuntu with scripts to enable GUI and audio functionality
# NOTE
These are potentially **Extremely** dangerous at the moment, use at your own risk

Until I can get an sdr to test with, nothing here has been tested for usb functionality.  
I've tested gnuradio-companion and sound on macos, but not on the others
# Dependencies
* X11 server for GUI
* Pulseaudio for sound

## Mac-specific Dependencies
* Recommended X11 server is XQuartz: [https://www.xquartz.org/]
* Homebrew is easiest for pulseaudio: [https://brew.sh]  
... Once you have homebrew, use `brew install pulseaudio` to install it (`macrunner.sh` will handle starting it)
* You MUST have Virtualbox and the extension pack installed for USB passthrough: [https://www.virtualbox.org/wiki/Downloads]

# Running the container
You can call `docker run rkinsey/gnuradio` with whatever arguments you like, but there are three scripts (one for each major OS group)in this to make things easier. 
Mac users: call `./macrunner.sh --setup` FIRST, or you'll have to manually setup a virtualbox vm called `gnuradio` for docker-machine
All: `./macrunner.sh /path/to/dir/for/container/home`
# gnuradio-docker
GNU Radio on Ubuntu with scripts to enable GUI and audio functionality
# NOTE
These are potentially **Extremely** dangerous at the moment, use at your own risk

Until I can get an sdr to test with, nothing here has been tested for usb functionality.  
I've tested gnuradio-companion and sound on macos, but not on the others
# Universal dependencies 
Ubuntu probably has both of these already, unless you're on a weird variant. 
* X11 server for GUI
* Pulseaudio for sound

## Mac instructions
* Recommended X11 server is XQuartz: [https://www.xquartz.org/]
* Homebrew is easiest for pulseaudio: [https://brew.sh]  
... Once you have homebrew, use `brew install pulseaudio` to install it (`macrunner.sh` will handle starting it)
* You MUST have Virtualbox and the extension pack installed for USB passthrough: [https://www.virtualbox.org/wiki/Downloads]
WHen you attach a new SDR, make sure you open VirtualBox and add a USB filter to your VM, there's a button with a green plus in the USB settings for the VM that lets you add a filter for a connected device.
# Running the container
You can call `docker run rkinsey/gnuradio` with whatever arguments you like, but there are three scripts (one for each major OS group)in this to make things easier. 
Mac users: call `./mac-gradio-docker.sh --setup` FIRST, or you'll have to manually setup a virtualbox vm called `gnuradio` for docker-machine
All: `./script-name.sh /path/to/dir/for/container/home`

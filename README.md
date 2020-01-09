# gnuradio-docker
GNU Radio on Ubuntu with scripts to enable GUI and audio functionality
# Update January 9, 2020  
I thought I'd made this update already, but I would **strongly** recommend against using this, particularly on macOS. The empty VirtualBox filter doesn't do what I thought it did; it gains exclusive control of *all* USB devices, so it'll capture every connection it thinks is new. This includes, say, a macbook's built-in keyboard and touchpad (which is apparently over USB). VBox also has some pretty bad latency, and some programs (e.g. limesuite's FFT viewer) require GPU acceleration, and that didn't work very well either.  
In short, use Macports or https://github.com/ktemkin/gnuradio-for-mac-without-macports. It's a huge pain to add custom blocks to the latter (though it does come with a bunch), but it's easy to use and quick to install. Macports is macports (and, at least in late October, took several hours to install gnuradio and its dependencies).
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

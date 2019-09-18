#Will have to use usb over ip
docker run -it --rm $-e DISPLAY=host.docker.internal:0  $-v $HOME/.config/pulse/:/home/gnuradio/.config/pulse/ --privileged rkinsey/gnuradio
#This isn't actually started
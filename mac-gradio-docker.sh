#!/bin/bash
VOL=$1
VMHOSTLOC=$(docker-machine inspect gnuradio --format {{.Driver.HostOnlyCIDR}}|cut -d'/' -f1)
AUDIOARG="-e PULSE_SERVER=$VMHOSTLOC"
X11ARG="-e DISPLAY=$VMHOSTLOC:0"
X11TMP="-v /tmp/.X11-unix:/tmp/.X11-unix"
PULSECOOKIE="-v $HOME/.config/pulse/:/root/.config/pulse/"

function cleanup {
    eval $(docker-machine env -u)
    if [[ $NOEXIT == "" ]]; then
        docker-machine stop gnuradio
    fi
}
function usage {
    printf "Usage:  ./macrunner.sh [--no-out|--gui] [--no-stop] <home volume>\n\t./macrunner.sh [--setup]\n\n\t--setup: run vm setup and exit\n\t--no-out: run docker without gui or sound\n\t--no-stop: don't stop vm when container exits\n\t--gui: only launch gui\n"
}
if [[ "$#" -lt 1 || "$#" -gt 4 ]]; then
    usage
    exit
fi
trap cleanup EXIT
while [[ ${1:0:1} == "-" ]]; do
    case $1 in
        --setup)    
            docker-machine create --driver virtualbox gnuradio
            docker-machine stop gnuradio
            trap - EXIT
            vboxmanage modifyvm gnuradio --usb on
            vboxmanage usbfilter add 0 --target gnuradio --name passthrough --action hold
            exit
            ;;
        
        --no-out)   
            VOL="$2"
            AUDIOARG=""
            X11ARG=""
            X11TMP=""
            PULSECOOKIE=""
            ;;

        --gui)
			VOL="$2"      
            ENTRYPOINT="--entrypoint=$1"
            ;;

        --no-stop)
            NOEXIT="t"
            ;;

        *)  
            usage()
            exit
            ;;
    esac
    shift
done
pactl list>/dev/null 2>&1
if [[ $PULSECOOKIE != "" && $? -ne 0 ]]; then
    xhost +>/dev/null 2>&1
fi
docker-machine start gnuradio
eval $(docker-machine env gnuradio)
docker run -it --rm $AUDIOARG $X11ARG $X11TMP $PULSECOOKIE $ENTRYPOINT -v $1:/root -u 0 --privileged rkinsey/gnuradio


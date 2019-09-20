#!/bin/bash
VOL=$1
VMHOSTLOC=$(docker-machine inspect gnuradio --format {{.Driver.HostOnlyCIDR}}|cut -d'/' -f1)
AUDIOARG="-e PULSE_SERVER=$VMHOSTLOC"
X11ARG="-e DISPLAY=$VMHOSTLOC:0"
X11TMP="-v /tmp/.X11-unix:/tmp/.X11-unix"
PULSECOOKIE="-v $HOME/.config/pulse/:/root/.config/pulse/"

function cleanup {
    eval $(docker-machine env -u)
    docker-machine stop gnuradio
}
trap cleanup EXIT
function usage {
    printf "Usage:  ./macrunner.sh [--setup] [--no-out|--gui] <home volume>\n\t--no-out: run docker without gui or sound\n\t--setup: run vm setup and exit\n\t--gui: only launch gui"
    exit
}
if [[ "$#" -lt 1 || "$#" -gt 4 ]];then
    usage
fi
while [[ ${1:0:1} == "-" ]];do
    case $1 in
        --setup)    
            docker-machine create --driver virtualbox gnuradio
            docker-machine stop gnuradio
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

        *)  
            usage
            exit
            ;;
    esac
    shift
done
pactl list>>/dev/null
if [[ $PULSECOOKIE != "" && $? -ne 0 ]]; then
    xhost +
fi
docker-machine start gnuradio
eval $(docker-machine env gnuradio)
docker run -it --rm $AUDIOARG $X11ARG $X11TMP $PULSECOOKIE $ENTRYPOINT -v $1:/root -u 0 --privileged rkinsey/gnuradio


#!/bin/bash
VOL=$1
VMHOSTLOC=$(docker-machine inspect gnuradio --format {{.Driver.HostOnlyCIDR}}|cut -d'/' -f1)
AUDIOARG="-e PULSE_SERVER=$VMHOSTLOC"
X11ARG="-e DISPLAY=$VMHOSTLOC:0"
X11TMP="-v /tmp/.X11-unix:/tmp/.X11-unix"
PULSECOOKIE="-v $HOME/.config/pulse/:/home/gnuradio/.config/pulse/"

function cleanup {
    eval $(docker-machine env -u)
    docker-machine stop gnuradio
    for p in $PULSEPID $XPID; do
        kill $PULSEPID
    done
}
trap cleanup EXIT
function usage {
    echo "Usage: ./macrunner.sh [--no-out] [--setup] [--entry <program>] <home volume>"
    echo "       --no-out: run docker without gui or sound"
    echo "       --setup: run vm setup and exit"
    echo "       --entry: sets the docker entrypoint to program"
    exit
}
if [[ "$#" -lt 1 || "$#" -gt 4 ]];then
    usage
fi
while [[ ${1:0:1} == "-" ]];do
    case $1 in
        --setup)    docker-machine create --driver virtualbox gnuradio
                    docker-machine stop gnuradio
                    vboxmanage modifyvm gnuradio --usb on
                    vboxmanage usbfilter add 0 --target gnuradio --name passthrough --action hold
                    exit
                    ;;
        
        --no-out)   VOL="$2"
                    AUDIOARG=""
                    X11ARG=""
                    X11TMP=""
                    PULSECOOKIE=""
                    ;;

        --entry)    shift
                    ENTRYPOINT="--entrypoint=$1"
                    ;;

        *)          usage
                    exit
                    ;;
    esac
    shift
done
pactl list>>/dev/null
if [[ $PULSECOOKIE != "" && $? -ne 0 ]]; then
    pulseaudio>/dev/null &
    PULSEPID=$!
    Xquartz&
    XPID=$!
    xhost +
fi

docker-machine start gnuradio
eval $(docker-machine env gnuradio)
docker run -it --rm $AUDIOARG $X11ARG $X11TMP $PULSECOOKIE $ENTRYPOINT -v $1:/home/gnuradio/ --privileged rkinsey/gnuradio
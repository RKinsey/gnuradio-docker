#!/bin/bash
VOL=$1
HOSTIP="$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')"
AUDIOARG="-e PULSE_SERVER=$HOSTIP"
X11ARG="-e DISPLAY=$HOSTIP:0"
X11TMP="-v /tmp/.X11-unix:/tmp/.X11-unix"
PULSECOOKIE="-v $HOME/.config/pulse/:/home/gnuradio/.config/pulse/"

function usage {
    printf "Usage: \n\t./linuxrunner.sh [--no-out | --companion] <home volume>\n\nOptions\n\t--no-out: run docker without gui or sound\n\t--companion: sets the docker entrypoint to program"
    exit
}
if [[ "$#" -lt 1 || "$#" -gt 4 ]];then
    usage
fi
while [[ ${1:0:1} == "-" ]];do
    case $1 in

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

docker-machine start gnuradio
eval $(docker-machine env gnuradio)
docker run -it --rm $AUDIOARG $X11ARG $X11TMP $PULSECOOKIE $ENTRYPOINT -v $1:/home/gnuradio/ --privileged rkinsey/gnuradio

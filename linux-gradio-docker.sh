#!/bin/bash
VOL=$1
AUDIOARG="-e PULSE_SERVER=host.docker.internal"
X11ARG="-e DISPLAY=host.docker.internal:0"
X11TMP="-v /tmp/.X11-unix:/tmp/.X11-unix"
PULSECOOKIE="-v $HOME/.config/pulse/:/home/gnuradio/.config/pulse/"

function usage {
    echo "Usage: ./linuxrunner.sh [--no-out] [--setup] [--entry <program>] <home volume>"
    echo "       --no-out: run docker without gui or sound"
    echo "       --entry: sets the docker entrypoint to program"
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

#!/bin/bash
VOL=$1
AUDIOARG="-e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native"
X11ARG="-e DISPLAY=unix$DISPLAY"
X11TMP="-v /tmp/.X11-unix:/tmp/.X11-unix"
PULSEVOL="-v ${XDG_RUNTIME_DIR}/pulse/native/:${XDG_RUNTIME_DIR}/pulse/native"
PULSECOOKIE="-v $HOME/.config/pulse/:/home/gnuradio/.config/pulse/ --device /dev/snd"

function usage {
    printf "Usage: \n\t./linuxrunner.sh [--no-out | --gui] <home volume>\n\nOptions\n\t--no-out: run docker without gui or sound\n\t--gui: sets the docker entrypoint to program"
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
                    PULSEVOL=""
                    PULSECOOKIE=""
                    ;;

        --gui)      VOL="$2"
					ENTRYPOINT="--entrypoint=gnuradio-companion"
                    ;;

        *)          usage
                    exit
                    ;;
    esac
    shift
done
DOCKERSTRING="$AUDIOARG $X11ARG $X11TMP $PULSEVOL $PULSECOOKIE $ENTRYPOINT"
docker run -it --rm $DOCKERSTRING -v $1:/home/gnuradio/ --privileged rkinsey/gnuradio

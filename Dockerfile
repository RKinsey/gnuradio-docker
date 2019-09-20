FROM ubuntu:bionic
ENV TZ=US/Eastern

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get -y install apt-utils && \
    apt-get update && apt-get dist-upgrade -yf && apt-get clean && apt-get autoremove

RUN apt-get install -y software-properties-common && \
    apt-add-repository -y ppa:myriadrf/drivers && apt-get update

RUN apt-get install -y git wget curl cmake build-essential python-dev 
    
RUN apt-get install -y gnuradio gqrx-sdr gr-osmosdr gnuradio-dev 

RUN apt-get install -y libboost-all-dev swig limesuite liblimesuite-dev \
    limesuite-udev limesuite-images soapysdr-tools soapysdr-module-lms7 rtl-sdr

RUN git clone https://github.com/myriadrf/gr-limesdr&& cd gr-limesdr && mkdir build &&\
    cd build && cmake .. && make && make install && ldconfig
RUN useradd -ms /bin/bash gnuradio
WORKDIR /home/gnuradio
USER gnuradio
ENV HOME=/home/gnuradio
ENV XDG_RUNTIME_DIR=/home/gnuradio/tmp

ENTRYPOINT ["/bin/bash"]
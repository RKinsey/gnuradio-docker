FROM ubuntu:bionic
ENV TZ=US/Eastern
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get -y install apt-utils && \
apt-get update && apt-get dist-upgrade -yf && apt-get clean && apt-get autoremove
RUN apt-get install -y software-properties-common && \
apt-add-repository -y ppa:myriadrf/drivers && apt-get update
RUN apt-get install -y git subversion wget curl zip unzip cmake build-essential python-dev \
gnuradio gqrx-sdr gr-osmosdr gnuradio-dev libboost-all-dev swig limesuite liblimesuite-dev \
limesuite-udev limesuite-images soapysdr-tools soapysdr-module-lms7
RUN git clone https://github.com/myriadrf/gr-limesdr&& cd gr-limesdr && mkdir build &&\
cd build && cmake .. && make && make install && ldconfig
RUN apt-get install -y sudo 
RUN useradd -ms /bin/bash gnuradio
WORKDIR /home/gnuradio
USER gnuradio
ENV HOME=/home/gnuradio
ENV XDG_RUNTIME_DIR=/home/gnuradio/tmp
ENTRYPOINT ["/bin/bash"]
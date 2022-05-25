ARG YARP_IMAGE

FROM $YARP_IMAGE

ARG ED_VERSION=1.4
ARG BUILD_TYPE=Debug
ARG SOURCE_FOLDER=/usr/local/src

# Event-driven libraries
RUN cd $SOURCE_FOLDER && \
    git clone https://github.com/robotology/event-driven.git &&\
    cd event-driven &&\
    git checkout $ED_VERSION &&\
    mkdir build && cd build &&\
    cmake -DVLIB_DEPRECATED=ON -DCMAKE_BUILD_TYPE=$BUILD_TYPE .. &&\
    make -j `nproc` install
# Fix old Kitware keys
RUN apt-key del 6AF7F09730B3F0A4 \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null \
    && echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ bionic main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null
RUN apt-get update \
    && apt-get install -y \
    libboost-all-dev \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

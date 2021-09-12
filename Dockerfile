FROM ubuntu:20.04
LABEL maintainer="Johannes Blaschke <jpblaschke@lbl.gov>"
# adapted from Rollin Thomas <rcthomas@lbl.gov>
# and Kelly Rowland <kellyrowland@lbl.gov>

# Base Ubuntu packages

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN \
    apt-get update                                                          && \
    apt-get --yes upgrade                                                   && \
    apt-get --yes install                                                      \
        build-essential                                                        \
        gfortran                                                               \
        python3-dev                                                            \
        strace                                                              && \
    apt-get clean all

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 

# Timezone to Berkeley

ENV TZ=America/Los_Angeles
RUN \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  &&  \
    echo $TZ > /etc/timezone


RUN mkdir -p /img/opt
COPY opt /img/opt


#-------------------------------------------------------------------------------
# MPICH
#
# Currently shifter-based MPI functionality is only available for images where
# MPICH is installed manually
#

RUN cd /img/opt                                                             && \
    source_dir=$(find . -maxdepth 1 -name "mpich*" -type d)                 && \
    cd $source_dir                                                          && \
    ./configure                                                             && \
    make -j 4 && make install

#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# MPI4PY
#

RUN cd /img/opt                                                             && \
    source_dir=$(find . -maxdepth 1 -name "mpi4py*" -type d)                && \
    cd $source_dir                                                          && \
    python3 setup.py build                                                  && \
    python3 setup.py install

#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# The /opt/ scripts require source => switch `RUN` to execute bash (instead sh)
SHELL ["/bin/bash", "-c"]


#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# LDCONFIG
#
# We recommend running an /sbin/ldconfig as part of the image build (e.g. in
# the Dockerfile) to update the cache after installing any new libraries in in
# the image build.
#

RUN /sbin/ldconfig

#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# ENTRYPOINT
#

RUN mkdir -p /img
ADD entrypoint.sh /img

WORKDIR /img

RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

#-------------------------------------------------------------------------------

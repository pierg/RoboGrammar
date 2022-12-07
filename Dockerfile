# syntax=docker/dockerfile:1
FROM pmallozzi/devenvs:base-gui

MAINTAINER Matteo Guarrera <matteogu@berkeley.edu>

ENV TZ=US
ENV DEBIAN_FRONTEND noninteractive

# install app dependencies
RUN apt-get update  && \
	apt-get -y install git cmake protobuf-compiler \
	libglew-dev software-properties-common xorg-dev \
	libglu1-mesa-dev doxygen build-essential


RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install -y python3.9 python3.9-dev python3.9-distutils

RUN apt install curl
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3.9 get-pip.py

#ENV PYTHONPATH /RoboGrammar:$PYTHONPATH
#ENV PATH /RoboGrammar:$PATH
# ENV PATH /RoboGrammar/astrometry_net/lib/python/astrometry/util:$PATH


# Installing Python Packages

#RUN pip3 install virtualenv
#RUN apt-get install -y python3-venv
#RUN python3 -m venv venv
#RUN . venv/bin/activate
# RUN pip install -U pip


RUN pip install torch==1.12.0+cpu -f https://download.pytorch.org/whl/torch_stable.html


# ------- install Robogrammar

COPY . /root/host
WORKDIR /root/host

RUN git submodule update --init
RUN mkdir build
WORKDIR /root/host/build
RUN cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo .. \
    -DPYTHON_EXECUTABLE=/usr/bin/python3.9 \
    -DCMAKE_WARN_DEPRECATED=OFF
RUN make -j8

WORKDIR /root/host
RUN pip install -r requirements.txt

RUN mkdir logs_mcts
RUN mkdir logs_random
RUN mkdir output

ENV PYTHONPATH=/root/host/examples/design_search:$PYTHONPATH
ENV PYTHONPATH=/root/host/examples/graph_learning:$PYTHONPATH
ENV PYTHONPATH=/root/host/build/examples/python_bindings:$PYTHONPATH

#RUN /sbin/ldconfig




# ENTRYPOINT echo $(cmake --version)
# RUN source venv/bin/activate
# python3.9 examples/design_search/design_search.py -a mcts -j8 -i5000 -d50 --log_dir logs_mcts FlatTerrainTask data/designs/grammar_apr30.dot



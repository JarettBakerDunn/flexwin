FROM ubuntu:jammy

RUN apt-get update && \
  DEBIAN_FRONTEND='noninteractive' \
  DEBCONF_NONINTERACTIVE_SEEN='true' \
  apt-get install --yes \
    gfortran \
    build-essential \
    git \
    nano \ 
    sudo

RUN useradd \
  --create-home \
  flexwin_user | adduser flexwin_user sudo

RUN echo "flexwin_user:password" | chpasswd 

USER flexwin_user

WORKDIR /home/flexwin_user

RUN git clone 'https://github.com/geodynamics/flexwin.git'; cd flexwin/ttimes_mod; make -f make_gfortran; make -f make_gfortran install;

ENV PATH="/home/flexwin_user/flexwin:${PATH}"

ENV SACHOME="/home/flexwin_user/work/sac"
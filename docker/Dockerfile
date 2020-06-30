FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update -yq &&\
  apt-get install sudo make curl -yq &&\
  apt-get install -y software-properties-common apt-utils python3-setuptools python3-apt python3-pip && \
  # cleanup
  apt-get clean && \
  rm -rf \
      /var/lib/apt/lists/* \
      /tmp/* \
      /var/tmp/*

# Install ansible with pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py &&\
    python3 get-pip.py  &&\
    pip install ansible &&\
    rm -rf get-pip.py


ARG USER=ubuntu
ARG UID=1000
ARG GID=1000
# default password for user
ARG PW=ubuntu

RUN \
      useradd -m ${USER} --uid=${UID} && \
      echo "${USER}:${PW}" | chpasswd && \
      adduser ${USER} sudo && \
      mkdir /home/${USER}/app

COPY ./scripts/00-add-local-bin-to-path.sh /etc/profile.d/
COPY . /home/${USER}/app
RUN chown -R ${USER}: /home/${USER}/

USER ${UID}:${GID}
WORKDIR /home/${USER}/app

## CMD to let container up as deamon
CMD ["tail", "-f", "/var/log/bootstrap.log"]
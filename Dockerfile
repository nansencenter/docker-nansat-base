FROM continuumio/miniconda3

LABEL maintainer="Anton Korosov <anton.korosov@nersc.no>"
LABEL purpose="Python libs for developing and running Nansat"

ARG PYTHON_VERSION=3.7

ENV PYTHONUNBUFFERED=1 \
    PYTHONPATH=/src \
    MOD44WPATH=/usr/share/MOD44W/

RUN apt-get update \
&&  apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
&&  apt clean \
&&  rm -rf /var/lib/apt/lists/*

COPY environment.yml /tmp/environment.yml
RUN sed -i -E "s/^(\s+- python=).*$/\1${PYTHON_VERSION}/" /tmp/environment.yml

RUN conda config --set solver classic \
&&  conda install python="${PYTHON_VERSION}" setuptools \
&&  conda update conda \
&&  conda env update -n base --file /tmp/environment.yml \
&&  rm /tmp/environment.yml \
&&  conda clean -a -y \
&&  rm /opt/conda/pkgs/* -rf \
&&  python -c 'import pythesint; pythesint.update_all_vocabularies()' \
&&  wget -nc -nv -P /usr/share/MOD44W https://github.com/nansencenter/mod44w/raw/master/MOD44W.tgz \
&&  tar -xzf /usr/share/MOD44W/MOD44W.tgz -C /usr/share/MOD44W/ \
&&  rm /usr/share/MOD44W/MOD44W.tgz

WORKDIR /src

FROM continuumio/miniconda3:23.9.0-0

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
    libxau6 \
&&  apt clean \
&&  rm -rf /var/lib/apt/lists/*

COPY environment-${PYTHON_VERSION}.yml /tmp/environment.yml

RUN conda env update -n base --file /tmp/environment.yml --prune \
&&  rm /tmp/environment.yml \
&&  conda clean -a -y -f \
&&  rm /opt/conda/pkgs/* -rf \
&& find /opt/conda/ -follow -type f -name '*.a' -delete \
&& find /opt/conda/ -follow -type f -name '*.pyc' -delete

RUN python -c 'import pythesint; pythesint.update_all_vocabularies()'

RUN wget -nc -nv -P /usr/share/MOD44W https://github.com/nansencenter/mod44w/raw/master/MOD44W.tgz \
&&  tar -xzf /usr/share/MOD44W/MOD44W.tgz -C /usr/share/MOD44W/ \
&&  rm /usr/share/MOD44W/MOD44W.tgz

ENV GDAL_DRIVER_PATH=/opt/conda/lib/gdalplugins
ENV GDAL_DATA=/opt/conda/share/gdal
ENV PROJ_LIB=/opt/conda/share/proj

WORKDIR /src

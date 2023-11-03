FROM continuumio/miniconda3 as standard

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

RUN conda install -n base conda-libmamba-solver \
&&  conda config --set solver libmamba \
&&  conda install python="${PYTHON_VERSION}" setuptools \
&&  conda update conda \
&&  conda env update -n base --file /tmp/environment.yml \
&&  rm /tmp/environment.yml \
&&  conda clean -a -y \
&&  rm /opt/conda/pkgs/* -rf

RUN python -c 'import pythesint; pythesint.update_all_vocabularies()'

RUN wget -nc -nv -P /usr/share/MOD44W https://github.com/nansencenter/mod44w/raw/master/MOD44W.tgz \
&&  tar -xzf /usr/share/MOD44W/MOD44W.tgz -C /usr/share/MOD44W/ \
&&  rm /usr/share/MOD44W/MOD44W.tgz

WORKDIR /src


FROM standard as slim_builder

RUN pip install conda-pack \
&&  conda create --name to_pack --clone base \
&&  conda-pack -n to_pack -o /tmp/env.tar \
&&  mkdir /venv && tar -C /venv -xf /tmp/env.tar \
&&  /venv/bin/conda-unpack

FROM debian:buster as slim

COPY --from=slim_builder /usr/share/MOD44W /usr/share/MOD44W
COPY --from=slim_builder /venv /venv
RUN mkdir -p "/root/.local/share/pythesint"
COPY --from=slim_builder "/root/.local/share/pythesint" "/root/.local/share/pythesint"

ENV VIRTUAL_ENV='/venv'
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/src
ENV MOD44WPATH=/usr/share/MOD44W

WORKDIR /src

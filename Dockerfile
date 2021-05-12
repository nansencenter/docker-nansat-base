FROM continuumio/miniconda3

LABEL maintainer="Anton Korosov <anton.korosov@nersc.no>"
LABEL purpose="Python libs for developing and running Nansat"

ENV PYTHONUNBUFFERED=1 \
    PYTHONPATH=/src \
    MOD44WPATH=/usr/share/MOD44W/

RUN apt-get update \
&&  apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
&&  apt clean \
&&  rm -rf /var/lib/apt/lists/*

RUN conda install setuptools \
&&  conda update conda \
&&  conda config --add channels conda-forge  \
&&  conda install -y \
    cartopy=0.18.0 \
    coverage=5.2.1 \
    coveralls=2.1.2 \
    gdal=3.1.2 \
    ipdb=0.13.3 \
    ipython=7.17.0 \
    matplotlib=3.3.1 \
    mock=4.0.2 \
    netcdf4=1.5.4 \
    nose=1.3.7 \
    numpy=1.19.1 \
    pillow=7.2.0 \
    python-dateutil=2.8.1 \
    scipy=1.5.2 \
    urllib3=1.25.10 \
&&  conda clean -a -y \
&&  rm /opt/conda/pkgs/* -rf \
&&  pip install pythesint==1.5.1 \
&&  python -c 'import pythesint; pythesint.update_all_vocabularies()' \
&&  wget -nc -nv -P /usr/share/MOD44W https://github.com/nansencenter/mod44w/raw/master/MOD44W.tgz \
&&  tar -xzf /usr/share/MOD44W/MOD44W.tgz -C /usr/share/MOD44W/ \
&&  rm /usr/share/MOD44W/MOD44W.tgz

WORKDIR /src

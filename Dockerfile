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
    coverage=5.0.3 \
    coveralls=1.10.0 \
    gdal=2.4.2 \
    ipdb=0.12.3 \
    ipython=7.11.1 \
    matplotlib=3.1.2 \
    mock=3.0.5 \
    netcdf4=1.5.1.2 \
    nose=1.3.7 \
    numpy=1.17.5 \
    pillow=7.0.0 \
    python-dateutil=2.8.1 \
    scipy=1.4.1 \
    urllib3=1.25.7 \
&&  conda remove qt pyqt --force \
&&  conda clean -a -y \
&&  rm /opt/conda/pkgs/* -rf \
&&  pip install pythesint \
&&  python -c 'import pythesint; pythesint.update_all_vocabularies()' \
&&  wget -nc -P /usr/share/MOD44W ftp://ftp.nersc.no/nansat/test_data/MOD44W.tgz \
&&  tar -xzf /usr/share/MOD44W/MOD44W.tgz -C /usr/share/MOD44W/ \
&&  rm /usr/share/MOD44W/MOD44W.tgz

WORKDIR /src

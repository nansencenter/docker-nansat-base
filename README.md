# docker-nansat-base
Docker image containing the dependencies for Nansat

## Usage

This image is meant to be used as a base for building the [nansat](https://hub.docker.com/repository/docker/nansencenter/nansat) docker image, and for working on the [nansat](https://github.com/nansencenter/nansat) source code.

To use it to run `nansat` from source, just mount your `nansat` repository when you run the container, and specify the `PYTHONPATH` variable.

For example, this command enables you to run an interactive `bash` shell inside the container, with `nansat` source code properly configured. Of course, you need to replace `<nansat_path>` with the path to your local `nansat` repository.

```sh
docker run -it --rm -v "<nansat_path>:/src" -e 'PYTHONPATH=/src' nansencenter/nansat_base bash
```

## Build

Upon release, this image is automatically built and pushed to the Docker Hub [nansencenter/nansat_base](https://hub.docker.com/repository/docker/nansencenter/nansat_base) repository.

Release tags should follow [semantic versioning](https://semver.org/).

Two images are built:

- the standard image is based on Anaconda. It makes it easy to maintain and relatively quick to
  build, but very big.

- the slim image does not rely on Anaconda, which makes it necessary to compile GDAL in the
  dockerfile. It is much smaller than the standard image, but takes more time to build
  (around 20 minutes for a first build, much quicker after that if the GDAL stage is not modified).

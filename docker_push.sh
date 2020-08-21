#!/bin/bash
image_name="$1"
shift

for suffix in "$@";do
    for tag in "${TRAVIS_TAG}${suffix}" "latest${suffix}";do
        echo "Tag ${image_name}:${DOCKER_TMP_TAG}${suffix} as ${image_name}:${tag}"
        docker tag "${image_name}:${DOCKER_TMP_TAG}${suffix}" "${image_name}:${tag}"
        echo "Push ${image_name}:${tag}"
        docker push "${image_name}:${tag}"
    done
done

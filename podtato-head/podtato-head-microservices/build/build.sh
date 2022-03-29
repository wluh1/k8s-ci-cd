#!/bin/bash

# set common variables
declare -r this_dir=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
declare -r app_dir=$(cd ${this_dir}/.. && pwd)
declare -r root_dir=$(cd ${this_dir}/../.. && pwd)
if [[ -e ${root_dir}/.env ]]; then 
    echo "INFO: sourcing env vars from .env in repo root"
    source ${root_dir}/.env
fi


# set version/tag for this build
# source ${this_dir}/version.sh
version=${VERSION:-"1.2"}
echo "INFO: will use version/tag: ${version}"

registry=europe-west1-docker.pkg.dev/k8s-ci-cd-1/podtato-head
container_name=${registry}/entry

echo ""
echo "INFO: building container for entry as ${container_name}"
docker build ${app_dir} \
    --tag "${container_name}:latest" \
    --tag "${container_name}:${version}" \
    --file ${app_dir}/cmd/entry/Dockerfile
if [[ -n "${PUSH_TO_REGISTRY}" ]]; then
		docker push "${container_name}:latest"
		docker push "${container_name}:${version}"
fi


parts=($(find ${app_dir}/pkg/assets/images/* -type d -printf '%f\n'))

for part in "${parts[@]}"; do
    container_name=${registry}/${part}

    echo ""
    echo "INFO: building container for ${part} as ${container_name}"
    docker build ${app_dir} \
        --tag "${container_name}:latest" \
        --tag "${container_name}:${version}" \
        --build-arg "PART=${part}" \
        --file ${app_dir}/cmd/parts/Dockerfile

    if [[ -n "${PUSH_TO_REGISTRY}" ]]; then
        docker push "${container_name}:latest"
        docker push "${container_name}:${version}"
    fi
done
### /end build et al parts containers
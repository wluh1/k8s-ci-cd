### podtato-head-microservices

app_dir=./podtato-head-microservices
registry=europe-west1-docker.pkg.dev/k8s-ci-cd-1/podtato-head

build-microservices-images:
	podtato-head-microservices/build/build.sh

push-microservices-images:
	PUSH_TO_REGISTRY=1 podtato-head-microservices/build/build.sh

test-microservices:
	podtato-head-microservices/build/test_services.sh

deploy:
	helm install podtato-head ./chart

uninstall:
	helm uninstall podtato-head

build-one:
	podtato-head-microservices/build/build-one.sh

push-all: push-entry push-body push-hat push-left-arm push-left-leg push-right-arm push-right-leg

push-entry:
	IMAGE_NAME=entry PUSH_TO_REGISTRY=1 podtato-head-microservices/build/build-entry.sh

push-body:
	IMAGE_NAME=body PUSH_TO_REGISTRY=1 podtato-head-microservices/build/build-part.sh
push-hat:
	IMAGE_NAME=hat PUSH_TO_REGISTRY=1 podtato-head-microservices/build/build-part.sh
push-left-arm:
	IMAGE_NAME=left-arm PUSH_TO_REGISTRY=1 podtato-head-microservices/build/build-part.sh
push-left-leg:
	IMAGE_NAME=left-leg PUSH_TO_REGISTRY=1 podtato-head-microservices/build/build-part.sh
push-right-arm:
	IMAGE_NAME=right-arm PUSH_TO_REGISTRY=1 podtato-head-microservices/build/build-part.sh
push-right-leg:
	IMAGE_NAME=right-leg PUSH_TO_REGISTRY=1 podtato-head-microservices/build/build-part.sh

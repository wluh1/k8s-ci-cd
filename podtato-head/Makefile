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

push-entry:
	IMAGE_NAME=entry PUSH_TO_REGISTRY=1 podtato-head-microservices/build/build-entry.sh

push-body:
	IMAGE_NAME=body PUSH_TO_REGISTRY=1 podtato-head-microservices/build/build-part.sh

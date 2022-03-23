### podtato-head-microservices

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
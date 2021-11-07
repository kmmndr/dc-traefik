default: help
include makefiles/*.mk

start: docker-compose-pull docker-compose-start ##- Start
deploy: docker-compose-pull docker-compose-deploy ##- Deploy (start remotely)

set-custom-docker-compose-file:
	$(eval compose_files=-f docker-compose.yml -f docker-compose.custom.yml)
start-custom: set-custom-docker-compose-file docker-compose-build docker-compose-start ##- Build custom image with certificate, and start
deploy-custom: set-custom-docker-compose-file docker-compose-build docker-compose-deploy ##- Build custom image with certificate, and deploy

clean: environment
	$(load_env); docker-compose down -v
	-rm root-ca.crt

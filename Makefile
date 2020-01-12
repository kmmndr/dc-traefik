default: help
include *.mk

start: docker-compose-pull docker-compose-start ##- Start
deploy: docker-compose-pull docker-compose-deploy ##- Deploy (start remotely)

set-custom-docker-compose-file:
	$(eval compose_files=-f docker-compose.yml -f docker-compose.custom.yml)
start-custom: set-custom-docker-compose-file docker-compose-build docker-compose-start ##- Build and start
deploy-custom: set-custom-docker-compose-file docker-compose-build docker-compose-deploy ##- Build and deploy

clean: environment
	$(load_env); docker-compose down -v

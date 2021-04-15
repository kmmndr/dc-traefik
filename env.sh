#!/bin/sh
set -eu

stage=${1:-'default'}

# https://docs.https.dev/list-of-acme-servers
# Let's Encrypt
# - production: https://acme-v02.api.letsencrypt.org/directory
# - test: https://acme-staging-v02.api.letsencrypt.org/directory
#
# ACME_CA_SERVER='https://step-ca.lan:9000/acme/acme/directory'
cat <<EOF
COMPOSE_PROJECT_NAME=traefik
EOF

case "$stage" in
	"default")
		cat <<-EOF
		API_INSECURE=true
		ADMIN_PASSWORD='$(openssl passwd -apr1 "admin")'
		EMAIL=root@localhost
		HOST=localhost
		EOF
		;;

	"production")
		cat <<-EOF
		API_INSECURE=false
		EOF
		;;

	*)
		echo "Unknown stage $stage" >&2
		exit 1
		;;
esac

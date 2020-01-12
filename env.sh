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
HOST=localhost
EMAIL=root@localhost
ADMIN_PASSWORD='$(openssl passwd -apr1 "admin")'
EOF

case "$stage" in
	"default")
		cat <<-EOF
		API_INSECURE=true
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

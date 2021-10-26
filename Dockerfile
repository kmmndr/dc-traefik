FROM traefik:v2.5

COPY root-ca.crt /usr/local/share/ca-certificates/custom-root-ca.crt
RUN update-ca-certificates

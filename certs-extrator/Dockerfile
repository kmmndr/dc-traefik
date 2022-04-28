FROM alpine:3.15

RUN apk add --no-cache ruby ruby-json
COPY certs-extrator.rb /usr/local/bin/certs-extractor
RUN chmod +x /usr/local/bin/certs-extractor

CMD echo "Please specify command yourself :-)"

FROM alpine:3.10
MAINTAINER leo.lou@gov.bc.ca

ARG DVER=0.3.4

WORKDIR /app
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN apk update \
 && apk --no-cache add curl git openssh-client \
 && apk --no-cache add --virtual devs tar \
 && curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://github.com/prest/prest/releases/download/v${DVER}/prest_${DVER}_linux_amd64.tar.gz" \
      | tar --no-same-owner -C /usr/bin/ -xz \
 && chmod 0755 /usr/bin/prest \
 && chmod 0755 /usr/bin/entrypoint.sh

RUN adduser -S app -h /app \
  && chown -R app:0 /app && chmod -R 770 /app \
  && apk del --purge devs  

USER app
EXPOSE 3000
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

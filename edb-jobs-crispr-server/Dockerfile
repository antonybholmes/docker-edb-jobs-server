FROM golang:1.27.4-trixie AS build-stage

# RUN apk update
# RUN apk add -U --no-cache ca-certificates && update-ca-certificates

WORKDIR /

RUN apt-get update && apt-get install -y openssh-client

# so we can use ssh-keyscan to add github.com to known_hosts
# and download without prompting for host key verification
RUN mkdir -p /root/.ssh && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts

# ADD src/go-edbmailserver/ go-edbmailserver/
# ADD src/go-web/ go-web/
# ADD src/go-sys/ go-sys/
# ADD src/go-mailserver/ go-mailserver/

# get the repositories we need
RUN --mount=type=ssh \
git clone git@github.com:antonybholmes/go-edb-jobs-crispr-server.git && \
git clone git@github.com:antonybholmes/go-mail.git && \
git clone git@github.com:antonybholmes/go-jobs.git && \
git clone git@github.com:antonybholmes/go-sys.git

WORKDIR /app

RUN go mod tidy

# build statically so runs without dependencies
RUN CGO_ENABLED=1 GOOS=linux BUILD=production go build --tags "fts5" -o edb-jobs-crispr-server

# move app into smaller alpine image
FROM debian:trixie-slim AS release-stage

WORKDIR /app

# need to copy certs for some reason as go email doesn't work without them
# https://stackoverflow.com/questions/52969195/docker-container-running-golang-http-client-getting-error-certificate-signed-by
COPY --from=build-stage /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=build-stage /app/edb-jobs-crispr-server edb-jobs-crispr-server

# aux files needed by app
COPY --from=build-stage /app/scripts/crispr.py ./scripts/crispr.py
# COPY --from=build-stage /app/consts.env consts.env
COPY --from=build-stage /app/version.json version.json

# COPY .env /

CMD BUILD=production ./edb-jobs-crispr-server

FROM golang:1.12-alpine as builder

# Setup
RUN mkdir -p /go/src/github.com/keycloak/keycloak-gatekeeper
WORKDIR /go/src/github.com/keycloak/keycloak-gatekeeper

RUN apk add --no-cache git

ADD . /go/src/github.com/keycloak/keycloak-gatekeeper/
RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build -a -tags netgo -o /keycloak-gatekeeper github.com/keycloak/keycloak-gatekeeper

FROM alpine:3.7
LABEL Name=keycloak-gatekeeper \
      Release=https://github.com/keycloak/keycloak-gatekeeper \
      Url=https://github.com/keycloak/keycloak-gatekeeper \
      Help=https://github.com/keycloak/keycloak-gatekeeper/issues
RUN apk add --no-cache ca-certificates

ADD templates/ /opt/templates
COPY --from=builder /keycloak-gatekeeper /opt/keycloak-gatekeeper

WORKDIR "/opt"

ENTRYPOINT [ "/opt/keycloak-gatekeeper" ]


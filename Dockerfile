FROM ruby:2.6.4-alpine3.10

RUN apk update && apk add build-base

# Install kubectl
# Note: Latest version may be found on:
# https://aur.archlinux.org/packages/kubectl-bin/
ADD https://storage.googleapis.com/kubernetes-release/release/v1.16.3/bin/linux/amd64/kubectl /usr/local/bin/kubectl

ENV HOME=/config

RUN set -x && \
    apk add --no-cache curl ca-certificates && \
    chmod +x /usr/local/bin/kubectl && \
    \
    # Create non-root user (with a randomly chosen UID/GUI).
    adduser kubectl -Du 2342 -h /config && \
    \
    # Basic check it works.
    kubectl version --client

RUN gem install krane -v 1.1.4

# Clean up
RUN apk del build-base

COPY bin/deploy /bin/deploy
RUN chmod +x /bin/deploy

USER kubectl

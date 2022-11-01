FROM alpine:latest AS builder
WORKDIR /build

#Install curl
RUN apk add --no-cache curl

#Download kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

#Download and unpack Tanzu CLI
COPY tanzu-cli-bundle-linux-amd64.tar.gz /build/tanzu-cli-bundle-linux-amd64.tar.gz
RUN tar -xf tanzu-cli-bundle-linux-amd64.tar.gz
RUN rm tanzu-cli-bundle-linux-amd64.tar.gz
RUN tar -xf ./cli/tanzu-framework-plugins-context-linux-amd64.tar.gz
RUN tar -xf ./cli/tanzu-framework-plugins-standalone-linux-amd64.tar.gz

#-----------------------------------------------#

FROM alpine:latest

#Install various packages 
RUN apk add --no-cache curl openssl nano nmap nmap-ncat ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl1.1 libstdc++ tzdata userspace-rcu zlib icu-libs lttng-ust

#Install kubectl
COPY --from=builder /build/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl && export KUBE_EDITOR="nano"

#Install Tanzu CLI
COPY --from=builder /build/cli/core/v0.25.0/tanzu-core-linux_amd64 /usr/local/bin/tanzu
COPY --from=builder /build/context-plugins /tmp/context-plugins
COPY --from=builder /build/standalone-plugins /tmp/standalone-plugins
WORKDIR /tmp
RUN tanzu plugin install --local context-plugins/ all && tanzu plugin install --local standalone-plugins/ all && rm -rf /tmp/*
WORKDIR /

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python && python3 -m ensurepip && pip3 install --no-cache --upgrade pip setuptools

#Install httpie
RUN python -m pip install httpie
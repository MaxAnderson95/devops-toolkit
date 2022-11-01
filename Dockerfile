FROM alpine:latest

#Install curl
RUN apk add --no-cache curl

#Install openssl
RUN apk add --no-cache openssl

#Install nano
RUN apk add --no-cache nano

#Install nmap
RUN apk add --no-cache nmap

#Install ncat
RUN apk add --no-cache nmap-ncat

#Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
RUN export KUBE_EDITOR="nano"

#Install Tanzu CLI
COPY tanzu-cli-bundle-linux-amd64.tar.gz /tmp/tanzu-cli-bundle-linux-amd64.tar.gz
WORKDIR /tmp
RUN tar -xf tanzu-cli-bundle-linux-amd64.tar.gz
RUN rm tanzu-cli-bundle-linux-amd64.tar.gz
RUN mv cli/core/v0.25.0/tanzu-core-linux_amd64 /usr/local/bin/tanzu
RUN tanzu init
RUN tanzu plugin sync
RUN rm -rf cli

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

#Install httpie
RUN python -m pip install httpie

#Install PowerShell core
RUN apk add --no-cache ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl1.1 libstdc++ tzdata userspace-rcu zlib icu-libs
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache lttng-ust
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.2.7/powershell-7.2.7-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz
RUN mkdir -p /opt/microsoft/powershell/7
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
RUN chmod +x /opt/microsoft/powershell/7/pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
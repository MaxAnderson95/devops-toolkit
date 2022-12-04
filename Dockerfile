FROM alpine:latest

#Install various packages 
RUN apk add --no-cache zsh starship curl openssl nano neovim nmap nmap-ncat ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl1.1 libstdc++ tzdata userspace-rcu zlib icu-libs lttng-ust

#Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN mv kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl && export KUBE_EDITOR="nano"

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python && python3 -m ensurepip && pip3 install --no-cache --upgrade pip setuptools

#Install httpie
RUN python -m pip install httpie

#Initialize starship config
ENV STARSHIP_CONFIG="/root/OneDrive - Georgia United Credit Union/Documents/.starship/starship.toml"
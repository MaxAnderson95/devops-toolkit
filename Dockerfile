FROM alpine:latest

#Install various packages 
RUN apk add --no-cache zsh bash git curl openssl nano neovim nmap nmap-ncat ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl1.1 libstdc++ tzdata userspace-rcu zlib icu-libs lttng-ust fzf docker

#Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN mv kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl && export KUBE_EDITOR="nano"

#Install kubectx and kubens
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx
RUN ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
RUN ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python && python3 -m ensurepip && pip3 install --no-cache --upgrade pip setuptools

#Install httpie
RUN python -m pip install httpie

#Install ArgoCD CLI
RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
RUN chmod 0555 argocd-linux-amd64 && mv argocd-linux-amd64 /usr/local/bin/argocd

#Install Kubeseal
RUN wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.19.2/kubeseal-0.19.2-linux-amd64.tar.gz
RUN tar -xvzf kubeseal-0.19.2-linux-amd64.tar.gz kubeseal
RUN chmod 0755 kubeseal && mv kubeseal /usr/local/bin/kubeseal

#Instal Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh
RUN rm get_helm.sh

#Install Dive
RUN curl -fsSL -o dive.tar.gz https://github.com/wagoodman/dive/releases/download/v0.10.0/dive_0.10.0_linux_amd64.tar.gz
RUN tar -xvzf dive.tar.gz dive
RUN rm dive.tar.gz
RUN chmod 0555 dive && mv dive /usr/local/bin/dive

#Install Terraform
RUN curl -fsSL -o terraform.zip https://releases.hashicorp.com/terraform/1.3.6/terraform_1.3.6_linux_amd64.zip
RUN unzip terraform.zip
RUN chmod +x terraform && mv terraform /usr/local/bin/terraform

#Copy in .zshrc
COPY .zshrc /root

CMD [ "/bin/zsh" ]
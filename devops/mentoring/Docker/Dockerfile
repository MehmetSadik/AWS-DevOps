FROM alpine:3.9.3

# Environment variables for downloading our tooling
ENV KUBECTL_DOWNLOAD=https://storage.googleapis.com/kubernetes-release/release/v1.24.1/bin/linux/amd64/kubectl
ENV TERRAFORM_DOWNLOAD=https://releases.hashicorp.com/terraform/1.5.6/terraform_1.5.6_linux_amd64.zip
ENV TERRAFORM_ARCHIVE=terraform_1.5.6_linux_amd64.zip
ENV IAM_AUTHENTICATOR_DOWNLOAD=https://s3.us-west-2.amazonaws.com/amazon-eks/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator
ENV HELM_DOWNLOAD=https://get.helm.sh/helm-v3.12.1-linux-amd64.tar.gz
ENV HELM_ARCHIVE=helm-v3.12.1-linux-amd64.tar.gz
ENV TZ=Europe/Amsterdam

## LAYER
# entry point script for bootstrapping and setting up credentials from variables
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

## LAYER
# base packages we need
RUN set -x && \
    apk add --update curl ca-certificates git bash openssh python py3-pip jq openssl


## LAYER
# Python stuff, AWS stuff
RUN set -x && \
    pip3 install --upgrade pip
RUN pip3 install --upgrade awscli
RUN curl -o /usr/local/bin/aws-iam-authenticator ${IAM_AUTHENTICATOR_DOWNLOAD}
RUN chmod +x /usr/local/bin/aws-iam-authenticator

## LAYER
# HELM and KUBECTL
RUN set -x && \
    curl -o /usr/local/bin/kubectl ${KUBECTL_DOWNLOAD} && \
    curl -O ${HELM_DOWNLOAD} && \
    tar -xzvf ${HELM_ARCHIVE}  && \
    cp linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    chmod +x /usr/local/bin/kubectl

## LAYER
# TERRAFORM
RUN set -x && \
    curl -O ${TERRAFORM_DOWNLOAD} && \
    unzip ${TERRAFORM_ARCHIVE} -d /usr/local/bin

## Change the default timezone (UTC) to CEST
RUN date

RUN set -x &&\
    apk add tzdata &&\
    cp /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime &&\
    echo "Europe/Amsterdam" >  /etc/timezone

RUN date

ENTRYPOINT ["/entrypoint.sh"]

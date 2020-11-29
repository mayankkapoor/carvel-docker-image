FROM ubuntu

# perl is needed for shasum
RUN apt-get -y update && apt-get install -y wget perl ca-certificates apt-transport-https gnupg curl vim git && update-ca-certificates && rm -rf /var/lib/apt/lists/*

# Install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y

RUN bash -c "set -eo pipefail; wget -O- https://k14s.io/install.sh | bash"

RUN ytt version && kapp version && kbld version && kwt version && imgpkg version && vendir version

# install kubectl to access k8s clusters
RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.18.10/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

RUN kubectl version --client

ENTRYPOINT ["top", "-b"]

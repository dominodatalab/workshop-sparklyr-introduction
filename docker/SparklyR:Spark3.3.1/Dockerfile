FROM quay.io/domino/cluster-environment-images:spark3.3.1-hadoop3.3.2-py3.9-domino5.5

USER root

ENV R_LIBS_SITE=/usr/local/lib/R/site-library
ENV R_VERSION=4.2.3

RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg2 software-properties-common

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'

RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/debian $(lsb_release -sc)-cran40/" && \
    apt-get update
    
RUN apt-get install -y --no-install-recommends dirmngr software-properties-common && \
    apt-get install -y --no-install-recommends r-recommended=${R_VERSION}-* r-base=${R_VERSION}-* r-base-dev=${R_VERSION}-* && \
    apt-mark hold r-* && apt-get clean && rm -rf /var/lib/apt/lists/*
    
RUN apt show r-base

RUN R -q -e "install.packages('remotes')" && \
    R -e "remotes::install_version('sparklyr', version = '1.8.1', dependencies= T)"

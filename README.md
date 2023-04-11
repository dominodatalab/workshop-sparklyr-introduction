# workshop-sparklyr

### Setup instructions

#### Compute environments

This training uses two custom compute environments (CEs). The definition of the CE for the R Studio workspace is as follows:

```
# SparklyR:Spark3.3.1-Workspace
FROM quay.io/domino/compute-environment-images:ubuntu20-py3.9-r4.2-spark3.3.1-hadoop3.3.4-domino5.5

#Install and configure sparklyr

RUN sudo R -e "remotes::install_version('sparklyr', version = '1.8.1', dependencies= T)"

# Disable Hive
RUN sudo bash -c "echo '  sparklyr.connect.enablehivesupport: false' >> /usr/local/lib/R/site-library/sparklyr/conf/config-template.yml"

# Additional packages
RUN sudo R -e "remotes::install_version('dbplot', version = '0.3.3', dependencies= T)"
```

This compute environment also needs the following Pluggable Workspace Tools configuration for running RStudio:

```
rstudio:
  title: "RStudio"
  iconUrl: "/assets/images/workspace-logos/Rstudio.svg"
  start: [ "/opt/domino/workspaces/rstudio/start" ]
  httpProxy:
    port: 8888
    requireSubdomain: false
```

The second CE is used as a Spark Cluster environment. It's definition is:

```
# SparklyR:Spark3.3.1
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
```
For additional information on running on-demand Spark clusters in Domino please see the [Domino documentation](https://docs.dominodatalab.com/en/latest/user_guide/482ec5/on-demand-spark/)

#### Additional configuration

Copy the diabetes.csv dataset to the local dataset for the project (it needs to be visible across the Spark worker nodes)

```
cp /mnt/code/data/diabetes.csv /mnt/data/<project_name>/diabetes.csv
```
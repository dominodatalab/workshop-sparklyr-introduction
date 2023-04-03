FROM quay.io/domino/compute-environment-images:ubuntu20-py3.9-r4.2-spark3.3.1-hadoop3.3.4-domino5.5

RUN sudo R -e "remotes::install_version('sparklyr', version = '1.8.1', dependencies= T)"

# Disable Hive
RUN sudo bash -c "echo '  sparklyr.connect.enablehivesupport: false' >> /usr/local/lib/R/site-library/sparklyr/conf/config-template.yml"
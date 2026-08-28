# Use the same supported MariaDB line as the root Compose configurations.
FROM mariadb:12.3


# Create directory to contain files for initialization of DB structure
# First rename StructureDataSprocsAndFuncs.SVE to S StructureDataSprocsAndFuncs.SQL if tatabase needs to be initialized.
# If file is not renamed, nothing will be copied to folder docker-entrypoints-initdb.d and initialization will not take place
RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./StructureDataSprocsAndFuncs27012020.sql /docker-entrypoint-initdb.d

# Ensure the container exec commands handle range of utf8 characters based of
# default locales in base image (https://github.com/docker-library/docs/blob/135b79cc8093ab02e55debb61fdb079ab2dbce87/ubuntu/README.md#locales)
ENV LANG=C.UTF-8

# OCI annotations to image
LABEL org.opencontainers.image.authors="MariaDB Community" \
      org.opencontainers.image.title="MariaDB Database" \
      org.opencontainers.image.description="MariaDB Database for relational SQL" \
      org.opencontainers.image.documentation="https://hub.docker.com/_/mariadb/" \
      org.opencontainers.image.base.name="docker.io/library/ubuntu:jammy" \
      org.opencontainers.image.licenses="GPL-2.0" \
      org.opencontainers.image.source="https://github.com/MariaDB/mariadb-docker" \
      org.opencontainers.image.vendor="MariaDB Community" \
      org.opencontainers.image.version="10.6" \
      org.opencontainers.image.url="https://github.com/MariaDB/mariadb-docker" 

COPY healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/healthcheck.sh

EXPOSE 3306
CMD ["mariadbd"]

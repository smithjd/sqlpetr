FROM docker.io/postgres:10
LABEL maintainer="M. Edward (Ed) Borasky <znmeb@znmeb.net>"

# Install apt packages
RUN apt-get update \
  && apt-get install -qqy --no-install-recommends \
    postgresql-autodoc \
    unzip \
  && apt-get clean

# download and extract the zip archive
WORKDIR /
ADD http://www.postgresqltutorial.com/wp-content/uploads/2017/10/dvdrental.zip /
RUN unzip /dvdrental.zip

# load the extract script into the "magic pocket"
COPY restoredb.sh /docker-entrypoint-initdb.d/

FROM postgres:alpine
RUN apk update && apk upgrade
WORKDIR /docker-entrypoint-initdb.d
COPY init.sql /docker-entrypoint-initdb.d/1_init.sql
RUN chmod a+r /docker-entrypoint-initdb.d/*
EXPOSE 5432
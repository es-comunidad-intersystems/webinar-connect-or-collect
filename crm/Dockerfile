FROM mariadb:latest

ENV MYSQL_ROOT_PASSWORD=unsecure
ENV MYSQL_DATABASE=crm
ENV MYSQL_USER=crmuser
ENV MYQL_PASSWORD=unsecure

COPY ./init.sql /docker-entrypoint-initdb.d/init.sql
#COPY --chmod=755 ./clientes.csv /docker-entrypoint-initdb.d/clientes.csv
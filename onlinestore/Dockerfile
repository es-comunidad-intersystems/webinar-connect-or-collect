FROM postgres:15

#Environment variables for the Database
ENV POSTGRES_DB=onlinestore
ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=unsecure

#COPY Init SQL Script and CSV into the Container (?)
COPY init.sql /docker-entrypoint-initdb.d/
#COPY ../data/onlinestore/online_retail_2011.csv /docker-entrypoint-initdb.d/

#Exposse PostGreSQL Port
EXPOSE 5432

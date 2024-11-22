# MARIADB for CRM Data

Directory with Dockerfile to build container,
and separate docker-compose.yml to test in isolation from the rest.
## Quick Setup
```
sudo ./test.sh
```

## Build 
```
docker-compose build 
```

## Run
``` 
docker-compose up -d
```

## Test
```
docker exec -it mariadb mariadb -uroot -punsecure crm

select * from clientes
```

# PgClient

Use this client to verify the onlinestore postgres database installation

Connect to onlinestore
```
docker exec -it pgclient /bin/bash
psql -h onlinestore -U admin -d onlinestore

select * from onlineorders limit 10;
```
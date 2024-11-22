
docker-compose down
rm -fr db_data
docker-compose build
docker-compose up -d
sleep 3
docker logs mariadb
#docker exec -it mariadb mariadb -uroot -punsecure crm

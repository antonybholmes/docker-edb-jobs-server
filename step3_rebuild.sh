#mkdir ../data/kafka
#sudo chown 1001:1001 ../data/kafka

#docker-compose down
#docker image rm docker-rust-edb-api-web
#docker-compose up -d

 

set -o allexport
source .env
set +o allexport

docker compose up -d --no-deps --build edb-jobs-server
#docker compose up -d --no-deps --build edb-jobs-crispr-server
 
cd ..
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
make start-dependencies
sleep 15
make install-schema
make install-schema-es
go run cmd/server/*.go --env development-cass --allow-no-auth start
temporal operator namespace create default

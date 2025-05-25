#!/bin/bash

misp_admin_key=misp-key
controlled_domain=misp-host

cerebrate_import() {
        container=$(docker ps | grep cerebrate | cut -d" " -f 1)
        curl --insecure -H "Authorization: $misp_admin_key" -H "Accept: application/json" -o ./organisations.json "https://misp.$controlled_domain/organisations/index.json"
	docker cp organisations.json $container:/tmp
        docker exec $container bin/cake Importer --primary_key name --yes -v src/Command/config/config-misp-format-organisation.json /tmp/organisations.json
}


cerebrate_import

#!/bin/bash
ail_config () {
        echo "Configuring AIL Feeder..."
        container=$(docker ps | grep ail-fram | cut -f1 -d' ')
        docker exec -it $container sed -i 's#/home/pystemon/pystemon/#/opt/pystemon/#g' /opt/AIL/configs/core.cfg
        docker exec -it $container sed -i 's#/home/pystemon/pystemon/#/opt/pystemon/#g' /opt/AIL/bin/packages/config.cfg
        docker cp ../configs/AIL/pystemon.yaml $container:/opt/pystemon/
        docker cp ../configs/AIL/mispKEYS.py ail-framework:/opt/AIL/configs/keys/
        docker restart $container
	echo "Configuration Complete"
}
ail_config

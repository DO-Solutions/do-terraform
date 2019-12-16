#!/bin/bash

function getIPs() {
	consul members | grep -P 'alive.*server' | awk '{print $2}' | awk -F: '{print $1}'
}

echo "Installing Consul on $1\n";

mkdir -p ${consul_configdir}/client ${consul_datadir};

# Install required packages
until [[ $(which unzip) ]] && [[ $(which jq) ]]; do 
	echo "Waiting for unzip and jq packages to be installed."
	sleep 1.5s;
done

# Start install of consul and setup
wget https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip;
unzip consul_${consul_version}_linux_amd64.zip;
mv consul ${consul_binpath}/;

# Create consul user:group
useradd -r ${consul_user};
usermod -a -g bin -G ${consul_user} ${consul_user};

chown ${consul_user}:${consul_user} ${consul_datadir};

# Checking for files based on passed parameter
until [[ -f ${consul_configdir}/client/config.json && -f /etc/systemd/system/consul-client.service ]]; do
	sleep 1.5s;
done

# Start consul as a service
systemctl enable consul-client.service
systemctl start consul-client.service
sleep 5s;
echo "Consul configuration complete."

exit 0

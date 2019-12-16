#!/bin/bash

function getIPs() {
	consul members | grep -P 'alive.*server' | awk '{print $2}' | awk -F: '{print $1}'
}

echo "Installing Consul on $1\n";

mkdir -p ${consul_configdir}/{bootstrap,server} ${consul_datadir};

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
until [[ -f ${consul_configdir}/bootstrap/config.json && -f ${consul_configdir}/server/config.json && -f /etc/systemd/system/consul-server.service ]]; do
	sleep 1.5s;
done
# nohup consul agent -config-file ${consul_configdir}/bootstrap/config.json >/dev/null 2>&1 &
nohup consul agent -config-file ${consul_configdir}/bootstrap/config.json &
sleep 5s;

consul join ${consul_primary};

# Loop over Consul server IP until the listing counts match
until (( $(getIPs | wc -w) == ${droplet_count} )); do
	echo "Server IP addresses available: $(getIPs | wc -w)";
	sleep 3s;
done

# Convert to string and assign to variable
ip_array=$(for i in $(getIPs); do printf '%s' "$i" | jq -R -s .; done | jq -s .);

# Replace place holder "tmp1" in config file
sed -i -e "s/tmp1/$(echo $${ip_array})/" ${consul_configdir}/server/config.json;
pkill -2 consul;
sleep 3s;

# Start consul as a service
if [ $1 == "server" ]; then
  systemctl enable consul-server.service
  systemctl start consul-server.service
else
  systemctl enable consul-client.service
  systemctl start consul-client.service
  sleep 5s;
fi
echo "Consul configuration complete."

exit 0

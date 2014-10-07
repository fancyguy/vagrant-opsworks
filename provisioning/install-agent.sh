#!/usr/bin/env bash

[[ ! -e "/opt/aws/opsworks" ]] || exit 0

OPSWORKS_VERSION=$1
OPSWORKS_AGENT_BUCKET=$2
OPSWORKS_ASSETS_BUCKET=$3

WORKING_DIR=$(mktemp -d 'opsworks-agent.XXXXXXXX')

DEBIAN_FRONTEND=noninteractive apt-get -qq update
DEBIAN_FRONTEND=noninteractive apt-get -qq install curl libxml2-dev libxslt-dev libyaml-dev

mkdir -p /{etc,opt,var/log,var/lib}/aws/opsworks /var/lib/cloud

cat <<EOF > /var/lib/aws/opsworks/client.yml
# opsworks chef client config file
# /var/lib/aws/opsworks/client.yml
---

:local_mode: true
:log_level: :info
:ohai_plugin_path: /opt/aws/opsworks/current/plugins
:cookbook_path: ["/opt/aws/opsworks/current/merged-cookbooks"]
:default_cookbooks_path: /opt/aws/opsworks/current/cookbooks
:site_cookbooks_path: /opt/aws/opsworks/current/site-cookbooks
:merged_cookbooks_path: /opt/aws/opsworks/current/merged-cookbooks
:berkshelf_cookbooks_path: /opt/aws/opsworks/current/berkshelf-cookbooks
:berkshelf_cache_path: /var/lib/aws/opsworks/berkshelf_cache
:file_cache_path: /var/lib/aws/opsworks/cache
:search_nodes_path: /var/lib/aws/opsworks/data/nodes
:data_bag_path: /var/lib/aws/opsworks/data/data_bags
EOF

ssh-keygen -f "${WORKING_DIR}/instance_key_rsa" -t rsa -N ''

cat <<EOF > /var/lib/aws/opsworks/pre_config.yml
# opsworks-agent pre-config file
# /var/lib/aws/opsworks/pre_config.yml
---

:hostname: `hostname`
:identity: `uuidgen`
:agent_installer_base_url: ${OPSWORKS_AGENT_BUCKET}
:agent_installer_tgz: opsworks-agent-installer.tgz
:verbose: false
:instance_service_region: us-east-1
:instance_service_endpoint: localhost
:instance_service_port: '65535'
:instance_public_key: |
`openssl rsa -in /etc/ssh/ssh_host_rsa_key -pubout | sed -e 's/^/  /'`
:instance_private_key: |
`sed -e 's/^/  /' /etc/ssh/ssh_host_rsa_key`
:charlie_public_key: |
  -----BEGIN PUBLIC KEY-----
  MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAni7eKdm34oaCvGiw96Fk
  lyLX+aPfInYzilkk+AY3pXF6nijpQ2cm3ZeM2EoqZFTv3a/meosNBAs3Q3Sy1e4G
  7Ibn/xwMof+iSBvimx3PGKFzNP0BhY9yS6AMEMxtmqksHb0glwmFeJcomdhxZV1F
  ziWTtL6ZEyvCg0I7rxGm1ceQmD25eK90VcZVh4LJtNfnwcZRM4eC+KK9Qllxw5hW
  vB4Z52JMMZbEG9MYCLydWSY9rnVkAyQ0ngJUaJ3q7JsbkBV/J5BcrGgcbioR1k+h
  INRoHwBQU9WnT/x8W+N6vwJb4o6v2hBR1H2GSDLwyZ7wC8EVH+XafWYpU1g/nSEe
  aQIDAQAB
  -----END PUBLIC KEY-----
:wait_between_runs: '60'
EOF

wget -nv "https://${OPSWORKS_AGENT_BUCKET}/${OPSWORKS_VERSION}/opsworks-agent-installer.tgz" -P "${WORKING_DIR}"
tar xzpof "${WORKING_DIR}/opsworks-agent-installer.tgz" -C "${WORKING_DIR}"
${WORKING_DIR}/opsworks-agent-installer/opsworks-agent/bin/installer_wrapper.sh -R ${OPSWORKS_ASSETS_BUCKET}

echo 'export PATH=$PATH:/opt/aws/opsworks/current/bin' > /etc/profile.d/opsworks_path.sh

rm -f /etc/monit.d/opsworks-agent.monitrc /etc/monit/conf.d/opsworks-agent.monitrc

rm -rf ${WORKING_DIR}

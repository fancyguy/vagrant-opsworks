#!/usr/bin/env bash

[[ -e "/opt/aws/opsworks" ]] && exit 0

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

wget -nv "https://${OPSWORKS_AGENT_BUCKET}/${OPSWORKS_VERSION}/opsworks-agent-installer.tgz" -P "${WORKING_DIR}"
tar xzpof "${WORKING_DIR}/opsworks-agent-installer.tgz" -C "${WORKING_DIR}"
${WORKING_DIR}/opsworks-agent-installer/opsworks-agent/bin/installer_wrapper.sh -R ${OPSWORKS_ASSETS_BUCKET}

echo 'export PATH=$PATH:/opt/aws/opsworks/current/bin' > /etc/profile.d/opsworks_path.sh

rm -f /etc/monit.d/opsworks-agent.monitrc /etc/monit/conf.d/opsworks-agent.monitrc

rm -rf ${WORKING_DIR}

#!/usr/bin/env bash

[[ -e "/opt/aws/opsworks" ]] && exit 0

OPSWORKS_VERSION="327"
OPSWORKS_AGENT_BUCKET="opsworks-instance-agent.s3.amazonaws.com"
OPSWORKS_ASSETS_BUCKET="opsworks-instance-assets.s3.amazonaws.com"

WORKING_DIR=$(mktemp -d 'opsworks-agent.XXXXXXXX')

DEBIAN_FRONTEND=noninteractive apt-get -qq update
DEBIAN_FRONTEND=noninteractive apt-get -qq install curl libxml2-dev libxslt-dev libyaml-dev

mkdir -p /{etc,opt,var/log,var/lib}/aws/opsworks /var/lib/cloud

wget -nv "https://${OPSWORKS_AGENT_BUCKET}/${OPSWORKS_VERSION}/opsworks-agent-installer.tgz" -P "${WORKING_DIR}"
tar xzpof "${WORKING_DIR}/opsworks-agent-installer.tgz" -C "${WORKING_DIR}"
${WORKING_DIR}/opsworks-agent-installer/opsworks-agent/bin/installer_wrapper.sh -R ${OPSWORKS_ASSETS_BUCKET}

echo 'export PATH=$PATH:/opt/aws/opsworks/current/bin' > /etc/profile.d/opsworks_path.sh

rm -f /etc/monit.d/opsworks-agent.monitrc /etc/monit/conf.d/opsworks-agent.monitrc

rm -rf ${WORKING_DIR}

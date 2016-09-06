#!/bin/bash

deploy_telegraf_ubuntu() {
  mkdir -p "${BOOTSTRAP_HOME}/sources"
  wget -q -N -P "${BOOTSTRAP_HOME}/sources" https://dl.influxdata.com/telegraf/releases/telegraf_0.13.2_amd64.deb
  dpkg -i "${BOOTSTRAP_HOME}/sources/telegraf_0.13.2_amd64.deb"

  for f in etc/telegraf/telegraf.d/*; do
    expand "etc/telegraf/telegraf.d/$f" "/etc/telegraf/telegraf.d/$f"
  done

  service telegraf restart
}

deploy telegraf
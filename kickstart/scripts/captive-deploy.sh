#!/bin/bash

deploy_captive_ubuntu() {
  local v="`virt-what 2>/dev/null`"
  if [ $? = 0 ] && [ -z "$v" ]; then
    expand etc/dnsmasq-captive.conf /etc/dnsmasq.d/99-captive.conf

    apt-get install --no-install-recommends -y nginx
    expand etc/nginx-captive.conf /etc/nginx/sites-available/captive
    rm -f /etc/nginx/sites-enabled/default
    ln -s -f ../sites-available/captive /etc/nginx/sites-enabled/

    # disable port forwarding
    test -f /etc/networkd-dispatcher/no-carrier.d/disable-port-forwarding && IFACE=$posm_wan_netif /etc/networkd-dispatcher/no-carrier.d/disable-port-forwarding

    # remove hook scripts
    rm -f /etc/networkd-dispatcher/routable.d/enable-port-forwarding
    rm -f /etc/networkd-dispatcher/no-carrier.d/disable-port-forwarding

    service dnsmasq restart
    service nginx restart

    posm_network_bridged=0 expand etc/posm.json /etc/posm.json
  fi
}

deploy captive

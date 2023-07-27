FROM ubuntu:20.04

RUN apt-get -y update && apt-get -yq install \
        strongswan \
        net-tools \
        gettext-base \
        iputils-ping \
        traceroute \
        curl

COPY ipsec.conf /etc/ipsec.conf.template
COPY ipsec.secrets /etc/ipsec.secrets.template
COPY strongswan.conf /etc/strongswan.conf

CMD envsubst < "/etc/ipsec.secrets.template" > "/etc/ipsec.secrets" \
&& envsubst < "/etc/ipsec.conf.template" > "/etc/ipsec.conf" \
&& /usr/sbin/ipsec start --nofork
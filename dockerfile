FROM centos/httpd:latest
ENV container docker

# Copy the dbus.service file from systemd to location with Dockerfile
ADD dbus.service /usr/lib/systemd/system/dbus.service

VOLUME ["/sys/fs/cgroup"]
VOLUME ["/run"]

CMD  ["/usr/lib/systemd/systemd"]

RUN yum -y install centos-release-scl-rh && \
    yum -y install --setopt=tsflags=nodocs mod_ssl
RUN yum -y update; yum clean all
RUN yum -y install --setopt=tsflags=nodocs sssd sssd-dbus adcli krb5-workstation ntp realmd oddjob oddjob-mkhomedir samba-common samba-common-tools nfs-utils; yum clean all

## Systemd cleanup base image
RUN (cd /lib/systemd/system/sysinit.target.wants && for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -vf $i; done) & \
     rm -vf /lib/systemd/system/multi-user.target.wants/* && \
     rm -vf /etc/systemd/system/*.wants/* && \
     rm -vf /lib/systemd/system/local-fs.target.wants/* && \
     rm -vf /lib/systemd/system/sockets.target.wants/*udev* && \
     rm -vf /lib/systemd/system/sockets.target.wants/*initctl* && \
     rm -vf /lib/systemd/system/basic.target.wants/* && \
     rm -vf /lib/systemd/system/anaconda.target.wants/*

# Copy the local SSSD conf file
RUN mkdir -p /etc/sssd
COPY sssd.conf /etc/sssd/sssd.conf

# Copy the local krb files
COPY krb5.keytab /etc/krb5.keytab
COPY krb5.conf /etc/krb5.conf

# Copy the NFSv4 IDmap file
COPY idmapd.conf /etc/idmapd.conf

#Copy the DNS config
COPY resolv.conf /etc/resolv.conf

# Copy rc.local
COPY rc.local /etc/rc.d/rc.local

# start services
ADD configure-nfs.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/configure-nfs.sh
RUN chmod +x /etc/rc.d/rc.local

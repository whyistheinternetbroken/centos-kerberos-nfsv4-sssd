# centos-kerberos-nfsv4-sssd
This image sets up a Docker container that can do Kerberized NFSv4.1 and leverages SSSD for UNIX identity lookups.

THe focus is NetApp ONTAP NFS with Windows Active Directory acting as the KDC/LDAP server, 
but the same concepts can be applied to any NFS server, any LDAP and any KD (with some slight modifications of config files).

Prior to starting, you need:
- Active Directory configured to use LDAP for UNIX identity mapping
- A server/VM running the latest CentOS/RHEL version (our Docker host)
- A NetApp ONTAP cluster with a SVM running NFS on it

The dockerfile copies a set of config files that should be customized for your environment. These include:

- krb5.conf
- krb5.keytab (For LDAP bind; created on the KDC and imported to the Docker host)
- sssd.conf (for LDAP config)
- resolv.conf
- idmapd.conf
- dbus.service
- rc.local (for startup scripts)
- configure-nfs.sh

For complete instructions, see:
https://whyistheinternetbroken.wordpress.com/2018/08/16/securing-nfs-mounts-in-a-docker-container/

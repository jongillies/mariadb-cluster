# MariaDB Cluster

References here:
* https://www.globo.tech/learning-center/install-galera-ubuntu-16/
* https://www.digitalocean.com/community/tutorials/how-to-configure-a-galera-cluster-with-mariadb-10-1-on-ubuntu-16-04-servers

## Step 1 - Bring up the VM's

The following command will:
* Bring up 3 VM's (Ubuntu 16.04)
* Install MariaDB
* Copy the `galera.cnf` file to `/etc/mysql/conf.d`

```bash
vagrant up
```

Takes about 16m2.641s on my box.

Keep in mind that the default listen address for `mysqld` is `127.0.0.1`.  The bootstrap will change the address to `0.0.0.0`.
## Step 2 - Bootstrap the Cluster

Run the following command will bootstrap the cluster.  It should ONLY be run once.

```bash
PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false ANSIBLE_SSH_ARGS='-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s' ansible-playbook --extra-vars "first_node_name=gdb1" --connection=ssh --inventory-file=.vagrant/provisioners/ansible/inventory --sudo  tasks/galera_bootstrap.yml
```

## Step 3 - Check the Cluster Status

```bash
vagrant ssh gdb1 -c "mysql -u root -e \"show status like 'wsrep_cluster_size'\""
```

Should have this output:

```
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| wsrep_cluster_size | 3     |
+--------------------+-------+
```

# Notes

To enable `root` to connect from your local machine you will need to execute this command:


```bash
vagrant ssh gdb1 -c "mysql -u root -e \"update mysql.user set host='%' where user='root' and host='localhost'; flush privileges;\""
```

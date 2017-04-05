# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes_config = YAML.load_file('nodes.yml')

# Assemble the cluster addresses for the galera.cnf
wsrep_cluster_address = nodes_config['mariadb_nodes'].map{ |x| x['ip'] }.join(',')

Vagrant.configure(2) do |config|

  nodes_config['mariadb_nodes'].each do |node|

    config.ssh.username = 'ubuntu'

    config.vbguest.auto_update = true

    config.vm.define node['name'] do |vm_config|

      vm_config.vm.box = node['box']

      vm_config.vm.hostname = node['name']
      vm_config.vm.network :private_network, ip: node['ip']

      vm_config.vm.boot_timeout = 900 # 15 minutes for PXE build

      vm_config.vm.provider :virtualbox do |vb|
        vb.memory = node['ram']
        vb.cpus = node['cpus']
      end

      # Make sure python is installed for Ansible the provisioner
      config.vm.provision 'shell', inline: 'apt-get install -y python-minimal'

      config.vm.provision 'ansible' do |ansible|
        ansible.sudo = true
        ansible.playbook = 'playbook.yml'
        nodes = nodes_config['mariadb_nodes'].map{|x| x['ip'] }
        ansible.extra_vars = { my_name: node['name'],
                               my_ip: node['ip'],
                               cluster_addresses: wsrep_cluster_address,
                               first_node_name: nodes_config['mariadb_nodes'].first['name']
        }
      end

    end

  end

end

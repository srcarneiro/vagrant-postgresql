# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"
 
  config.vm.define "pgsql" do |pgsql|    
	pgsql.vm.network "private_network", ip: "10.10.20.31" 
	
	pgsql.vm.provider :virtualbox do |vbox|
		vbox.name = "vgt-pgsql"
		vbox.memory = "512"
	end	
	
	pgsql.vm.provision "shell",path: "manifests/bootstrap.sh"
	pgsql.vm.provision "puppet" do |puppet|
		puppet.manifest_file = "pgsql.pp"
	end

#	pgsql.vm.provision "shell",path: "manifests/pgsql10.sh"
#	pgsql.vm.provision "shell",inline:"sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl stop sshd && systemctl start sshd"
	
  end  
  
end
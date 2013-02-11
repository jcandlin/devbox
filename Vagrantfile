# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

	config.vm.define :dev-master do |dev-master_config|
		dev-master_config.vm.box = "Precise32"
		dev-master_config.vm.box_url = "http://files.vagrantup.com/precise32.box"
		dev-master_config.vm.host_name = "dev-master"
#		dev-master_config.vm.network :hostonly, "192.168.50.2"
		dev-master_config.vm.provision :puppet, :module_path => "puppet/modules" do |puppet|
			puppet.manifests_path = "puppet/manifests"
			puppet.manifest_file = "site.pp"
		end
	end
	
	config.vm.define :build do |build_config|
		build_config.vm.box = "Precise32"
		build_config.vm.box_url = "http://files.vagrantup.com/precise32.box"
		build_config.vm.host_name = "build"
#		build_config.vm.network :hostonly, "192.168.56.101"
		build_config.vm.provision :puppet, :module_path => "puppet/modules" do |puppet|
			puppet.manifests_path = "puppet/manifests"
			puppet.manifest_file = "site.pp"
		end
	end

	config.vm.define :artefacts do |artefacts_config|
		artefacts_config.vm.box = "Precise32"
		artefacts_config.vm.box_url = "http://files.vagrantup.com/precise32.box"
		artefacts_config.vm.host_name = "artefacts"
#		artefacts_config.vm.network :hostonly, "192.168.50.4"
		artefacts_config.vm.provision :puppet, :module_path => "puppet/modules" do |puppet|
			puppet.manifests_path = "puppet/manifests"
			puppet.manifest_file = "site.pp"
		end
	end
	
		config.vm.define :source do |source_config|
		source_config.vm.box = "Precise32"
		source_config.vm.box_url = "http://files.vagrantup.com/precise32.box"
		source_config.vm.host_name = "source"
#		source_config.vm.network :hostonly, "192.168.50.5"
#		web_config.vm.forward_port 80, 8080
		source_config.vm.provision :puppet, :module_path => "puppet/modules" do |puppet|
			puppet.manifests_path = "puppet/manifests"
			puppet.manifest_file = "site.pp"
		end
	end
	
		config.vm.define :database do |database_config|
		database_config.vm.box = "Precise32"
		database_config.vm.box_url = "http://files.vagrantup.com/precise32.box"
		database_config.vm.host_name = "database"
#		database_config.vm.network :hostonly, "192.168.50.6"
		database_config.vm.provision :puppet, :module_path => "puppet/modules" do |puppet|
			puppet.manifests_path = "puppet/manifests"
			puppet.manifest_file = "site.pp"
		end
	end
	
		config.vm.define :service do |service_config|
		service_config.vm.box = "Precise32"
		service_config.vm.box_url = "http://files.vagrantup.com/precise32.box"
		service_config.vm.host_name = "service"
#		service_config.vm.network :hostonly, "192.168.50.7"
		service_config.vm.provision :puppet, :module_path => "puppet/modules" do |puppet|
			puppet.manifests_path = "puppet/manifests"
			puppet.manifest_file = "site.pp"
		end
	end
	
		config.vm.define :client do |client_config|
		client_config.vm.box = "Precise32"
		client_config.vm.box_url = "http://files.vagrantup.com/precise32.box"
		client_config.vm.host_name = "client"
#		client_config.vm.network :hostonly, "192.168.50.8"
		client_config.vm.provision :puppet, :module_path => "puppet/modules" do |puppet|
			puppet.manifests_path = "puppet/manifests"
			puppet.manifest_file = "site.pp"
		end
	end
	
end

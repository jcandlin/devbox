class vagrant {
	$virtualbox_deps = [ "virtualbox-ose" ]

	package { 
		$virtualbox_deps: 
		ensure => installed
	}
	
	$vagrant_deps = [ "build-essential", "rubygems" ]
	
	package { 
		$vagrant_deps: ensure => installed
	}
	
	exec { 
		"install-rubygems-update":
		command => "gem install rubygems-update",
		unless => "gem -v | grep 1.8",
		require => Package["rubygems"],
	}
	
	exec {
		"run-rubygems-update" :
			command => "/usr/local/bin/update_rubygems",
			unless => "gem -v | grep 1.8",
			require => Exec["install-rubygems-update"],
	}
	
	exec {
		"run-json-update" :
			command => "gem update json",
			require => Exec["run-rubygems-update"],
	}
	
	exec {
		"install-ruby-dependencies" :
			command => "sudo apt-get install libxslt-dev libxml2-dev",
			require => Exec["run-json-update"],
	}
	
	package {
		"vagrant" :
			provider => gem,
			ensure   => installed,
			require  => [Package["build-essential"], Exec["run-rubygems-update"]],
	}
	
	package {
		"veewee" :
			provider => gem,
			ensure   => installed,
			require  => [Package["build-essential"], Exec["run-rubygems-update"]],
	}
	
	file {
		"/var/veewee" :
			source  => "puppet:///modules/vagrant/veewee",
			recurse => true,
			require => Package["veewee"]
	}
	
	file {
		["/var/vagrant"] :
			ensure => directory,
			require => File["/var/veewee"]
	}
	
	file {
		["/var/veewee/iso"] :
			ensure => directory,
			require => File["/var/veewee"]
	}
	
	exec {
		"download-ubuntu-11.10-server-i386-iso" :
			command  => "wget http://releases.ubuntu.com/11.10/ubuntu-11.10-server-i386.iso",
			cwd      => "/var/veewee/iso",
			creates  => "/var/veewee/iso/ubuntu-11.10-server-i386.iso", 
			timeout  => 0,
			require  => File["/var/veewee/iso"]
	}
#	
#	
#	exec {
#		"build-fedora-template" :
#			command  => "vagrant basebox build ubuntu-11.10-server-i386 && vagrant basebox validate ubuntu-11.10-server-i386 && vagrant basebox export ubuntu-11.10-server-i386",
#			cwd      => "/var/veewee",
#			creates  => "/var/veewee/ubuntu-11.10-server-i386.box",
#			timeout  => 0,
#			require  => Exec["download-ubuntu-11.10-server-i386-iso"]
#	}
#	
#	exec {
#		"add-ubuntu-11.10-server-i386-template" :
#			command  => "vagrant box add ubuntu-11.10-server-i386 ubuntu-11.10-server-i386.box",
#			cwd      => "/var/veewee",
#			creates  => "/root/.vagrant.d/boxes/ubuntu-11.10-server-i386",
#			timeout  => 0,
#			require  => Exec["build-fedora-template"]
#	}

	
	define devbox ($nodes) {
		include vagrant 
		$vm_dir = "/var/vagrant/${name}"
		
		file {
			[$vm_dir,"${vm_dir}/data"] :
				ensure => directory,
		} 
		
		file {
			"${vm_dir}/Vagrantfile":
				content  => template("vagrant/Vagrantfile.erb"),
				require  => File[$vm_dir],
		}
		
		file {
			"${vm_dir}/puppet" :
				ensure  => "/etc/puppet",
				require => File[$vm_dir],
		}
	}
}
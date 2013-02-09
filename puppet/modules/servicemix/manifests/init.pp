class servicemix {
	
	package {
		"openjdk-6-jdk":
			ensure => installed,	
	}
	
	user {
		"servicemix" :
			managehome => true,
			ensure     => present,
	}

	exec {
		"servicemix-download" :
			command  => "wget http://10.0.2.2/apache-servicemix-4.4.1-fuse-01-13.tar.gz; 
				 		tar -xf apache-servicemix-4.4.1-fuse-01-13.tar.gz;
				 		rm apache-servicemix-4.4.1-fuse-01-13.tar.gz;
				 		chown -R servicemix:servicemix apache-servicemix-4.4.1-fuse-01-13",
			cwd      => "/opt",
			creates  => "/opt/apache-servicemix-4.4.1-fuse-01-13",
			require  => [User["servicemix"], Package["openjdk-6-jdk"]],
	}
	
	file { 
		"/opt/apache-servicemix" :
			ensure  => "/opt/apache-servicemix-4.4.1-fuse-01-13",
			group   => "servicemix",
			owner   => "servicemix",
			require  => Exec["servicemix-download"],
	}
	
	define server () {
		include servicemix
		
		$instance_folder = "/opt/apache-servicemix/instances/${name}" 
		
		exec {
			"create-servicemix-${name}":
				 command => "su - servicemix -c \"/opt/apache-servicemix/bin/admin create ${name}\"",
				 creates => "${instance_folder}",
				 require => File["/opt/apache-servicemix"],
		}
		
		file {
			"${instance_folder}/etc" :
				source  => "puppet:///modules/servicemix/etc/",
				recurse => true,
				group   => "servicemix",
				owner   => "servicemix",	
				require => Exec["create-servicemix-${name}"]
		}
		
		file {
			"${instance_folder}/${name}-features.xml" :
				source  => "puppet:///modules/servicemix/${name}-features.xml",
				group   => "servicemix",
				owner   => "servicemix",	
				require => Exec["create-servicemix-${name}"]
		}
		
		
		file {
			"/etc/init.d/servicemix-${name}" :
				content => template("servicemix/servicemix.erb"),
				group   => "root",
				owner   => "root",
				mode    => 755,
				require => Exec["create-servicemix-${name}"]
		}
		
		service {
			"servicemix-${name}" :
				enable  => true,
				ensure  => running,
				require => 
					File["${instance_folder}/etc", 
						 "${instance_folder}/${name}-features.xml",
						 "/etc/init.d/servicemix-${name}"] 
		}
	}	
}
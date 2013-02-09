class liferay {
	
	package {
		["openjdk-6-jdk", "unzip"]:
			ensure => installed,	
	}
	
	user {
		"liferay" :
			managehome => true,
			ensure     => present,
	}
		
	exec {
		"liferay-download" :
			command => "wget http://10.0.2.2/liferay-portal-6.0.6.zip; 
				 unzip liferay-portal-6.0.6.zip;
				 rm liferay-portal-6.0.6.zip;
				 chown -R liferay:liferay liferay-portal-6.0.6",
			cwd     =>"/opt",
			creates =>"/opt/liferay-portal-6.0.6",
			require => [User["liferay"], Package["openjdk-6-jdk", "unzip"]],
	}
		
	file { 
		"/opt/liferay" :
			ensure  => "/opt/liferay-portal-6.0.6",
			group   => "liferay",
			owner   => "liferay",
			require => Exec["liferay-download"],
	}
		
	file {
		"/etc/init.d/liferay" :
			source  => "puppet:///modules/liferay/service",
			group   => "root",
			owner   => "root",
			mode    => 755,
			require => File["/opt/liferay"],
	}
	
	service {
		"liferay" :
			enable => true,
			ensure => running,
			require => File["/etc/init.d/liferay"]
	}
	
}
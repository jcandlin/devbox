class artifactory {
	
	package {
		["openjdk-6-jdk", "unzip"]:
			ensure => installed,	
	}
	
	user {
		"artifactory" :
			managehome => true,
			ensure     => present,
	}
	
	exec {
		"download-artifactory" :
			cwd     => "/opt",
			command => "wget -O artifactory-2.4.2.zip http://downloads.sourceforge.net/project/artifactory/artifactory/2.4.2/artifactory-2.4.2.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fartifactory%2Ffiles%2Fartifactory%2F2.4.2%2F&ts=1325444907&use_mirror=netcologne",
			creates => "/opt/artifactory-2.4.2.zip",
			require => Package["openjdk-6-jdk", "unzip"]
	}
	
	exec {
		"unzip-artifactory" :
			cwd     => "/opt",
			command => "unzip artifactory-2.4.2.zip",
			creates => "/opt/artifactory-2.4.2",
			require => Exec["download-artifactory"]
	}
	
	exec {
		"install-artifactory" :
			cwd     => "/opt/artifactory-2.4.2/bin",
			command => "./install.sh",
			creates => "/etc/artifactory/default",
			require => Exec["unzip-artifactory"]
	}
	
	exec {
		"chown-artifactory-installation" :
			cwd     => "/opt/artifactory-2.4.2",
			command => "chown artifactory: -R .",
			require => Exec["unzip-artifactory"]
	}
	
	file {
		"/etc/artifactory/default" :
			source  => "puppet:///modules/artifactory/default",
			owner   => "artifactory",
			group   => "artifactory",
			require => Exec["install-artifactory"]
	}
	
	exec {
		"chown-artifactory-defaults" :
			cwd     => "/etc/artifactory",
			command => "chown artifactory: -R .",
			require => File["/etc/artifactory/default"]
	}
	
	service {
		"artifactory" :
			enable => true,
        	ensure => running,
        	require => Exec["chown-artifactory-defaults", "chown-artifactory-installation"]
	}	
}
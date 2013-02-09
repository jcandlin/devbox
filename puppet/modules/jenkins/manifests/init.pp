class jenkins {

	file {
		"/etc/apt/sources.list.d/jenkins.list" :
			content => "deb http://pkg.jenkins-ci.org/debian binary/\n",
	}
	
	exec {
		"add-jenkins-key" :
			command =>
			"wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -",
			unless => "apt-key list | grep 1024D/D50582E6",
			notify => Exec["jenkins-update"],
	}
	
	exec {
		"jenkins-update" :
			command => "/usr/bin/apt-get update",
			require => File["/etc/apt/sources.list.d/jenkins.list"],
			refreshonly => true,
			notify => Package["jenkins"]
	}
	
	package {
		"jenkins" :
			ensure => latest,
			require => Exec["jenkins-update"]
	}
	
	# centos config
	#	exec {
#		"import-jenkins-key" :
#			command => "rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key",
#			unless => "yum list | grep jenkins"
#	}
#	
#	file {
#		"/etc/yum.repos.d/jenkins.repo" :
#			source => "puppet:///modules/jenkins/jenkins.repo",
#	}
#	
#	package {
#		["java-1.6.0-openjdk", "jenkins"] :
#			require => File["/etc/yum.repos.d/jenkins.repo"]
#	}
#	
#	service {
#		"jenkins" :
#			enable => true,
#	        ensure => running,
#	        require => Package["java-1.6.0-openjdk", "jenkins"],
#	}

}
class admin::webmin {
	
	package {
		"bind9" :
			ensure => installed,
	}
	
	file {
		"/etc/apt/sources.list.d/webmin.list" :
			content => "deb http://download.webmin.com/download/repository sarge contrib\n
		deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib\n",
			notify => Exec["add-webmin-key"],
	}
	exec {
		"add-webmin-key" :
			command =>
			"wget http://www.webmin.com/jcameron-key.asc && apt-key add jcameron-key.asc",
			unless => "apt-key list | grep 1024D/11F63C51",
			notify => Exec["webmin-update"],
	}
	exec {
		"webmin-update" :
			command => "/usr/bin/apt-get update",
			require => File["/etc/apt/sources.list.d/webmin.list"],
			refreshonly => true,
			notify => Package["webmin"]
	}
	package {
		"webmin" :
			ensure => latest,
			require => Exec["webmin-update"]
	}
}

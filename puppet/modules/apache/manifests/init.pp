class apache {
	package {
		"apache2" :
			ensure => installed,
	}
	
	file {
		"/var/www/index.html" :
			source  => "puppet:///modules/apache/index.html",
			require => Package["apache2"]
	}
}
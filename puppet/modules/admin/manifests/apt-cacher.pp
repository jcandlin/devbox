class admin::apt-cacher {
	package {
		"apt-cacher" :
			ensure => latest,
	}
	file {
		"/etc/default/apt-cacher" :
			source => "puppet:///modules/admin/apt-cacher.conf",
	}
	service {
		"apt-cacher" :
			ensure => running,
			require => File["/etc/default/apt-cacher"]
	}
}
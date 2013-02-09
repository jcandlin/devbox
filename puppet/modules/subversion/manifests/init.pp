class subversion {
	
	package {
		["apache2", "subversion", "libapache2-svn"] :
			ensure => installed,
	}
	
	file {
		"/etc/apache2/conf.d/subversion.conf" :
			source => "puppet:///modules/subversion/subversion.conf",
			require => Package["apache2", "subversion", "libapache2-svn"],
	}
	
	exec {
		"create-admin-account" :
			command => "htpasswd -bcm /etc/svn-auth-conf vagrant vagrant",
			unless => "test -e /etc/svn-auth-conf && echo \"password file exists\"",
	}
	
	file {
		"/var/www/" :
			ensure => directory,
			owner  => svn,
	}
	
	file {
		"/var/www/svn" :
			ensure => directory,
			owner  => svn,
	}
	
	service {
		"apache2" :
			enable => true,
	        ensure => running,
	        require => Package["apache2", "subversion", "libapache2-svn"],
	}
	
	
	define repo () {
		include subversion
		
		exec {
			"create-${name}-repo":
				command => "svnadmin create /var/www/svn/${name}",
				unless  => "test -e /var/www/svn/${name} && echo \"repository exists\"",
				require => Package["apache2", "subversion", "libapache2-svn"],
		}
		
		exec {
			"chown-${name}-repo": 
				command => "chown svn: -R /var/www/svn/${name}",
				require => Exec["create-${name}-repo"]
		}
	}
	
	
	define user ($password) {
		include subversion
		
		exec {
			"create-${name}-account" :
				command => "htpasswd -bm /etc/svn-auth-conf ${name} ${password}",
				unless => "cat /etc/svn-auth-conf | grep ${name}",
		}
	}
	
}
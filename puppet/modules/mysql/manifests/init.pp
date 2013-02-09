class mysql::server($bind_address = "127.0.0.1", $root_password) {
    package { 
    	"mysql-server" : 
    		ensure => installed 
    }
    
    file {
    	"/etc/mysql/my.cnf" :
    		content  => template("mysql/my.cnf.erb"),
			require  => Package["mysql-server"],			
    }
    
    service { 
    	"mysql" :
	        enable  => true,
	        ensure  => running,
	        require => File["/etc/mysql/my.cnf"],
    }
 
    exec { 
    	"set-mysql-password" :
	        unless => "mysqladmin -uroot -p${root_password} status",
	        command => "mysqladmin -uroot password ${root_password}",
	        require => Service["mysql"],
    }

    define db( $user, $password) {

        exec { "create-${name}-db":
            unless    => "mysql -u${user} -p${password} ${name}",
            command   => "mysql -uroot -psecret -e \"create database ${name}; grant all on ${name}.* to ${user}@localhost identified by '${password}'; grant all on ${name}.* to ${user}@'%' identified by '${password}'; flush privileges;\"",
            require   => Exec["set-mysql-password"],
            logoutput => on_failure,
        }
    }
}
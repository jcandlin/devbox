class servicemix::host {
	include apache
		
	exec {
		"servicemix-download" :
			command  => "wget http://repo.fusesource.com/nexus/content/repositories/releases/org/apache/servicemix/apache-servicemix/4.4.1-fuse-01-13/apache-servicemix-4.4.1-fuse-01-13.tar.gz;",
			cwd      => "/var/www",
			creates  => "/var/www/apache-servicemix-4.4.1-fuse-01-13.tar.gz",
			require  => Package["apache2"]
	}
}

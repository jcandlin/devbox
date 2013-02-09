class liferay::host {
	include apache
		
	exec {
		"liferay-download" :
			command  => "wget -O liferay-portal-6.0.6.zip 'http://freefr.dl.sourceforge.net/project/lportal/Liferay Portal/6.0.6/liferay-portal-tomcat-6.0.6-20110225.zip';",
			cwd      => "/var/www",
			creates  => "/var/www/liferay-portal-6.0.6.zip",
			require  => Package["apache2"]
	}
}

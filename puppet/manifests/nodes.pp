# host' nodes  ################################################################
node 'master' {

	include servicemix::host
	include liferay::host
	include admin::webmin
	include vagrant
	
	vagrant::devbox {
		"devbox" :
			nodes => {
  				# example build cluster
  				build     => { 'hostname' => 'build.local',       'network' => '192.168.56.101' },
  				artefacts => { 'hostname' => 'artefacts.local',   'network' => '192.168.56.102' },
  				source    => { 'hostname' => 'source.local',      'network' => '192.168.56.103' },
  				
  				# example application
  				database  => { 'hostname' => 'database.local',    'network' => '192.168.56.111' },
  				service   => { 'hostname' => 'service.local',     'network' => '192.168.56.112' },
  				client    => { 'hostname' => 'client.local',     'network' => '192.168.56.113' },
			}
	}
	
}

# ci nodes ####################################################################
node 'build' inherits 'vm' {
	include jenkins
}

node 'artefacts' inherits 'vm' {
	include artifactory
}

node 'source' inherits 'vm' {
	subversion::repo { "demo" :	}
	subversion::user { "jcandlin" :	password => "password", }
}

# demo environment nodes ######################################################
node 'database' inherits 'vm' {
	class { 
		"mysql::server" :
			bind_address  => "192.168.1.111",
			root_password => "secret"
	}

	mysql::server::db { "demo" : user => "user", password => "password", }
}

node 'service' inherits 'vm' {
	servicemix::server {"demo" : }
}

node 'client' inherits 'vm' {
	include liferay
}

# abstract nodes ##############################################################
node 'vm' {
	
	group { "puppet" : ensure => present }
	
	# displays 'Puppet power!' as the welcome message
	file { "/etc/motd" : content => "Puppet power!\n",}
}

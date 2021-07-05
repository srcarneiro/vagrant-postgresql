exec {"change-hostname":
		command => "/usr/bin/hostnamectl set-hostname pgsql.intra.local --static"}


		
exec {"apt-add-key":
		command => "/usr/bin/wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -"
}

exec {"add-repo":
		command => "/usr/bin/add-apt-repository 'deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main'",
		require => Exec['apt-add-key']}		
		
exec {"apt-update":
		command => "/usr/bin/apt-get update",
		require => Exec['add-repo']}
		
/*		
exec {"apt-install-pgsql":
		command => "/usr/bin/apt-get install postgresql-10 -y",
		require => Exec['apt-update']}
		
package {["postgresql-10","llvm5.0","llvm-5.0-tools","gcc","postgresql-contrib-10","postgresql-server-dev-10","libssl-dev","libkrb5-dev"]:
		ensure => installed,
		require => Exec["apt-update"]}		
*/
		
package {["postgresql-10","postgresql-10-pgaudit"]:
		ensure => installed,
		require => Exec["apt-update"]}
		
service {"postgresql":
		ensure => running,
		enable => true,
		hasstatus => true,
		hasrestart => true,
		require => Package["postgresql-10"]}
		
		
file {"/etc/postgresql/10/main/pg_hba.conf":
		source => "/vagrant/confs/pg_hba.conf",
		owner => postgres,
		group => postgres,
		mode => 0640,
		require => Package["postgresql-10"],
		notify => Service["postgresql"]}
		
file {"/etc/postgresql/10/main/postgresql.conf":
		source => "/vagrant/confs/postgresql.conf",
		owner => postgres,
		group => postgres,
		mode => 0644,
		require => Package["postgresql-10"],
		notify => Service["postgresql"]}	

exec {"postgres-user-pwd":
		path => "/usr/bin/",
		command => "psql -f /vagrant/sql/01.postgres.alter.sql",
		user => postgres,
		require => File['/etc/postgresql/10/main/postgresql.conf']}		

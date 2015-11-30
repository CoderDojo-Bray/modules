# This file is part of the puppet infrastructure to install Jabberd2 on a Raspberry Pi using Puppet
#
# Copyright (c) 2015 Liam Friel for CoderDojo Bray
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
# and associated documentation files (the "Software"), to deal in the Software without restriction, 
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
# THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS 
# OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Liam Friel
# CoderDojo Bray
#

class jabber::install {

    # Some definitions
    include jabber::params

    # Configure the Postgres database for Jabberd2 use
    # Create the database and user
    postgresql::server::db { 'jabberd2':
        user     => 'jabberd2',
        password => postgresql_password('jabberd2', 'jabberd2'),
    }
    
    # Trust this user (means we can execute PSQL commands for that user)
    postgresql::server::pg_hba_rule { 'allow the jabber user to access the database from localhost (TCP/IP)':
      description => "Open up postgresql for access by the jabberd2 user from this node",
      type => 'host',
      database => 'jabberd2',
      user => 'jabberd2',
      address => 'samehost',
      auth_method => 'trust',
      order => '000',
    }
   
    postgresql::server::pg_hba_rule { 'allow the jabber user to access the database from localhost (unix socket)':
      description => "Open up postgresql for access by the jabberd2 user from this node",
      type => 'local',
      database => 'jabberd2',
      user => 'jabberd2',
      auth_method => 'trust',
      order => '000',
    }
   
    # Populate some shorthands to variables we want to use in templates
    # Makes the templates shorter
    
    $routerServer = $jabber::params::routerServer  
    $routerPassword = $jabber::params::routerPassword   
    $routerUser = $jabber::params::routerUser
    $routerPort = $jabber::params::routerPort
    $masterWANIP  = generate('/etc/puppet/scripts/wanip.sh')
    $routerPEMFile = "${jabber::params::jabber_config_dir}/${jabber::params::jabber_cert_name}"

    # This very simple example is your "starter" install module
    # It sets up the "dojo" standard configuration on our remote server, and starts up the jabber components
    
    # First, pickup the standard client jabber configuration file. This defines what we will start ... 
    file { "${jabber::params::jabber_config_dir}/jabberd.cfg":
           ensure => present,
           owner  => 'root',
           group  => 'jabber',
           mode   => '0640',
           source => "puppet:///modules/jabber/jabberd-client-conf.cfg"
    }

    ->
    
    # Make sure the certificate is copied to the client
    file { "${jabber::params::jabber_config_dir}/${jabber::params::jabber_cert_name}":
           ensure => present,
           owner  => 'root',
           group  => 'jabber',
           mode   => '0640',
           source => "puppet:///files/${jabber_cert_name}"
    }    
    
    ->
    
    # Configure the c2s.xml file
    file { "${jabber::params::jabber_config_dir}/c2s.xml":
           ensure => file,
           owner  => 'root',
           group  => 'jabber',
           mode   => '0640',
           content => template('jabber/c2s.client.xml.erb')
    }

    ->
    
    # Execute the PSQL setup script to setup Postgres on the client for Jabber use
    # We only want to do this once, so we drop a "breadcrumb" onto the file system
    exec { "Configure the PostgreSQL database":
        user    => $jabber::params::user,
        cwd     => "${jabber::params::src_dir}/${jabber::params::jabber_vers}/tools",
        timeout => $jabber::params::timeout,
        path    => $jabber::params::path,
        command => "psql -U jabberd2 -d jabberd2 -a -f db-setup.pgsql",
        unless  => "/usr/bin/test -f ${jabber::params::pg_config_dir}/.puppet_jabber_db_setup",
        before  => File["${jabber::params::pg_config_dir}/.puppet_jabber_db_setup"],

    }
    
    # Trap door to only allow database setup once
    file { "${jabber::params::pg_config_dir}/.puppet_jabber_db_setup":
      ensure  => present,
      content => "dummy file",
    }
        
}

# Class to install jabber2 on an RPi
# This has to be built from source ... 
#
# Liam Friel
# CoderDojo Bray
#

class jabber::setup {

    # Some definitions
    include jabber::params

    # Create the jabber group and user
    group { "${jabber::params::jabber_group}":
            ensure => present,
            gid    => 2000
    }
    user { "${jabber::params::jabber_user}":
           ensure => present,
           gid    => "${jabber::params::jabber_group}",
           membership => minimum,
           shell      => "/bin/bash",
           require    => Group["${jabber::params::jabber_group}"]
    }
    
    # Create directories for the PID and logs and set them to be owned by Jabber
    file { $jabber::params::jabber_pid_dir:
           ensure  => "directory",
           owner   => "jabber",
           group   => "jabber",
           mode    => 750,
           require => User["${jabber::params::jabber_user}"]
    }
   
    file { $jabber::params::jabber_log_dir:
           ensure  => "directory",
           owner   => "jabber",
           group   => "jabber",
           mode    => 750,
           require => User["${jabber::params::jabber_user}"]
    }
    
    # Create the source directory
    file { "${jabber::params::src_dir}":
            ensure => "directory",
            mode => 777
    }    
    
    
}
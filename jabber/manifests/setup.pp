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
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

    # Populate some shorthands to variables we want to use in templates
    $routerPassword = $jabber::params::routerPassword   
    $routerUser = $jabber::params::routerUser
    $routerPort = $jabber::params::routerPort
    $routerServer = $jabber::params::routerServer

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
    
    # Configure the c2s1.xml file (test)
    file { "${jabber::params::jabber_config_dir}/c2s1.xml":
           ensure => file,
           owner  => 'root',
           group  => 'jabber',
           mode   => '0640',
           content => template('jabber/c2s.client.xml.erb')
    }

        
}

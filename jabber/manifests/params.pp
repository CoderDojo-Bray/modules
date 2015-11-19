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

class jabber::params {

    # Some definitions
    $src_dir = "/usr/src/jabber"
    $jabber_group = "jabber"
    $jabber_user = "jabber"
    $jabber_vers = "jabberd-2.3.2"
    $jabber_archive = "${jabber_vers}.tar.gz"
    
    # Postgres config utilities
    $pg_config_util = "pg_config.libpq-dev"
    $pg_config_dir  = "/usr/lib/postgresql/9.1/bin"

    # Jabber component installation directory, PID directory and log directory
    $jabber_comp_inst = "/usr/local/lib/systemd/system"
    $jabber_pid_dir   = ["/usr/local/var/","/usr/local/var/jabberd/","/usr/local/var/jabberd/pid"]
    $jabber_log_dir   = "/var/log/jabber"
    
    # Jabber configuration directory
    $jabber_config_dir = "/usr/local/etc/"
    
    # Some generic parameters
    $user    = "root"
    $path    = "/usr/bin:/bin:/usr/sbin:/sbin"
    $timeout = 0
    $options = ''   

    # Some client configuration parameters
    $routerServer = "dojobox-core.dyndns-server.com"
    $routerPort = 5347   
    $routerUser = "dojojab"
    $routerPassword = "f45g6y*i"    
    
}

# Class to install jabber2 on an RPi
#
# Parameters of the Jabber class
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
    
}
# Class to install jabber2 on an RPi
# This has to be built from source ... 
#
# Liam Friel
# CoderDojo Bray
#

class jabber() {

    # Some definitions
    $src_dir = "/usr/src/jabber"
    $jabber_vers = "jabberd-2.3.2"
    $jabber_archive = "${jabber_vers}.tar.gz"
    
    # Postgres config utilities
    $pg_config_util = "pg_config.libpq-dev"
    $pg_config_dir  = "/usr/lib/postgresql/9.1/bin"

    # Jabber component installation directory
    $jabber_comp_inst = "/usr/local/lib/systemd/system"
    
    $user    = "root"
    $path    = "/usr/bin:/bin:/usr/sbin:/sbin"
    $timeout = 0
    $options = ''

    file { "${src_dir}":
            ensure => "directory",
            mode => 777
    }
    
    ->
    
    # Fetch the jabber source archive  
    wget::fetch { "Fetch Jabber source archive to ${src_dir}/${jabber_archive}":
                   source => "https://github.com/jabberd2/jabberd2/releases/download/jabberd-2.3.2/${jabber_archive}",
                   destination => "${src_dir}/${jabber_archive}",
                   verbose => true
    }
    
    ->
    
    # Unpack the archives 
   
    exec { "unpack jabber archive to ${src_dir}/${jabber_vers}":
        user    => $user,
        cwd     => $src_dir,
        timeout => $timeout,
        path    => $path,
        command => "tar xvfz ${jabber_archive}",
        creates => "${src_dir}/${jabber_vers}/configure"
    }
    
    # From our current PostgreSQL setup, the pg_config utility is not in the location
    # expected by the configure script: so copy it
    
    ->
    
    exec { "copy pg_config utility":
        user    => $user,
        cwd     => "/usr/bin",
        timeout => $timeout,
        path    => $path,
        command => "cp ${pg_config_util} ${pg_config_dir}/pg_config",
        creates => "${pg_config_dir}/pg_config"
        
    }
    
    # Run the configure command (which generates the Makefile)
    
    ->
    
    exec { "configure jabber before building":
        user    => $user,
        cwd     => "${src_dir}/${jabber_vers}",
        timeout => $timeout,
        path    => $path,
        command => "${src_dir}/${jabber_vers}/configure --enable-pgsql=/usr/bin/pg_config --enable-ssl=/usr/bin/openssl --enable-idn",
        creates => "${src_dir}/${jabber_vers}/Makefile"
    }    

    # Now build the jabber components and install it
    
    ->
    
    exec { "build the jabber components":
        user    => $user,
        cwd     => "${src_dir}/${jabber_vers}",
        timeout => $timeout,
        path    => $path,
        command => "make",
        creates => "${src_dir}/${jabber_vers}/c2s"
    }
    
    ->
    
    exec { "install the jabber components":
        user    => $user,
        cwd     => "${src_dir}/${jabber_vers}",
        timeout => $timeout,
        path    => $path,
        command => "make install",
        creates => "${jabber_comp_inst}/jabberd.service"
    }
    
    
}
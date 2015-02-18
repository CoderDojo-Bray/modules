# Class to install jabber2 on an RPi
# This has to be built from source ... 
#
# Liam Friel
# CoderDojo Bray
#

class jabber::build {

    # Some definitions
    include jabber::params
   
    # Fetch the jabber source archive  
    wget::fetch { "Fetch Jabber source archive to ${jabber::params::src_dir}/${jabber::params::jabber_archive}":
                   source => "https://github.com/jabberd2/jabberd2/releases/download/jabberd-2.3.2/${jabber::params::jabber_archive}",
                   destination => "${jabber::params::src_dir}/${jabber::params::jabber_archive}",
                   verbose => true
    }
    
    ->
    
    # Unpack the archives 
   
    exec { "unpack jabber archive to ${jabber::params::src_dir}/${jabber::params::jabber_vers}":
        user    => $jabber::params::user,
        cwd     => $jabber::params::src_dir,
        timeout => $jabber::params::timeout,
        path    => $jabber::params::path,
        command => "tar xvfz ${jabber::params::jabber_archive}",
        creates => "${jabber::params::src_dir}/${jabber::params::jabber_vers}/configure"
    }
    
    # From our current PostgreSQL setup, the pg_config utility is not in the location
    # expected by the configure script: so copy it
    
    ->
    
    exec { "copy pg_config utility":
        user    => $jabber::params::user,
        cwd     => "/usr/bin",
        timeout => $jabber::params::timeout,
        path    => $jabber::params::path,
        command => "cp ${jabber::params::pg_config_util} ${jabber::params::pg_config_dir}/pg_config",
        creates => "${jabber::params::pg_config_dir}/pg_config"
        
    }
    
    # Run the configure command (which generates the Makefile)
    
    ->
    
    exec { "configure jabber before building":
        user    => $jabber::params::user,
        cwd     => "${jabber::params::src_dir}/${jabber::params::jabber_vers}",
        timeout => $jabber::params::timeout,
        path    => $jabber::params::path,
        command => "${jabber::params::src_dir}/${jabber::params::jabber_vers}/configure --enable-pgsql=/usr/bin/pg_config --enable-ssl=/usr/bin/openssl --enable-idn",
        creates => "${jabber::params::src_dir}/${jabber::params::jabber_vers}/Makefile"
    }    

    # Now build the jabber components and install it
    
    ->
    
    exec { "build the jabber components":
        user    => $jabber::params::user,
        cwd     => "${jabber::params::src_dir}/${jabber::params::jabber_vers}",
        timeout => $jabber::params::timeout,
        path    => $jabber::params::path,
        command => "make",
        creates => "${jabber::params::src_dir}/${jabber::params::jabber_vers}/c2s"
    }
    
    ->
    
    exec { "install the jabber components":
        user    => $jabber::params::user,
        cwd     => "${jabber::params::src_dir}/${jabber::params::jabber_vers}",
        timeout => $jabber::params::timeout,
        path    => $jabber::params::path,
        command => "make install",
        creates => "${jabber::params::jabber_comp_inst}/jabberd.service"
    }
    
    ->
    
    exec { "set ownership of the configuration files":
        user    => $jabber::params::user,
        cwd     => "${jabber::params::jabber_config_dir}",
        timeout => $jabber::params::timeout,
        path    => $jabber::params::path,
        command => "chown -R root:${jabber::params::jabber_user} ${jabber::params::jabber_config_dir}"
    }
    
    ->
    
    exec { "set permissions of the configuration files":
        user    => $jabber::params::user,
        cwd     => "${jabber::params::jabber_config_dir}",
        timeout => $jabber::params::timeout,
        path    => $jabber::params::path,
        command => "chmod -R 640 ${jabber::params::jabber_config_dir}"
    }
    
    
    
}
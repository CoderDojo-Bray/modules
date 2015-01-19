# Class to install udns on an RPi
# This has to be built from source ... 
#
# Liam Friel
# CoderDojo Bray
#

class udns {

    # Some definitions
    $udns_archive = "udns_0.4.orig.tar.gz"
    $udns_deb_archive = "udns_0.4-1.debian.tar.gz"
    $work_dir = "/usr/src/udns"
    $udns_dir = "udns-0.4"
    $udns_script = "configure" 
    $deb_test = "debian/compat"
    $udns_pkgs = "libudns0_0.4-1_armhf.deb libudns-dev_0.4-1_armhf.deb"
    
    $user    = "root"
    $path    = "/usr/bin:/bin:/usr/sbin:/sbin"
    $timeout = 0
    $options = ''
    
    # First install the build pre-reqs
    package{ 'devscripts':
              ensure => installed,
    }
    
    package{ 'fakeroot':
              ensure => installed,
    }
    
    package{ 'lintian':
              ensure => installed,
    }
    
    package{ 'patch':
              ensure => installed,
    }
       
    # Prepare the build folder
    file { "${work_dir}":
            ensure => "directory",
            mode => 777
    }
    ->
    # Fetch the udns source archives required   
    wget::fetch { "Fetch UDNS source archive to ${work_dir}/${udns_archive}":
                   source => "http://ftp.de.debian.org/debian/pool/main/u/udns/${udns_archive}",
                   destination => "${work_dir}/${udns_archive}",
                   verbose => true
    }
    ->
    # Unpack the first archive
    exec { "unpack UDNS archive":
        user    => $user,
        cwd     => $work_dir,
        timeout => $timeout,
        path    => $path,
        command => "tar xvfz ${udns_archive}",
        creates => "${work_dir}/${udns_dir}/${udns_script}",
    }
    ->
    # Fetch the second archive into the unpacked directory
    wget::fetch { "Fetch UDNS debian archive ${work_dir}/${udns_dir}/${udns_deb_archive}":
                   source => "http://ftp.de.debian.org/debian/pool/main/u/udns/${udns_deb_archive}",
                   destination => "${work_dir}/${udns_dir}/${udns_deb_archive}",
                   verbose => true
    }
    ->  
    exec { "unpack UDNS debian archive":
        user    => $user,
        cwd     => "${work_dir}/${udns_dir}",
        timeout => $timeout,
        path    => $path,
        command => "tar xvfz ${udns_deb_archive}",
        creates => "${work_dir}/${udns_dir}/${deb_test}",
    }
    ->
    # build the udns packages
    exec { "build the UDNS components":
        user    => $user,
        cwd     => "${work_dir}/${udns_dir}",
        timeout => $timeout,
        path    => $path,
        command => "dpkg-buildpackage -rfakeroot -b -uc",
        creates => "${work_dir}/libudns0_0.4-1_armhf.deb"
    }
    ->       
    # install the udns packages (unless they are already there)
    exec { "install the UDNS components":
        user    => $user,
        cwd     => "${work_dir}",
        timeout => $timeout,
        path    => $path,
        command => "dpkg -i ${udns_pkgs}",
        unless => "dpkg -l | grep -c libudns0"
    }
    
    
}
# Very simple module to install some gnusasl prerequisites for jabber
#
# Liam Friel
# CoderDojo Bray

class gnusasl {

    package { 'libgsasl7':
               ensure => installed,
    }

    package { 'libgsasl7-dev':
               ensure => installed,
    }
    
    package { 'libidn11':
               ensure => installed,
    }
    
    package { 'libidn11-dev':
               ensure => installed,
    }
       
}

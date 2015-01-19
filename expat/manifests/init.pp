# Very simple module to install some expat prerequisites for jabber
#
# Liam Friel
# CoderDojo Bray

class expat {

    package { 'expat':
               ensure => installed,
    }

    package { 'libexpat1-dev':
               ensure => installed,
    }

}

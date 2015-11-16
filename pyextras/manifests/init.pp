# Very simple module to install some extra python modules that we need
# Not necessarily sure this is the most puppet-appropriate way to do this either
# But time is against us ... so not much research here ... 
#
# Liam Friel
# CoderDojo Bray

class pyextras {

    include jabber::params

    $pytools = ['python-pip', 'python-setuptools']

    package { $pytools:
               ensure => installed,
    }
    
    ->
    
    exec { "install python xmpp library":
        timeout => $jabber::params::timeout,
        user    => $jabber::params::user,
        path    => $jabber::params::path,
        command => "pip install sleekxmpp"
    }    
       
}

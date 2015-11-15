# Very simple module to install some extra python modules that we need
# Not necessarily sure this is the most puppet-appropriate way to do this either
# But time is against us ... so not much research here ... 
#
# Liam Friel
# CoderDojo Bray

class pyextras {

    package { 'pip':
               ensure => installed,
    }
    
    ->
    
    exec { "xmpp":
        timeout => $jabber::params::timeout,
        command => "pip install sleekxmpp"
    }    
       
}

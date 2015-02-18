# Class to install jabber2 on an RPi
#
# Parameters of the Jabber class
#
# Liam Friel
# CoderDojo Bray
#
 
class jabber::prerequisites {

    # Some pre-requisites
    require postgresql::server
    require postgresql::client
    require postgresql::lib::devel
    require expat
    require udns
    require gnusasl  
  
}
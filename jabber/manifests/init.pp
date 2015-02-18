# Class to install jabber2 on an RPi
# This has to be built from source ... 
#
# Liam Friel
# CoderDojo Bray
#

class jabber() {

    # define prerequisites
    include jabber::prerequisites
    
    # Some definitions
    include jabber::params
    
    # Do build setup ... 
    include jabber::setup

    # Build and Install Jabber components
    include jabber::build    
    
    
}
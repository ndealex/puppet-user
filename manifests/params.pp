# Class: user::params
#
#   This class manages params.
#
#   Alexander Schrapel <ndealex@gmail.com>
#   2014-01-21
#
#   Tested platforms:
#    - Ubuntu 12.04
#
# Actions:
#
#
#
# Requires:
#
#
#
# Sample Usage:
#
#
#
class user::params {

  $default_home_root  = '/home'
  $managehome         = true
  $default_shell      = '/bin/bash'
}


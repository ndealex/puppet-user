# Class: user
# ===========================
#
# Full description of class user here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'user':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class user (

  $users              = lookup('user_accounts', Hash, 'deep'),
  $groups             = lookup('user_groups', Hash, 'deep'),
  $login_roles        = lookup('user_login_roles', Array[String], 'unique'),
  $ignore_users       = lookup('user_ignore_accounts', Array[String], 'unique', []),

  $create_accounts    = $user::params::create_accounts,
  $deactivate_accounts= $user::params::deactivate_accounts,
  $default_home_root  = $user::params::default_home_root,
  $managehome         = $user::params::managehome,
  $default_shell      = $user::params::default_shell,

) inherits user::params {

  $login_users = user_of_roles($login_roles)
  $to_remove = user_to_remove($login_users, $ignore_users)

  ### DEBUG
  if is_array($login_users) {
    $login_roles_to_str  = join($login_roles,  ',')
  } else {
    $login_roles_to_str  = "${loging_roles} "
  }
  if is_array($ignore_users) {
    $ignore_users_to_str = join($ignore_users, ',')
  } else {
    $ignore_users_to_str = "${ignore_users} "
  }
  if is_array($login_users) {
    $login_users_to_str  = join($login_users,  ',')
  } else {
    $login_users_to_str  = "${login_users} "
  }
  if is_array($to_remove) {
    $to_remove_to_str    = join($to_remove,    ',')
  } else {
    $to_remove_to_str    = "${to_remove} "
  }
  notify{ [
    "Login roles: ${login_roles_to_str}",
    "Ignored users: ${ignore_users_to_str}",
    "Active Logins: ${login_users_to_str}",
    "Disabled logins: ${to_remove_to_str}",
  ]:
    loglevel => debug,
  }
  ### END-OF-DEBUG

  if $create_accounts {
    user::account { $login_users:
      ensure  => 'present',
    }
  }

  if $deactivate_accounts and $to_remove {
    user::account { $to_remove:
      ensure  => 'deactivated',
    }
  }
}

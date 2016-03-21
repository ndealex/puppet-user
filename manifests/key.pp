# Resource: component_user::keys
#
#   This class manages ssh user keys and is for module internal use.
#
#   Alexander Schrapel <ndealex@gmail.com>
#   2014-01-14
#
#   Tested platforms:
#    - Ubuntu 12.04
#
# Actions:
#
#  $keys = Hash of ssh keys,
#  $home = User home dir,
#  $username = Name of user,
#
# Sample Usage:
#
#
define user::key (
  $ensure,
  $user_name  = $name,
  $home_dir   = undef,
  $users      = $user::users,
  $key_name   = default,
  $key        = undef,
) {

  if !$key {
    if has_key($users, $user_name) and has_key($users[$username], $key_name) {
      $_key = $users[$username][$key_name]
    } else {
      fail("User: Can't find ssh key with name ${key_name} for user ${user_name}.")
    }
  } else {
    $_key = $key
  }

  if ! $home_dir {
    $_home_dir = "${user::default_home_root}/${user_name}"
  } else {
    $_home_dir = $home_dir
  }

  ensure_resource('file', "${_home_dir}/.ssh", {
    ensure  => 'directory',
    mode    => '0700',
    owner   => $user_name,
    require => User::Home[$home_dir],
  })

  ensure_resource('ssh_authorized_key', "${user_name}-${key_name}", {
    ensure          => $ensure,
    key             => $_key['key'],
    'type'          => $_key['type'],
    options         => $_key['options'],
    user            => $user_name,
    target          => "${_home_dir}/.ssh/authorized_keys",
    #purge_ssh_keys  => true,
    require         => File["${_home_dir}/.ssh"],
  })

}


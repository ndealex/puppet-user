# Resource: component_user::user
#
#   This class manages users.
#
#   Alexander Schrapel <ndealex@gmail.com>
#   2014-01-14
#
#   Tested platforms:
#    - Ubuntu 12.04
#
# Actions:
#
#  $name = Username
#  $users = Hash of all users including the user with the username $name,
#  $ensure = present or deactivated,
#  $noop = No operation flag, if noop is true, nothing is doing. This is mainly used for TOS managed systems.
#
# Requires:
#
#
#
# Sample Usage:
#
#  user::user { $login_users:
#    ensure  => 'present',
#  }
#
#  if $to_remove {
#    user::user { $to_remove:
#      ensure  => 'deactivated',
#    }
#  }
#
define user::account (
  $ensure,
  $user_name  = $name,
  $users      = $user::users,
) {
  include user

  if ( $ensure == 'present' ) {

    # get user information
    if ! has_key($users, $user_name) {
      fail("No user information found for user ${user_name}, ensure ${ensure}")
    }
    $user = $users[$user_name]
    validate_hash($user)

    $gid =  $user['gid'] ? {
      undef   => $user['uid'],
      default => $user['gid'],
    }
    $home = $user['home'] ? {
      undef   => "${user::default_home_root}/${user_name}",
      default => $user['home'],
    }

    # create/manage user (/etc/passwd et. al.)
    user { $name:
      ensure            => $ensure,
      name              => $user_name,
      uid               => $user['uid'],
      gid               => $gid,
      home              => $home,
      managehome        => $user['managehome'] ? {
        undef   => $user::managehome,
        default => $user['managehome'],
      },
      password          => $user['password'],
      shell             => $user['shell'] ? {
        undef   => $user::default_shell,
        default => $user['shell'],
      },
      system            => false,
      comment           => $user['comment'],
      password_max_age  => -1,
    }

    # organize home dir
    user::home { $home:
      ensure    => 'present',
      user_name => $user_name,
    }

    # create group, if necessary
    user::group { $user_name:
      ensure  => 'present',
      gid     => $gid,
      before  => User[$user_name],
    }

    if has_key($user, 'keys') {
      $user['keys'].each |$key_name, $key| {

        user::key { "${user_name}-${key_name}":
          ensure    => $present,
          user_name => $name,
          key_name  => $key_name,
          key       => $key,
        }

      }
    }
  } elsif ($ensure == 'deactivated') {

    ensure_resource('user', $name, {
      shell     => '/bin/false',
      password  => '',
    })

    if has_key($users, $user_name) and has_key($users[$user_name],'keys') {
      $keys = $users[$user_name]['keys']
      $keys.each |$key_name, $key| {

        user::key { "${user_name}-${key_name}":
          ensure    => 'absent',
          user_name => $name,
          key_name  => $key_name,
          key       => $key,
        }
      }
    }
  }
}


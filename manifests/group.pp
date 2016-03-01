

define user::group (
  $ensure,
  $group_name = $name,
  $gid        = undef,
  $members    = [],
  $roles      = undef,
  $groups     = $user::groups,
) {

  if $ensure == 'present' {

    if $roles {
      $_members = concat(user_of_roles($roles, true), $members)
    } else {
      $_members = $members
    }

    if $gid {
      $_gid = $gid
    } elsif has_key($groups, $group_name) {
      if !has_key($groups[$group_name], 'gid') {
        fail('User: Group found in groups hash, but there is not gid defined.')
      }
      $_gid = $groups[$group_name]['gid']
    } else{
      $_gid = undef
    }

    ::group { $group_name:
      ensure  => 'present',
      gid     => $_gid,
      members => $_members,
    }

  }elsif $ensure == 'absent' {

    ::group { $group_name:
      ensure => 'absent',
    }

  }else{

    fail("User: unknown ensure $ensure for group")

  }
}
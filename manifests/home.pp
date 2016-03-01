
define user::home (
  $ensure,
  $user_name,
  $home_dir   = $name,
  $group_name = undef,
) {

  if !$group_name {
    $_group_name = $user_name
  } else {
    $_group_name = $group_name
  }

  file { $home_dir:
    ensure  => $ensure,
    mode    => '0700',
    owner   => $user_name,
    group   => $_group_name,
  }

}
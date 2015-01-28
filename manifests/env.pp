define anyenv::env (
  $user,
  $env,
  $home = "/home/${user}",
  $profile = '.bash_profile',
) {
  anchor {
    "anyenv::env::${user}::begin":
      before => Anchor["anyenv::env::${user}::end"];
    "anyenv::env::${user}::end":
      require => Anchor["anyenv::env::${user}::begin"];
  }

  if ! defined( Anchor["anyenv::setup::${user}::begin"] ) {
    anyenv::setup { "anyenv_${user}":
      user    => $user,
      home    => $home,
      profile => $profile,
    }
  }

  exec {
    "install ${env} for ${user}":
      command  => "\$SHELL -lc \"anyenv install ${env}\"",
      provider => shell,
      creates  => "${home}/.anyenv/envs/${env}",
      user     => $user,
      require  => Exec["verify the anyenv install for ${user}"];
    "verify ${env} install for ${user}":
      command  => "\$SHELL -lc \"anyenv version | grep -i \'${env}:\' > /dev/null 2>&1\"",
      provider => shell,
      user     => $user,
      require  => Exec["install ${env} for ${user}"];
  }
}

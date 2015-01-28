define anyenv::env::install (
  $user,
  $env,
  $version,
  $home = "/home/${user}",
  $profile = "${home}/.bash_profile",
) {
  anchor {
    "anyenv::env::install::${user}::${env}::${version}::begin":
      before => Anchor["anyenv::env::install::${user}::${env}::${version}::end"];
    "anyenv::env::install::${user}::${env}::${version}::end":
      require => Anchor["anyenv::env::install::${user}::${env}::${version}::begin"];
  }

  if ! defined( Anchor["anyenv::env::${user}::begin"] ) {
    anyenv::env { "anyenv_${user}_${env}":
      user    => $user,
      env     => $env,
      home    => $home,
      profile => $profile,
    }
  }

  exec {
    "install ${env} ${version} for ${user}":
      command  => "\$SHELL -lc \"${env} install ${version}\"",
      provider => shell,
      creates  => "${home}/.anyenv/envs/${env}/versions/${version}",
      user     => $user,
      require  => [ 
        Exec["install ${env} for ${user}"],
        Anchor["anyenv::env::install::${user}::${env}::${version}::begin"],
      ],
      before  => Anchor["anyenv::env::install::${user}::${env}::${version}::end"];
    "verify ${env} ${version} for ${user}":
      command  => "\$SHELL -lc \"${env} versions | grep -i \'${version}\' > /dev/null 2>&1\"",
      provider => shell,
      user     => $user,
      require  => Exec["install ${env} ${version} for ${user}"],
      before   => Anchor["anyenv::env::install::${user}::${env}::${version}::end"];
  }
}

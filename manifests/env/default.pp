define anyenv::env::default (
  $user,
  $env,
  $version,
  $install = false,
  $home = "/home/${user}",
  $profile = "${home}/.bash_profile",
) {
  anchor {
    "anyenv::env::default::${user}::${env}::${version}::begin":
      before => Anchor["anyenv::env::default::${user}::${env}::${version}::end"];
    "anyenv::env::default::${user}::${env}::${version}::end":
      require => Anchor["anyenv::env::default::${user}::${env}::${version}::begin"];
  }

  if $install and ! defined( Anchor["anyenv::env::install::${user}::${env}::${version}::begin"] ) {
    anyenv::env::install { "anyenv_${user}_${env}_${version}":
      user    => $user,
      env     => $env,
      version => $version,
      home    => $home,
      profile => $profile,
    }
  }

  exec {
    "set ${env} ${version} as default for ${user}":
      command  => "\$SHELL -lc \"${env} global ${version}\"",
      provider => shell,
      onlyif   => "grep -vi \"${version}\" ${home}/.anyenv/envs/${env}/version > /dev/null 2>&1",
      user     => $user,
      require  => [ 
        Exec["install ${env} ${version} for ${user}"],
        Anchor["anyenv::env::default::${user}::${env}::${version}::begin"],
      ],
      before  => Anchor["anyenv::env::default::${user}::${env}::${version}::end"];
    "verify ${env} ${version} is default for ${user}":
      command  => "\$SHELL -lc \"${env} version | grep -i \'${version}\' > /dev/null 2>&1\"",
      provider => shell,
      user     => $user,
      require  => Exec["set ${env} ${version} as default for ${user}"],
      before   => Anchor["anyenv::env::default::${user}::${env}::${version}::end"];
  }
}

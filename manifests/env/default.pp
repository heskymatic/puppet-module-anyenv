define anyenv::env::default (
  $user,
  $env,
  $version,
  $install = false,
  $home    = "/home/${user}",
  $profile = '.bash_profile',
  $shell   = '/bin/bash',
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
      shell   => $shell,
      before  => Anchor["anyenv::env::default::${user}::${env}::${version}::begin"];
    }
  }

  $env_upcase = upcase($env)

  Exec {
    user        => $user,
    cwd         => $home,
    environment => [
      "HOME=${home}",
      "${env_upcase}_ROOT=${home}/.anyenv/envs/${env}",
    ],
    path => [
      "${home}/.anyenv/bin",
      "${home}/.anyenv/envs/${env}/bin",
      '/usr/local/bin',
      '/usr/bin',
      '/bin',
    ],
  }

  exec {
    "set ${env} ${version} as default for ${user}":
      command => "${env} global ${version}",
      onlyif  => "test ! -f ${home}/.anyenv/envs/${envs}/version ||
        grep -vi \"${version}\" ${home}/.anyenv/envs/${env}/version > /dev/null 2>&1",
      require => [
        Anchor["anyenv::env::default::${user}::${env}::${version}::begin"],
        Anchor["anyenv::env::install::${user}::${env}::${version}::end"],
      ],
      before => Anchor["anyenv::env::default::${user}::${env}::${version}::end"];
    "verify ${env} ${version} is default for ${user}":
      command => "${env} version | grep -i \'${version}\' > /dev/null 2>&1",
      require => Exec["set ${env} ${version} as default for ${user}"],
      before  => Anchor["anyenv::env::default::${user}::${env}::${version}::end"];
  }
}

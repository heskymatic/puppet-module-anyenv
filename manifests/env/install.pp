define anyenv::env::install (
  $user,
  $env,
  $version,
  $home    = "/home/${user}",
  $profile = '.bash_profile',
  $shell   = '/bin/bash',
) {
  anchor {
    "anyenv::env::install::${user}::${env}::${version}::begin":
      before => Anchor["anyenv::env::install::${user}::${env}::${version}::end"];
    "anyenv::env::install::${user}::${env}::${version}::end":
      require => Anchor["anyenv::env::install::${user}::${env}::${version}::begin"];
  }

  if ! defined( Anyenv::Env["anyenv_${user}_${env}"] ) {
    anyenv::env { "anyenv_${user}_${env}":
      user    => $user,
      env     => $env,
      home    => $home,
      profile => $profile,
      shell   => $shell,
      before  => Anchor["anyenv::env::install::${user}::${env}::${version}::begin"];
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
    "install ${env} ${version} for ${user}":
      command => "${env} install ${version}",
      timeout => 0,
      creates => "${home}/.anyenv/envs/${env}/versions/${version}",
      require => [
        Anchor["anyenv::env::${user}::${env}::end"],
        Anchor["anyenv::env::install::${user}::${env}::${version}::begin"],
      ],
      before => Anchor["anyenv::env::install::${user}::${env}::${version}::end"];
    "verify ${env} ${version} for ${user}":
      command => "${env} versions | grep -i \'${version}\' > /dev/null 2>&1",
      require => Exec["install ${env} ${version} for ${user}"],
      before  => Anchor["anyenv::env::install::${user}::${env}::${version}::end"];
  }
}

define anyenv::env (
  $user,
  $env,
  $home    = "/home/${user}",
  $profile = '.bash_profile',
  $shell   = '/bin/bash',
) {
  anchor {
    "anyenv::env::${user}::${env}::begin":
      before => Anchor["anyenv::env::${user}::${env}::end"];
    "anyenv::env::${user}::${env}::end":
      require => Anchor["anyenv::env::${user}::${env}::begin"];
  }

  if ! defined( Anchor["anyenv::setup::${user}::end"] ) {
    anyenv::setup { "anyenv_${user}":
      user    => $user,
      home    => $home,
      profile => $profile,
      shell   => $shell,
      before  => Anchor["anyenv::env::${user}::${env}::begin"];
    }
  }

  Exec {
    user        => $user,
    cwd         => $home,
    environment => [ "HOME=${home}", "SHELL=${shell}" ],
    path        => [
      "${home}/.anyenv/bin",
      "${home}/.anyenv/envs/${env}/bin",
      '/usr/local/bin',
      '/usr/bin',
      '/bin',
    ],
  }

  exec {
    "install ${env} for ${user}":
      command => "${shell} -lc \"anyenv install ${env}\"",
      timeout => 0,
      creates => "${home}/.anyenv/envs/${env}",
      require => [
        Anchor["anyenv::env::${user}::${env}::begin"],
        Anchor["anyenv::setup::${user}::end"],
      ],
      before => Anchor["anyenv::env::${user}::${env}::end"];
    "verify ${env} install for ${user}":
      command => "anyenv version | grep -i \'${env}:\' > /dev/null 2>&1",
      require => Exec["install ${env} for ${user}"],
      before  => Anchor["anyenv::env::${user}::${env}::end"];
  }
}

define anyenv::setup (
  $user,
  $home    = "/home/${user}",
  $profile = '.bash_profile',
  $shell   = '/bin/bash',
) {
  anchor {
    "anyenv::setup::${user}::begin":
      before => Anchor["anyenv::setup::${user}::end"];
    "anyenv::setup::${user}::end":
      require => Anchor["anyenv::setup::${user}::begin"];
  }

  vcsrepo { "${home}/.anyenv":
    ensure   => present,
    provider => git,
    source   => 'https://github.com/riywo/anyenv',
    user     => $user,
    require  => Anchor["anyenv::setup::${user}::begin"],
    before   => Anchor["anyenv::setup::${user}::end"];
  }

  Exec {
    user => $user,
    path => [
      "${home}/.anyenv/bin",
      '/usr/local/bin',
      '/usr/bin',
      '/bin',
    ],
  }

  exec {
    "prepend path in ${home}/${profile}":
      command => "echo \'export PATH=\"${home}/.anyenv/bin:\$PATH\"\' >> ${home}/${profile}",
      unless  => "grep -i '.anyenv/bin' ${home}/${profile} > /dev/null 2>&1",
      require => Vcsrepo["${home}/.anyenv"];
    "append eval in ${home}/${profile}":
      command => "echo \'eval \"$(anyenv init -)\"\' >> ${home}/${profile}",
      unless  => "grep -i 'anyenv init -' ${home}/${profile} > /dev/null 2>&1",
      require => Exec["prepend path in ${home}/${profile}"];
    "verify the anyenv install for ${user}":
      command => "${shell} -lc \"anyenv version\"",
      require => Exec["append eval in ${home}/${profile}"],
      before  => Anchor["anyenv::setup::${user}::end"];
  }
}

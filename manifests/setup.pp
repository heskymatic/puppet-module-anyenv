define anyenv::setup (
  $user,
  $home = "/home/${user}",
  $profile = '.bash_profile',
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

  exec {
    "prepend path in ${home}/${profile}":
      command  => "echo \'export PATH=\"${home}/.anyenv/bin:\$PATH\"\' >> ${home}/${profile}",
      provider => shell,
      unless   => "grep -i '.anyenv/bin' ${home}/${profile} > /dev/null 2>&1",
      user     => $user,
      require  => Vcsrepo["${home}/.anyenv"];
    "append eval in ${home}/${profile}":
      command  => "echo \'eval \"$(anyenv init -)\"\' >> ${home}/${profile}",
      provider => shell,
      unless   => "grep -i 'anyenv init -' ${home}/${profile} > /dev/null 2>&1",
      user     => $user,
      require  => Exec["prepend path in ${home}/${profile}"];
    "verify the anyenv install for ${user}":
      command  => "\$SHELL -lc \"anyenv version\"",
      provider => shell,
      user     => $user,
      require  => Exec["append eval in ${home}/${profile}"];
  }
}

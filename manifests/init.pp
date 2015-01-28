# define anyenv (
#   $user,
#   $home = "/home/${user}",
#   $profile = "${home}/.bash_profile",
# ) {
#   vcsrepo { "${home}/.anyenv":
#     ensure   => present,
#     provider => git,
#     source   => 'https://github.com/riywo/anyenv',
#     user     => $user,
#   }
# 
#   exec {
#     "prepend path in ${profile}":
#       command  => "echo \'export PATH=\"${home}/.anyenv/bin:\$PATH\"\' >> ${profile}",
#       provider => shell,
#       unless   => "grep -i '.anyenv/bin' ${profile} > /dev/null 2>&1",
#       user     => $user,
#       require  => Vcsrepo["${home}/.anyenv"];
#     "append eval in ${profile}":
#       command  => "echo \'eval \"$(anyenv init -)\"\' >> ${profile}",
#       provider => shell,
#       unless   => "grep -i 'anyenv init -' ${profile} > /dev/null 2>&1",
#       user     => $user,
#       require  => Exec["prepend path in ${profile}"];
#     "verify the anyenv install for ${user}":
#       command  => "\$SHELL -lc \"anyenv version\"",
#       provider => shell,
#       user     => $user,
#       require  => Exec["append eval in ${profile}"];
#   }
# }

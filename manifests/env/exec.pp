define anyenv::env::exec (
  $user,
  $env,
  $exec,
  $version,
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

  exec {
    'install npm depdencies':
      command  => "npm install",
      timeout  => 0,
      user     => 'deploy',
      provider => shell,
      cwd      => '/home/deploy/deployment/current',
      environment => [ "HOME=/home/deploy", "NDENV_ROOT=/home/deploy/.anyenv/envs/ndenv" ],
      path     => [
        '/home/deploy/.anyenv/bin',
        '/home/deploy/.anyenv/envs/ndenv/bin',
        '/home/deploy/.anyenv/envs/ndenv/shims',
        '/usr/local/bin',
        '/usr/bin',
        '/bin',
      ],
      require  => [
        Anyenv::Env::Default["anyenv_deploy_ndenv_default_${nodejs_version}"],
        File['/home/deploy/deployment/current'],
      ];
    # 'install pm2':
    #   command  => "npm install pm2 -g",
    #   user     => 'deploy',
    #   provider => shell,
    #   cwd      => '/home/deploy/deployment/current',
    #   environment => [ "HOME=/home/deploy", "NDENV_ROOT=/home/deploy/.anyenv/envs/ndenv" ],
    #   path     => [
    #     '/home/deploy/.anyenv/bin',
    #     '/home/deploy/.anyenv/envs/ndenv/bin',
    #     '/home/deploy/.anyenv/envs/ndenv/shims',
    #     '/usr/local/bin',
    #     '/usr/bin',
    #     '/bin',
    #   ],
    #   require  => [
    #     Anyenv::Env::Default["anyenv_deploy_ndenv_default_${nodejs_version}"],
    #     File['/home/deploy/deployment/current'],
    #   ];
  }
}

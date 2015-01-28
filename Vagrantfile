Vagrant.configure("2") do |config|
  config.vm.box = "debian-73-x64-virtualbox-nocm"

  # use local puppetlib modules and this module as /etc/puppet
  config.vm.synced_folder "./spec/fixtures/modules", "/etc/puppet/modules", :create => true, :owner => "root", :group => "root"
  config.vm.synced_folder ".", "/etc/puppet/anyenv", :create => true, :owner => "root", :group => "root"

  # map the root graphs directory to local, so we can easily check them out in ./graphs
  config.vm.synced_folder "graphs", "/var/lib/puppet/state/graphs", :create => true, :owner => "root", :group => "root"

  # allow additional puppet options to be passed in (e.g. --graph, --debug, etc.)
  # note: splitting args is fragile and doesn't support spaces in args, but for now it works for what we need
  # puppet_options = ["--modulepath", "/etc/puppet/modules", (ENV['PUPPET_OPTIONS']||"").split(/ /)];

  # config.vm.provision :puppet do |puppet|
  #   puppet.options = puppet_options
  #   puppet.facter = { "maestrodev_username" => ENV['MAESTRODEV_USERNAME'], "maestrodev_password" => ENV['MAESTRODEV_PASSWORD'] }
  #   puppet.manifests_path = "tests"
  #   puppet.manifest_file  = "site.pp"
  # end

  config.vm.define :default do |config|
    config.vm.host_name = "box1"
  end
end

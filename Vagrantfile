# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "10.04-32"
  config.vm.box_url = "http://files.vagrantup.com/lucid32.box"

  config.vm.share_folder "packages", "/packages", "."
  config.vm.provision :shell, :inline => "/packages/server_init.sh"

end

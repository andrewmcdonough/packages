# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.define :x86 do |x86_config|
    x86_config.vm.box     = "10.04-32"
    x86_config.vm.box_url = "http://files.vagrantup.com/lucid32.box"

    x86_config.vm.forward_port 22, 2222
  end

  config.vm.define :amd64 do |amd64_config|
    amd64_config.vm.box     = "10.04-64"
    amd64_config.vm.box_url = "http://files.vagrantup.com/lucid64.box"

    amd64_config.vm.forward_port 22, 2223
  end

  config.vm.share_folder "packages", "/packages", "."
  config.vm.provision :shell, :path => "server_init.sh"

end

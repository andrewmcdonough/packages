# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("1") do |config|

  config.vm.define :lucid32 do |x86_config|
    x86_config.vm.box     = "10.04-32"
    x86_config.vm.box_url = "http://files.vagrantup.com/lucid32.box"

    x86_config.vm.forward_port 22, 2222
  end

  config.vm.define :lucid64 do |amd64_config|
    amd64_config.vm.box     = "10.04-64"
    amd64_config.vm.box_url = "http://files.vagrantup.com/lucid64.box"

    amd64_config.vm.forward_port 22, 2223
  end

  config.vm.define :precise32 do |x86_config|
    x86_config.vm.box     = "12.04-32"
    x86_config.vm.box_url = "http://files.vagrantup.com/precise32.box"

    x86_config.vm.forward_port 22, 2224
  end

  config.vm.define :precise64 do |amd64_config|
    amd64_config.vm.box     = "12.04-64"
    amd64_config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    amd64_config.vm.forward_port 22, 2225
  end

  config.vm.share_folder "packages", "/packages", "."
  config.vm.provision :shell, :path => "server_init.sh"

end

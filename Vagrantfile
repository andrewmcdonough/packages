# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define :precise32 do |vm_config|
    vm_config.vm.box     = "12.04-32"
    vm_config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  end

  config.vm.define :precise64 do |vm_config|
    vm_config.vm.box     = "12.04-64"
    vm_config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  end

  config.vm.provision :shell, :path => "server_init.sh"
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.define :precise64 do |vm_config|
    vm_config.vm.box     = "precise64"
    vm_config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  end

  config.vm.provision :shell, :path => "bootstrap_server"
end

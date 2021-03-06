# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'
require 'yaml'

#require "#{File.dirname(__FILE__)}/vagrant/artisan.rb"
#require "#{File.dirname(__FILE__)}/vagrant/composer.rb"

VAGRANTFILE_API_VERSION = "2"

configJsonPath = "config.json"
if File.exists? configJsonPath then
    jsonConfig = JSON.parse(File.read(configJsonPath));
end


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "precise32"

  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network :private_network, ip: jsonConfig["ip"] ||= "192.168.54.54"
  config.ssh.forward_agent = true
  
  config.vm.network :forwarded_port, guest: 80, host: 8888, auto_correct: true
  config.vm.network :forwarded_port, guest: 3306, host: 8889, auto_correct: true
  config.vm.network :forwarded_port, guest: 5432, host: 5433, auto_correct: true

  
  config.vm.hostname = "vagrant54"

  config.vm.provider :virtualbox do |vb|
      vb.name = "vagrant54"
  end


  # Register All Of The Configured Shared Folders
  if jsonConfig.include? 'folders'
    jsonConfig["folders"].each do |folder|
      config.vm.synced_folder folder["map"], folder["to"], mount_options: [], owner: "www-data", group: "www-data"
    end
  end

 
  config.vm.provision :shell, :inline => "echo \"Europe/Moscow\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

  config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "phpbase.pp"
      puppet.module_path = "puppet/modules"
      puppet.facter = {
          "sites" => JSON.generate(jsonConfig["sites"]),
      }
      #puppet.options = "--verbose --debug"
      #puppet.options = "--verbose"
  end
  
  config.vm.provision :shell, :path => "puppet/scripts/enable_remote_mysql_access.sh"
end

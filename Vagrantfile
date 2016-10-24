# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'etc'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.shell = "sh"

  config.vm.define "adhokku" do |adhokku|
    adhokku.vm.box = "freebsd/FreeBSD-11.0-STABLE"
    adhokku.vm.guest = :freebsd
    adhokku.vm.network "forwarded_port", guest: 80, host: 8080
    adhokku.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  config.vm.provision :shell do |s|
    ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
    s.env = {"PUBLIC_KEY" => ssh_pub_key, "REMOTE_USER" => Etc.getlogin}
    s.path = "bootstrap-vagrant.sh"
  end
end

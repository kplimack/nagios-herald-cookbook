Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = "nagios-herald-berkshelf"
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.roles_path = "/Users/jakeplimack/chef/roles"
    chef.json = {    }

    chef.run_list = [
      "recipe[showmobile-apt]",
      "recipe[nagios-herald::default]"
    ]
  end
end

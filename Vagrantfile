Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty64'

  config.vm.provider 'virtualbox' do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.network 'forwarded_port', guest: 3000, host: 3000

  config.vm.provision 'shell', inline: <<-SHELL, privileged: false
    sudo apt-get clean
    sudo apt-get update

    sudo apt-get install -y git
    sudo apt-get install -y vim

    sudo apt-get install -y nodejs

    sudo apt-get install -y sqlite
    sudo apt-get install -y libsqlite3-dev

    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
          export PATH="$HOME/.rbenv/bin:$PATH"
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
          eval "$(rbenv init -)"              
    sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev
    rbenv install --verbose 2.2.3
    rbenv global 2.2.3
    echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
    gem install bundler
    rbenv rehash

    git clone https://github.com/vais/dotfiles.git ~/dotfiles
    ~/dotfiles/update

    echo 'cd /vagrant' >> ~/.bashrc
  SHELL
end

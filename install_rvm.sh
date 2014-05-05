
sudo apt-get autoremove libruby1.8 irb1.8 ruby
sudo apt-get --purge remove ruby-rvm
sudo rm -rf /usr/share/ruby-rvm /etc/rvmrc /etc/profile.d/rvm.sh

# sudo apt-get install -y ruby-rvm

sudo curl -sSL https://get.rvm.io | bash -s stable --ruby --autolibs=enable --auto-dotfiles

#sudo env PATH=$PATH rvm install ruby-2.1.1
sudo env PATH=$PATH rvm alias create default ruby-2.1.1
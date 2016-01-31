USER="pi"

execute "upate apt" do
  user "root"
  command "apt-get update"
end

%w(
  vim
  git
).each do |package|
  package package do
    action :install
  end
end

execute "disable raspi-config" do
  command "rm -f /etc/profile.d/raspi-config.sh"
  only_if "test -e /etc/profile.d/raspi-config.sh"
end

execute "setting timezone" do
  command "echo 'Asia/Tokyo' > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata"
  not_if "grep 'Asia/Tokyo' /etc/timezone"
  user "root"
end

execute "setting locales" do
  command "sed -i -e \'s/^en_GB.UTF-8 UTF-8/# en_GB.UTF-8 UTF-8/\' /etc/locale.gen; sed -i -e \'s/^# en_US.UTF-8 UTF-8/e    n_US.UTF-8 UTF-8/\' /etc/locale.gen; sed -i -e \'s/^# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/\' /etc/locale.gen; dpkg-reconfigure --frontend=noninteractive locales"
  only_if "grep '# en_GB.UTF-8' /etc/locale.gen"
end

execute "expand rootfs size" do
  command "raspi-config --expand-rootfs"
end

remote_file "/etc/default/keyboard" do
  source "../templetes/keyboard"
  owner "root"
  group "root"
end

#execute "change $HOME/.config Permission" do
#  command "chown -R #{USER}:#{USER} /home/#{USER}/.config"
#  only_if "test -e /home/#{USER}/.config"
#  user "root"
#end

#remote_file "/usr/local/bin/sushi" do
#  source "../remote_files/sushi"
#  owner "root"
#  group "staff"
#end

execute "setting done. reboot ..." do
  command "sudo reboot"
end

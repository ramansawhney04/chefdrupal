execute 'packageupdate' do 
  command 'apt-get update'
end

package 'apache2' do
  action :install
end

service 'apache2' do
  action [:enable, :start]
end

package 'mysql-server' do
  action :install
end

service 'mysql' do
  action [:enable, :start]
end

package 'php5' do
  action :install
end

file '/var/www/html/info.php' do
  content '<?php phpinfo(); ?>'
  action :create_if_missing
end 

package 'libapache2-mod-php5' do
  action :install
end

package 'phpmyadmin' do
  action :install
end

package 'libapache2-mod-auth-mysql' do
  action :install
end 

package 'php5-mysql' do
  action :install
end

package 'php5-mcrypt' do
  action :install
end

package 'php5-gd' do
  action :install
end

package 'php5-curl' do
  action :install
end

package 'libssh2-php' do
  action :install
end

execute 'sqllogin' do 
  command 'mysqladmin -u root password 123@India && touch /var/flagmysqlroot'
  creates '/var/flagmysqlroot'
end 

cookbook_file '/root/mysqlcommands.txt' do
  source 'mysqlcommands.txt'
  owner 'root'
  group 'root'
  mode '0777'
  action :create_if_missing
end

execute 'sqlexecution' do 
  command 'mysql -uroot -p123@India </root/mysqlcommands.txt && touch /var/flagmysql1'
  creates '/var/flagmysql1'
end

remote_file '/var/www/html/drupal-7.32.tar.gz' do
  source 'http://ftp.drupal.org/files/projects/drupal-7.32.tar.gz'
end
 
execute 'untar' do
  command 'tar -zxvf drupal-7.32.tar.gz'
  cwd '/var/www/html'
end
      
execute 'rsync' do
  command 'rsync -avP drupal-7.32/ .'
  cwd '/var/www/html'
end

execute 'creationdir' do
  command 'mkdir -p sites/default/files'
  cwd '/var/www/html'
end

execute 'copy' do
  command 'cp /var/www/html/sites/example.sites.php /var/www/html/sites/default/settings.php'
end

execute 'changemode' do
  command 'chmod 777 /var/www/html/sites/default/settings.php'
end

execute 'changeowner' do
  command 'chown -R www-data:www-data /var/www/html'
end

execute 'moveblock' do
  command 'mv /var/www/html/index.html /var && touch /var/flagindex'
  creates '/var/flagindex'
end


if platform_family?('rhel')
  include_recipe 'selinux::_common'

  selinux_state 'SELinux Permissive' do
    action :permissive
  end
end

mariadb_repository 'install' do
  version '10.3'
end

mariadb_server_install 'package' do
  password 'gsql'
  action [:install, :create]
end

find_resource(:service, 'mariadb') do
  extend MariaDBCookbook::Helpers
  service_name lazy { platform_service_name }
  supports restart: true, status: true, reload: true
  action [:enable, :start]
end

mariadb_database 'k3s' do
  user 'root'
  password 'gsql'
end

mariadb_user 'k3s' do
  ctrl_user 'root'
  ctrl_password 'gsql'
  password 'k3s'
  database_name 'k3s'
  action [:create, :grant]
end

k3s_install 'server'

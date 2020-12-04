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

k3s_install 'server' do
  mariadb_ctrl_password 'gsql'
end

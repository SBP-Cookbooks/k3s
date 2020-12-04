#
# Cookbook:: k3s
# Resource:: install
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

provides :k3s_install

property :datastore,             String, equal_to: ['mariadb'], default: 'mariadb'
property :kubeconfig_mode,       String, default: '0644'
property :mariadb_ctrl_password, String, sensitive: true, default: lazy { node['k3s']['mariadb']['ctrl_password'] }
property :mariadb_ctrl_user,     String, default: 'root'
property :mariadb_database,      String, default: 'k3s'
property :mariadb_host,          String, default: 'localhost'
property :mariadb_password,      String, default: 'k3s', sensitive: true
property :mariadb_user,          String, default: 'k3s'
property :mode,                  String, name_property: true

action :create do
  if platform_family?('rhel')
    include_recipe 'selinux_policy::install'
    package %w(container-selinux selinux-policy-base)
  end

  install_code = "curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode #{new_resource.kubeconfig_mode}"

  if new_resource.datastore == 'mariadb'
    mariadb_database 'k3s' do
      user new_resource.mariadb_ctrl_user
      password new_resource.mariadb_ctrl_password
    end

    mariadb_user 'k3s' do
      ctrl_user new_resource.mariadb_ctrl_user
      ctrl_password new_resource.mariadb_ctrl_password
      password new_resource.mariadb_password
      host 'localhost'
      database_name 'k3s'
      action [:create, :grant]
    end

    datastore_endpoint = "--datastore-endpoint='mysql://#{new_resource.mariadb_user}:#{new_resource.mariadb_password}@tcp(#{new_resource.mariadb_host}:3306)/k3s'"
  end

  install_code << " #{datastore_endpoint}"

  bash 'Install k3s' do
    code install_code
    creates '/var/lib/rancher/k3s'
    environment('INSTALL_K3S_BIN_DIR' => '/usr/sbin')
  end

  service 'k3s' do
    action [:enable, :start]
  end
end

action :remove do
  bash 'Remove k3s' do
    code '/usr/local/bin/k3s-uninstall.sh'
    only_if { ::File.exist?('/var/lib/rancher/k3s') }
  end
end

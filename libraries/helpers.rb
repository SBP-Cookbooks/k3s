#
# Cookbook:: k3s
# Library:: helpers
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

module K3sCookbook
  module Helpers
    include Chef::Mixin::ShellOut

    def k3s_node_ready?
      cmd = shell_out("kubectl get node #{node['hostname']}")

      return false if cmd.exitstatus != 0

      output = cmd.stdout.split(/\\n/)
      node_info = output.grep(/#{node['hostname']}/).shift
      node_info.split(/\s+/).include?('Ready')
    end
  end
end

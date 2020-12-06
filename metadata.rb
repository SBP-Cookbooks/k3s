name             'k3s'
maintainer       'Schuberg Philis'
maintainer_email 'cookbooks@schubergphilis.com'
license          'Apache-2.0'
description      'Installs k3s'
version          '0.1.0'
chef_version     '>= 15.0'

issues_url 'https://github.com/SBP-Cookbooks/k3s/issues'
source_url 'https://github.com/SBP-Cookbooks/k3s'

supports 'centos'
supports 'debian'
supports 'ubuntu'

depends 'selinux_policy'

name             'nginx_simplecgi'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Provides SimpleCGI for NGINX'
version          '0.3.5'
source_url       'https://github.com/sous-chefs/nginx_simplecgi'
issues_url       'https://github.com/sous-chefs/nginx_simplecgi/issues'
chef_version     '>= 15.3'

supports 'debian'
supports 'ubuntu'
supports 'redhat'
supports 'centos'
supports 'fedora'
supports 'scientific'
supports 'amazon'
supports 'oracle'

depends 'nginx'
depends 'perl'
depends 'runit'
depends 'yum-epel'

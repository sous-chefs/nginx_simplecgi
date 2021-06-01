name             'nginx_simplecgi'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Provides SimpleCGI for NGINX'
version          '0.3.2'

%w( debian ubuntu redhat centos fedora scientific amazon oracle ).each do |os|
  supports os
end

%w( nginx perl runit yum-epel ).each do |dep|
  depends dep
end

source_url 'https://github.com/sous-chefs/nginx_simplecgi'
issues_url 'https://github.com/sous-chefs/nginx_simplecgi/issues'
chef_version '>= 12.19'

name             'nginx_simplecgi'
maintainer       'Tim Smith'
maintainer_email 'tsmith@chef.io'
license          'Apache-2.0'
description      'Provides SimpleCGI for NGINX'
version          '0.2.0'

%w( debian ubuntu redhat centos fedora scientific amazon oracle ).each do |os|
  supports os
end

%w( chef_nginx perl runit yum-epel ).each do |dep|
  depends dep
end

source_url 'https://github.com/tas50/nginx_simplecgi'
issues_url 'https://github.com/tas50/nginx_simplecgi/issues'
chef_version '>= 12.1'

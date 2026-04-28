# frozen_string_literal: true

nginx_simplecgi_cgi_dispatcher 'default' do
  nginx_user 'www-data' if platform_family?('debian')
  nginx_group 'www-data' if platform_family?('debian')
  nginx_user 'nginx' if platform_family?('rhel', 'fedora', 'amazon')
  nginx_group 'nginx' if platform_family?('rhel', 'fedora', 'amazon')
end

nginx_simplecgi_php_dispatcher 'default' do
  nginx_user 'www-data' if platform_family?('debian')
  nginx_group 'www-data' if platform_family?('debian')
  nginx_user 'nginx' if platform_family?('rhel', 'fedora', 'amazon')
  nginx_group 'nginx' if platform_family?('rhel', 'fedora', 'amazon')
end

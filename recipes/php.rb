package 'php5-cgi'

template '/usr/local/bin/phpwrap_dispatcher' do
  source 'phpwrap-dispatcher.erb'
  variables(
    :dispatch_dir => node[:nginx_simplecgi][:dispatcher_directory],
    :dispatch_procs => node[:nginx_simplecgi][:dispatcher_processes],
    :php_cgi_bin => node[:nginx_simplecgi][:php_cgi_bin]
  )
  mode '0755'
end

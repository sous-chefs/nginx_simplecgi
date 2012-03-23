package 'libfcgi-perl'
package 'libfcgi-procmanager-perl'

directory '/var/run/nginx' do
  action :create
  recursive true
  owner node[:nginx][:user]
  group node[:nginx][:group] || node[:nginx][:user]
end

template '/usr/local/bin/cgiwrap_dispatcher' do
  source 'cgiwrap-dispatcher.erb'
  variables(
    :dispatch_dir => node[:nginx_simplecgi][:dispatcher_directory],
    :dispatch_procs => node[:nginx_simplecgi][:dispatcher_processes]
  )
  mode '0755'
end

template '/etc/init/nginx_cgiwrap_dispatcher.conf' do
  source 'upstart-cgiwrap_dispatcher.erb'
  variables(
    :dispatch_dir => node[:nginx_simplecgi][:dispatcher_directory],
    :nginx_user => node[:nginx][:user],
    :nginx_group => node[:nginx][:group] || node[:nginx][:user]
  )
end

service "nginx_cgiwrap_dispatcher" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

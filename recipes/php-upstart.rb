
template '/etc/init/nginx_phpwrap_dispatcher.conf' do
  source 'upstart-phpwrap_dispatcher.erb'
  variables(
    :dispatch_dir => node[:nginx_simplecgi][:dispatcher_directory],
    :nginx_user => node[:nginx][:user],
    :nginx_group => node[:nginx][:group] || node[:nginx][:user]
  )
end

service "nginx_phpwrap_dispatcher" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

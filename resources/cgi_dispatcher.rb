# frozen_string_literal: true

provides :nginx_simplecgi_cgi_dispatcher
unified_mode true

use '_partial/_dispatcher'

property :instance, String, name_property: true

default_action :create

action_class do
  include NginxSimplecgi::Helpers
end

action :create do
  yum_epel 'default' if platform_family?('rhel')

  package dispatcher_packages

  group new_resource.nginx_group do
    system true
    only_if { platform_family?('rhel', 'fedora', 'amazon') }
  end

  user new_resource.nginx_user do
    gid new_resource.nginx_group
    system true
    manage_home false
    only_if { platform_family?('rhel', 'fedora', 'amazon') }
  end

  directory new_resource.dispatcher_directory do
    owner new_resource.nginx_user
    group new_resource.nginx_group
    mode '0755'
    recursive true
  end

  template dispatcher_script('cgi') do
    source 'cgiwrap-dispatcher.erb'
    cookbook 'nginx_simplecgi'
    variables(
      dispatch_dir: new_resource.dispatcher_directory,
      dispatch_procs: new_resource.dispatcher_processes
    )
    owner 'root'
    group 'root'
    mode '0755'
  end

  systemd_unit dispatcher_unit_name('cgi') do
    content cgi_systemd_unit
    action [:create, :enable, :start]
  end
end

action :delete do
  systemd_unit dispatcher_unit_name('cgi') do
    action [:stop, :disable, :delete]
  end

  file dispatcher_script('cgi') do
    action :delete
  end
end

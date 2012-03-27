# Basic setups
#
pkgs = value_for_platform(
  %w(redhat centos fedora scientific) => {
    "default" => %w(perl-FCGI perl-FCGI-ProcManager)
  },
  %w(debian ubuntu) => {
    "default" => %w(libfcgi-perl libfcgi-procmanager-perl)
  },
  "default" => %w(libfcgi-perl libfcgi-procmanager-perl)
)

pkgs.each do |package_name|
  package package_name
end

directory node[:nginx_simplecgi][:dispatcher_directory] do
  action :create
  recursive true
  owner node[:nginx][:user]
  group node[:nginx][:group] || node[:nginx][:user]
end

# Setup our dispatchers
include_recipe 'nginx_simplecgi::cgi' if node[:nginx_simplecgi][:cgi]
include_recipe 'nginx_simplecgi::php' if node[:nginx_simplecgi][:php]

# Setup our init

case node[:nginx_simplecgi][:init_type].to_sym
when :upstart
  include_recipe 'nginx_simplecgi::cgi-upstart' if node[:nginx_simplecgi][:cgi]
  include_recipe 'nginx_simplecgi::php-upstart' if node[:nginx_simplecgi][:php]
else
  raise "Not Implemented: #{node[:nginx_simplecgi][:init_type]}"
end


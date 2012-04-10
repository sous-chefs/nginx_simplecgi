# Basic setups
#
pkgs = value_for_platform(
  %w(redhat centos fedora scientific) => {
    %w(5.0 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8) => %w(fcgi-perl),
    "default" => %w(perl-FCGI perl-FCGI-ProcManager)
  },
  "default" => %w(libfcgi-perl libfcgi-procmanager-perl spawn-fcgi)
)

pkgs.each do |package_name|
  package package_name
end

if(pkgs.include?('fcgi-perl'))
  include_recipe 'perl'
  cpan_module 'FCGI::ProcManager'
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
  include_recipe 'nginx_simplecgi::upstart'
when :runit
  include_recipe 'nginx_simplecgi::runit'
when :bluepill
  include_recipe 'nginx_simplecgi::bluepill'
else
  raise "Not Implemented: #{node[:nginx_simplecgi][:init_type]}"
end


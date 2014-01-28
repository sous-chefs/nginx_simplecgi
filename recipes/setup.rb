# Basic setups
#
pkgs = value_for_platform(
  %w(redhat centos fedora scientific) => {
    %w(5.0 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8) => %w(fcgi-perl spawn-fcgi),
    "default" => %w(perl-FCGI perl-FCGI-ProcManager spawn-fcgi)
  },
  "default" => %w(libfcgi-perl libfcgi-procmanager-perl spawn-fcgi)
)

if(platform?(*%w(redhat centos fedora scientific)))
  begin
    include_recipe 'yum::epel'
  rescue
    yum_repository 'epel' do
      description 'Extra Packages for Enterprise Linux'
      mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
      gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
      action :create
    end
  end
  if(node[:nginx_simplecgi][:init_type].to_sym == :upstart)
    node.set[:nginx_simplecgi][:init_type] = 'init'
  end
end

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
when :init
  include_recipe 'nginx_simplecgi::init'
else
  raise "Not Implemented: #{node[:nginx_simplecgi][:init_type]}"
end


#
# Cookbook:: nginx_simplecgi
# Recipe:: setup
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Basic setups
#

pkgs = if platform_family?('rhel', 'fedora', 'amazon')
         %w(perl-FCGI perl-FCGI-ProcManager spawn-fcgi)
       else
         %w(libfcgi-perl libfcgi-procmanager-perl spawn-fcgi)
       end

if platform_family?('rhel')
  include_recipe 'yum-epel'
  if node['nginx_simplecgi']['init_type'].to_sym == :upstart
    node.override['nginx_simplecgi']['init_type'] = 'init'
  end
end

package pkgs

if pkgs.include?('fcgi-perl')
  include_recipe 'perl'
  cpan_module 'FCGI::ProcManager'
end

directory node['nginx_simplecgi']['dispatcher_directory'] do
  action :create
  recursive true
  owner node['nginx']['user']
  group node['nginx']['group'] || node['nginx']['user']
end

# Setup our dispatchers
include_recipe 'nginx_simplecgi::cgi' if node['nginx_simplecgi']['cgi']
include_recipe 'nginx_simplecgi::php' if node['nginx_simplecgi']['php']

# Setup our init
case node['nginx_simplecgi']['init_type'].to_sym
when :upstart
  include_recipe 'nginx_simplecgi::upstart'
when :runit
  include_recipe 'nginx_simplecgi::runit'
when :init
  include_recipe 'nginx_simplecgi::init'
else
  raise "Not Implemented: #{node['nginx_simplecgi']['init_type']}"
end

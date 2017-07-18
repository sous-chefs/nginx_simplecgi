#
# Cookbook:: nginx_simplecgi
# Recipe:: php
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

pkgs = value_for_platform(
  %w(redhat centos fedora scientific amazon) => {
    'default' => %w(php),
  },
  %w(debian ubuntu) => {
    'default' => %w(php5-cgi),
  },
  'default' => %w(php5-cgi)
)

package pkgs

template '/usr/local/bin/phpwrap_dispatcher' do
  source 'phpwrap-dispatcher.erb'
  variables(
    nginx_user: node['nginx']['user'],
    nginx_group: node['nginx']['group'] || node['nginx']['user'],
    dispatch_dir: node['nginx_simplecgi']['dispatcher_directory'],
    dispatch_procs: node['nginx_simplecgi']['dispatcher_processes'],
    php_cgi_bin: node['nginx_simplecgi']['php_cgi_bin']
  )
  mode '0755'
end

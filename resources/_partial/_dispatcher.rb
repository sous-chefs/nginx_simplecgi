# frozen_string_literal: true

property :dispatcher_directory, String, default: '/var/run/nginx'
property :dispatcher_processes, Integer, default: 4
property :nginx_user, String, default: lazy { node['nginx']['user'] || 'www-data' }
property :nginx_group, String, default: lazy { node['nginx']['group'] || node['nginx']['user'] || 'www-data' }

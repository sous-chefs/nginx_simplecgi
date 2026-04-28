# Migration Guide

## From Recipes and Attributes to Resources

This release removes the legacy `recipes/` and `attributes/` interface. Consumers should declare the custom resources directly.

Before:

```ruby
node.default['nginx_simplecgi']['cgi'] = true
node.default['nginx_simplecgi']['php'] = true
node.default['nginx_simplecgi']['dispatcher_directory'] = '/var/run/nginx'
node.default['nginx_simplecgi']['dispatcher_processes'] = 4
node.default['nginx_simplecgi']['init_type'] = :runit

include_recipe 'nginx_simplecgi::default'
```

After:

```ruby
nginx_simplecgi_cgi_dispatcher 'default' do
  dispatcher_directory '/var/run/nginx'
  dispatcher_processes 4
  nginx_user 'www-data'
  nginx_group 'www-data'
end

nginx_simplecgi_php_dispatcher 'default' do
  dispatcher_directory '/var/run/nginx'
  dispatcher_processes 4
  php_cgi_bin '/usr/bin/php-cgi'
  nginx_user 'www-data'
  nginx_group 'www-data'
end
```

## Service Management

The `init_type` attribute has been removed. Dispatcher services are managed only with `systemd_unit`:

* `cgiwrap_dispatcher.service`
* `phpwrap_dispatcher.service`

SysV init, runit, and upstart templates are no longer shipped.

## Template Helper

The `nginx_dispatch` ERB helper remains available. If you need a non-default dispatcher directory, pass the dispatcher explicitly:

```ruby
<%= nginx_dispatch(:cgi, dispatcher: 'unix:/run/nginx/cgiwrap-dispatch.sock') %>
```

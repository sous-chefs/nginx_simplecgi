# nginx_simplecgi_php_dispatcher

Installs FastCGI and PHP CGI packages, writes `/usr/local/bin/phpwrap_dispatcher`, creates the dispatcher runtime directory, and manages `phpwrap_dispatcher.service` with `systemd_unit`.

## Actions

* `:create` - Install packages, create the wrapper script, and enable/start the systemd unit.
* `:delete` - Stop, disable, and delete the systemd unit and wrapper script.

## Properties

* `dispatcher_directory` - Runtime directory for socket and PID files. Default: `/var/run/nginx`.
* `dispatcher_processes` - Number of dispatcher workers. Default: `4`.
* `nginx_user` - User that owns the runtime directory and runs spawned PHP CGI children. Default: `node['nginx']['user']` or `www-data`.
* `nginx_group` - Group that owns the runtime directory and runs spawned PHP CGI children. Default: `node['nginx']['group']`, `node['nginx']['user']`, or `www-data`.
* `php_cgi_bin` - PHP CGI executable path. Default: `/usr/bin/php-cgi`.

## Example

```ruby
nginx_simplecgi_php_dispatcher 'default' do
  dispatcher_directory '/run/nginx'
  dispatcher_processes 4
  php_cgi_bin '/usr/bin/php-cgi'
  nginx_user 'www-data'
  nginx_group 'www-data'
end
```

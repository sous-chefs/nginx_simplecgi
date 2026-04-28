# nginx_simplecgi_cgi_dispatcher

Installs the Perl FastCGI packages, writes `/usr/local/bin/cgiwrap_dispatcher`, creates the dispatcher runtime directory, and manages `cgiwrap_dispatcher.service` with `systemd_unit`.

## Actions

* `:create` - Install packages, create the wrapper script, and enable/start the systemd unit.
* `:delete` - Stop, disable, and delete the systemd unit and wrapper script.

## Properties

* `dispatcher_directory` - Runtime directory for socket and PID files. Default: `/var/run/nginx`.
* `dispatcher_processes` - Number of dispatcher workers. Default: `4`.
* `nginx_user` - User that owns the runtime directory and runs the CGI dispatcher. Default: `node['nginx']['user']` or `www-data`.
* `nginx_group` - Group that owns the runtime directory and runs the CGI dispatcher. Default: `node['nginx']['group']`, `node['nginx']['user']`, or `www-data`.

## Example

```ruby
nginx_simplecgi_cgi_dispatcher 'default' do
  dispatcher_directory '/run/nginx'
  dispatcher_processes 4
  nginx_user 'www-data'
  nginx_group 'www-data'
end
```

node[:nginx_simplecgi] = Mash.new
# Enable CGI dispatcher
node[:nginx_simplecgi][:cgi] = true
# Enable PHP dispatcher
node[:nginx_simplecgi][:php] = false
# Directory to contain dispatcher socket and pid file
node[:nginx_simplecgi][:dispatcher_directory] = '/var/run/nginx'
# Number of dispatcher process to handle requests
node[:nginx_simplecgi][:dispatcher_processes] = 4
# Location of PHP CGI executable
node[:nginx_simplecgi][:php_cgi_bin] = '/usr/bin/php-cgi'
# Type of init (:upstart, :runit, :bluepill, :monit)
node[:nginx_simplecgi][:init_type] = :upstart

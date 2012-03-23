node[:nginx_simplecgi] = Mash.new
# Directory to contain dispatcher socket and pid file
node[:nginx_simplecgi][:dispatcher_directory] = '/var/run/nginx'
# Number of dispatcher process to handle requests
node[:nginx_simplecgi][:dispatcher_processes] = 4

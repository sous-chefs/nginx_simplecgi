# frozen_string_literal: true

module NginxSimplecgi
  module Helpers
    def nginx_dispatch(type = :cgi, args = {})
      args = {
        pattern: type == :php ? '.php$' : '^/cgi-bin/.*\.cgi$',
        cgi_bin_dir: '/usr/lib',
        docroot: '/var/www',
        dispatcher: "unix:#{File.join(args.fetch(:dispatcher_directory, '/var/run/nginx'), "#{type}wrap-dispatch.sock")}",
      }.merge(args)

      %(
  location ~ #{args[:pattern]} {
    gzip off;
    fastcgi_pass  #{args[:dispatcher]};
    fastcgi_index index.#{type};
    #{if type == :cgi
        "fastcgi_param SCRIPT_FILENAME #{args[:cgi_bin_dir]}$fastcgi_script_name;"
      else
        "fastcgi_param SCRIPT_FILENAME #{args[:docroot]}$fastcgi_script_name;"
      end}
    fastcgi_param QUERY_STRING     $query_string;
    fastcgi_param REQUEST_METHOD   $request_method;
    fastcgi_param CONTENT_TYPE     $content_type;
    fastcgi_param CONTENT_LENGTH   $content_length;
    fastcgi_param GATEWAY_INTERFACE  CGI/1.1;
    fastcgi_param SERVER_SOFTWARE    nginx;
    fastcgi_param SCRIPT_NAME        $fastcgi_script_name;
    fastcgi_param REQUEST_URI        $request_uri;
    fastcgi_param DOCUMENT_URI       $document_uri;
    fastcgi_param DOCUMENT_ROOT      $document_root;
    fastcgi_param SERVER_PROTOCOL    $server_protocol;
    fastcgi_param REMOTE_ADDR        $remote_addr;
    fastcgi_param REMOTE_PORT        $remote_port;
    fastcgi_param SERVER_ADDR        $server_addr;
    fastcgi_param SERVER_PORT        $server_port;
    fastcgi_param SERVER_NAME        $server_name;
    #{'fastcgi_param REDIRECT_STATUS        200;' if type == :php}
    #{args[:custom]}
    #{yield.to_s if block_given?}
  }
      )
    end

    def dispatcher_packages
      if platform_family?('rhel', 'fedora', 'amazon')
        %w(perl-FCGI perl-FCGI-ProcManager spawn-fcgi)
      else
        %w(libfcgi-perl libfcgi-procmanager-perl spawn-fcgi)
      end
    end

    def php_packages
      if platform_family?('rhel', 'fedora', 'amazon')
        %w(php)
      else
        %w(php-cgi)
      end
    end

    def dispatcher_script(kind)
      "/usr/local/bin/#{kind}wrap_dispatcher"
    end

    def dispatcher_socket(kind)
      File.join(new_resource.dispatcher_directory, "#{kind}wrap-dispatch.sock")
    end

    def dispatcher_pid_file(kind)
      File.join(new_resource.dispatcher_directory, "#{kind}wrap_dispatcher.pid")
    end

    def dispatcher_unit_name(kind)
      "#{kind}wrap_dispatcher.service"
    end

    def cgi_systemd_unit
      {
        Unit: {
          Description: 'NGINX SimpleCGI CGI Wrapper Dispatcher',
          After: 'network.target',
        },
        Service: {
          Type: 'forking',
          User: new_resource.nginx_user,
          Group: new_resource.nginx_group,
          ExecStart: dispatcher_script('cgi'),
          PIDFile: dispatcher_pid_file('cgi'),
          Restart: 'on-failure',
        },
        Install: {
          WantedBy: 'multi-user.target',
        },
      }
    end

    def php_systemd_unit
      {
        Unit: {
          Description: 'NGINX SimpleCGI PHP Wrapper Dispatcher',
          After: 'network.target',
        },
        Service: {
          Type: 'forking',
          ExecStart: dispatcher_script('php'),
          PIDFile: dispatcher_pid_file('php'),
          Restart: 'on-failure',
        },
        Install: {
          WantedBy: 'multi-user.target',
        },
      }
    end
  end
end

::Erubis::Context.include NginxSimplecgi::Helpers

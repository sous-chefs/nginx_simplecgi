# nginx_simplecgi cookbook

[![Build Status](https://travis-ci.org/tas50/nginx_simplecgi.svg?branch=master)](https://travis-ci.org/tas50/nginx_simplecgi)
[![Cookbook Version](https://img.shields.io/cookbook/v/nginx_simplecgi.svg)](https://supermarket.chef.io/cookbooks/nginx_simplecgi)

This cookbook provides CGI support for NGINX via SimpleCGI.

## Requirements

### Platforms

- Debian/ Ubuntu
- RHEL based platforms (CentOS, Redhat, etc)

### Chef

- Chef 12.1+

### Cookbooks

- chef_nginx
- perl
- runit
- yum-epel

# Usage

## Attributes

- `node['nginx_simplecgi']['cgi'] -> Enable CGI dispatch`
- `node['nginx_simplecgi']['php'] -> Enable PHP dispatch`
- `node['nginx_simplecgi']['php_cgi_bin'] -> PHP executable path for CGI`
- `node['nginx_simplecgi']['init_type'] -> Init style for dispatchers`
- `node['nginx_simplecgi']['dispatcher_directory'] -> Directory to contain socket and pid files`
- `node['nginx_simplecgi']['dispatcher_processes'] -> Number of dispatcher processes for handling requests`

## Template Helper

A template method helper, `dispatch` is provided to add the require location block into your nginx configuration files:

```ruby
<%= nginx_dispatch(:cgi) %>
```

The default call will output:

```
  location ~ ^/cgi-bin/.*\.cgi$ {
    gzip off;
    fastcgi_pass  unix:/var/run/nginx/cgiwrap-dispatch.sock;
    fastcgi_index index.cgi;
    fastcgi_param SCRIPT_FILENAME /usr/lib$fastcgi_script_name;
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
  }
```

Available options:

- `:pattern -> change the pattern nginx matches`
- `:cgi_bin_dir -> change the prefix directory of the local cgi-bin`
- `:dispatcher -> use a custom dispatcher (socket or tcp based)`
- `:custom -> string to be appended within the location block`

The method will also accept a block that will be eval'd and the result appended within the location block.

## License and Author

Author:: Chris Roberts ([chrisroberts.code@gmail.com](mailto:chrisroberts.code@gmail.com))

Copyright:: Chris Roberts

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```


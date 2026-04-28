# frozen_string_literal: true

require 'spec_helper'

describe NginxSimplecgi::Helpers do
  subject(:helper) do
    Class.new do
      include NginxSimplecgi::Helpers
    end.new
  end

  describe '#nginx_dispatch' do
    it 'renders CGI dispatch configuration' do
      expect(helper.nginx_dispatch(:cgi)).to include('fastcgi_pass  unix:/var/run/nginx/cgiwrap-dispatch.sock;')
      expect(helper.nginx_dispatch(:cgi)).to include('fastcgi_index index.cgi;')
    end

    it 'renders PHP dispatch configuration' do
      expect(helper.nginx_dispatch(:php)).to include('fastcgi_pass  unix:/var/run/nginx/phpwrap-dispatch.sock;')
      expect(helper.nginx_dispatch(:php)).to include('fastcgi_param REDIRECT_STATUS        200;')
    end
  end
end

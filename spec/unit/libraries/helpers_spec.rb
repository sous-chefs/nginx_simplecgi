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

  describe '#dispatcher_packages' do
    it 'uses Debian package names without spawn-fcgi' do
      allow(helper).to receive(:platform_family?).with('rhel', 'fedora', 'amazon').and_return(false)

      expect(helper.dispatcher_packages).to eq(%w(libfcgi-perl libfcgi-procmanager-perl))
    end

    it 'uses RHEL package names without spawn-fcgi' do
      allow(helper).to receive(:platform_family?).with('rhel', 'fedora', 'amazon').and_return(true)

      expect(helper.dispatcher_packages).to eq(%w(perl-FCGI perl-FCGI-ProcManager))
    end
  end

  describe '#spawn_fcgi_available?' do
    it 'is unavailable on RHEL family 9 and newer' do
      allow(helper).to receive(:platform_family?).with('rhel').and_return(true)
      allow(helper).to receive(:node).and_return({ 'platform_version' => '9.1' })

      expect(helper.spawn_fcgi_available?).to be(false)
    end

    it 'is available outside RHEL family' do
      allow(helper).to receive(:platform_family?).with('rhel').and_return(false)

      expect(helper.spawn_fcgi_available?).to be(true)
    end
  end
end

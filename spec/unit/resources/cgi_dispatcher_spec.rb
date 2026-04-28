# frozen_string_literal: true

require 'spec_helper'

describe 'nginx_simplecgi_cgi_dispatcher' do
  step_into :nginx_simplecgi_cgi_dispatcher
  platform 'ubuntu', '24.04'

  context 'with default properties' do
    recipe do
      nginx_simplecgi_cgi_dispatcher 'default' do
        nginx_user 'www-data'
        nginx_group 'www-data'
      end
    end

    it { is_expected.to install_package(%w(libfcgi-perl libfcgi-procmanager-perl)) }

    it do
      is_expected.to create_directory('/var/run/nginx').with(
        owner: 'www-data',
        group: 'www-data',
        mode: '0755'
      )
    end

    it do
      is_expected.to create_template('/usr/local/bin/cgiwrap_dispatcher').with(
        source: 'cgiwrap-dispatcher.erb',
        cookbook: 'nginx_simplecgi',
        mode: '0755'
      )
    end

    it { is_expected.to create_systemd_unit('cgiwrap_dispatcher.service') }
    it { is_expected.to enable_systemd_unit('cgiwrap_dispatcher.service') }
    it { is_expected.to start_systemd_unit('cgiwrap_dispatcher.service') }
  end

  context 'with custom properties' do
    recipe do
      nginx_simplecgi_cgi_dispatcher 'custom' do
        dispatcher_directory '/run/custom-nginx'
        dispatcher_processes 8
        nginx_user 'nginx'
        nginx_group 'nginx'
      end
    end

    it do
      is_expected.to create_systemd_unit('cgiwrap_dispatcher.service').with(
        content: hash_including(
          Service: hash_including(
            User: 'nginx',
            Group: 'nginx',
            PIDFile: '/run/custom-nginx/cgiwrap_dispatcher.pid'
          )
        )
      )
    end
  end

  context 'action :delete' do
    recipe do
      nginx_simplecgi_cgi_dispatcher 'default' do
        action :delete
      end
    end

    it { is_expected.to stop_systemd_unit('cgiwrap_dispatcher.service') }
    it { is_expected.to disable_systemd_unit('cgiwrap_dispatcher.service') }
    it { is_expected.to delete_systemd_unit('cgiwrap_dispatcher.service') }
    it { is_expected.to delete_file('/usr/local/bin/cgiwrap_dispatcher') }
  end
end

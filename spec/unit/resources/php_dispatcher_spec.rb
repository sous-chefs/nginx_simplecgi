# frozen_string_literal: true

require 'spec_helper'

describe 'nginx_simplecgi_php_dispatcher' do
  step_into :nginx_simplecgi_php_dispatcher
  platform 'ubuntu', '24.04'

  context 'with default properties' do
    recipe do
      nginx_simplecgi_php_dispatcher 'default' do
        nginx_user 'www-data'
        nginx_group 'www-data'
      end
    end

    it { is_expected.to install_package(%w(libfcgi-perl libfcgi-procmanager-perl spawn-fcgi)) }
    it { is_expected.to install_package(%w(php-cgi)) }

    it do
      is_expected.to create_template('/usr/local/bin/phpwrap_dispatcher').with(
        source: 'phpwrap-dispatcher.erb',
        cookbook: 'nginx_simplecgi',
        mode: '0755'
      )
    end

    it { is_expected.to create_systemd_unit('phpwrap_dispatcher.service') }
    it { is_expected.to enable_systemd_unit('phpwrap_dispatcher.service') }
    it { is_expected.to start_systemd_unit('phpwrap_dispatcher.service') }
  end

  context 'with custom properties' do
    recipe do
      nginx_simplecgi_php_dispatcher 'custom' do
        dispatcher_directory '/run/custom-nginx'
        dispatcher_processes 8
        nginx_user 'nginx'
        nginx_group 'nginx'
        php_cgi_bin '/usr/local/bin/php-cgi'
      end
    end

    it do
      is_expected.to create_systemd_unit('phpwrap_dispatcher.service').with(
        content: hash_including(
          Service: hash_including(
            ExecStart: '/usr/local/bin/phpwrap_dispatcher',
            PIDFile: '/run/custom-nginx/phpwrap_dispatcher.pid'
          )
        )
      )
    end
  end

  context 'on fedora family' do
    platform 'fedora', '32'

    recipe do
      nginx_simplecgi_php_dispatcher 'default' do
        nginx_user 'nginx'
        nginx_group 'nginx'
      end
    end

    it { is_expected.to install_package(%w(perl-FCGI perl-FCGI-ProcManager spawn-fcgi)) }
    it { is_expected.to install_package(%w(php)) }
  end

  context 'action :delete' do
    recipe do
      nginx_simplecgi_php_dispatcher 'default' do
        action :delete
      end
    end

    it { is_expected.to stop_systemd_unit('phpwrap_dispatcher.service') }
    it { is_expected.to disable_systemd_unit('phpwrap_dispatcher.service') }
    it { is_expected.to delete_systemd_unit('phpwrap_dispatcher.service') }
    it { is_expected.to delete_file('/usr/local/bin/phpwrap_dispatcher') }
  end
end

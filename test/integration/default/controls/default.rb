# frozen_string_literal: true

control 'nginx-simplecgi-dispatchers' do
  impact 1.0
  title 'NGINX SimpleCGI dispatchers are installed'

  describe file('/usr/local/bin/cgiwrap_dispatcher') do
    it { should exist }
    it { should be_executable }
  end

  describe systemd_service('cgiwrap_dispatcher') do
    it { should be_installed }
    it { should be_enabled }
  end

  unless os.redhat? && os.release.to_i >= 9
    describe file('/usr/local/bin/phpwrap_dispatcher') do
      it { should exist }
      it { should be_executable }
    end

    describe systemd_service('phpwrap_dispatcher') do
      it { should be_installed }
      it { should be_enabled }
    end
  end
end

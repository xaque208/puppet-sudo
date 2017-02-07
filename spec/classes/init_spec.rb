require 'spec_helper'
describe 'sudo' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('sudo') }

      case facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_package('sudo') }
        it { is_expected.to contain_concat__fragment('sudoers-header').with_content(%r{^root\s+ALL=\(ALL\)\s+ALL$}) }
        it { is_expected.to contain_concat('/etc/sudoers.tmp').with_mode('0440') }
        it { is_expected.to contain_exec('check-sudoers').with_command('/usr/sbin/visudo -cf /etc/sudoers.tmp && cp /etc/sudoers.tmp /etc/sudoers') }
        it { is_expected.to contain_file('/etc/sudoers').with_mode('0440') }
      when 'CentOS'
        it { is_expected.to contain_package('sudo') }
        it { is_expected.to contain_concat__fragment('sudoers-header').with_content(%r{^root\s+ALL=\(ALL\)\s+ALL$}) }
        it do
          is_expected.to contain_concat('/etc/sudoers.tmp').with(
            mode: '0440',
            content: %r{Defaults\ssecure_path\s=\s.*%}
          )
        end
        it { is_expected.to contain_exec('check-sudoers').with_command('/usr/sbin/visudo -cf /etc/sudoers.tmp && cp /etc/sudoers.tmp /etc/sudoers') }
        it { is_expected.to contain_file('/etc/sudoers').with_mode('0440') }
      when 'FreeBSD'
        it { is_expected.to contain_package('security/sudo') }
        it { is_expected.to contain_concat__fragment('sudoers-header').with_content(%r{^root\s+ALL=\(ALL\)\s+ALL$}) }
        it { is_expected.to contain_concat('/usr/local/etc/sudoers.tmp').with_mode('0440') }
        it { is_expected.to contain_exec('check-sudoers').with_command('/usr/local/sbin/visudo -cf /usr/local/etc/sudoers.tmp && cp /usr/local/etc/sudoers.tmp /usr/local/etc/sudoers') }
        it { is_expected.to contain_file('/usr/local/etc/sudoers').with_mode('0440') }
        it { is_expected.not_to contain_concat('/usr/local/etc/sudoers.tmp').with_content(%r{Defaults\ssecure_path\s=\s.*%}) }
      when 'OpenBSD'
        it { is_expected.to contain_package('sudo') }
        it { is_expected.to contain_concat__fragment('sudoers-header').with_content(%r{^root\s+ALL=\(ALL\)\s+ALL$}) }
        it { is_expected.to contain_concat('/etc/sudoers.tmp').with_mode('0440') }
        it { is_expected.to contain_exec('check-sudoers').with_command('/usr/local/sbin/visudo -cf /etc/sudoers.tmp && cp /etc/sudoers.tmp /etc/sudoers') }
        it { is_expected.to contain_file('/etc/sudoers').with_mode('0440') }
      end
    end
  end

  context 'with values for all required parameters' do
    let(:params) do
      {
        cmd: '/usr/local/bin/sudo',
        package_name: 'security/sudo',
        visudo_cmd: '/usr/local/sbin/visudo',
        sudoers_file: '/usr/local/etc/sudoers',
        sudoers_tmp: '/usr/local/etc/sudoers.tmp'
      }
    end
    it { is_expected.to contain_class('sudo') }
    it { is_expected.to contain_package('security/sudo') }
    it { is_expected.to contain_concat__fragment('sudoers-header').with_content(%r{^root\s+ALL=\(ALL\)\s+ALL$}) }
    it { is_expected.to contain_concat('/usr/local/etc/sudoers.tmp').with_mode('0440') }
    it { is_expected.to contain_exec('check-sudoers').with_command('/usr/local/sbin/visudo -cf /usr/local/etc/sudoers.tmp && cp /usr/local/etc/sudoers.tmp /usr/local/etc/sudoers') }
    it { is_expected.to contain_file('/usr/local/etc/sudoers').with_mode('0440') }
  end
end

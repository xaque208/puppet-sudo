require 'spec_helper'
describe 'sudo' do

  context 'with values for all required parameters' do
    let(:params) {{
      :package_name => 'security/sudo',
      :visudo_cmd => '/usr/local/sbin/visudo',
      :sudoers_file => '/usr/local/etc/sudoers',
      :sudoers_tmp => '/usr/local/etc/sudoers.tmp',
    }}
    it { should contain_class('sudo') }
    it { should contain_package('security/sudo') }
    it { should contain_concat__fragment('sudoers-header').with_content(/^root\s+ALL=\(ALL\)\s+ALL$/) }
    it { should contain_concat('/usr/local/etc/sudoers.tmp').with_mode('0440') }
    it { should contain_exec('check-sudoers').with_command('/usr/local/sbin/visudo -cf /usr/local/etc/sudoers.tmp && cp /usr/local/etc/sudoers.tmp /usr/local/etc/sudoers') }
    it { should contain_file('/usr/local/etc/sudoers').with_mode('0440') }
  end
end

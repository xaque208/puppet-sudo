# This class handles the deployment of the sudoers(5) file and the installation
# of sudo(8) if necessary.
#
# @param visudo_cmd The full path to the visudo(8) command validate content
# @param sudoers_file The full path to the sudoers(5) file
# @param sudoers_tmp The full path to a temporary sudoers file
# @param package_name The name of the package containing the sudo(8) binary
# @param requiretty Boolean value for sudoers(5) option 'requiretty'
# @param visiblepw Boolean value for sudoers(5) option 'visiblepw'
# @param always_set_home Boolean value for sudoers(5) option 'always_set_home'
# @param template String value the template to deploy for sudoers
#
# @example
#   include sudo
#
class sudo (
  String $cmd,
  String $visudo_cmd,
  String $sudoers_file,
  String $sudoers_tmp,
  String $package_name,
  Boolean $requiretty      = false,
  Boolean $visiblepw       = false,
  Boolean $always_set_home = true,
  String $template         = 'sudo/sudoers.erb',
){

  package { $package_name:
    ensure => installed,
    before => Exec['check-sudoers'],
  }

  concat::fragment { 'sudoers-header':
    order   => '00',
    target  => $sudoers_tmp,
    content => template($template),
  }

  concat { $sudoers_tmp:
    mode   => '0440',
    notify => Exec['check-sudoers'],
  }

  exec { 'check-sudoers':
    command => "${visudo_cmd} -cf ${sudoers_tmp} && cp ${sudoers_tmp} ${sudoers_file}",
    unless  => "/usr/bin/diff ${sudoers_tmp} ${sudoers_file}",
  }

  file { $sudoers_file:
    owner => 'root',
    group => '0',
    mode  => '0440',
  }
}

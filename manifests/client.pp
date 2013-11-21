# == Class: sensu::client
#
# Full description of class sensu here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { sensu:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Jonathan Creasy <jonathan.creasy@contegix.com>
#
# === Copyright
#
# Copyright 2013 Contegix LLC, all rights reserved.     
#
class sensu::client(  
  $server_address = 'mgmt-puppet01.contegix.com',
  $subscriptions  = ['monitoring'],
  $client_name    = $fqdn,
  $safe_mode      = false,
) inherits ::sensu {

  $config = "{'client':{
              'address':'${server}',
              'subscriptions':${subscriptions},
              'name':'${client_name}',
              'safe_mode':${safe_mode}
            }}"

  file { '/etc/sensu/conf.d/client.json':
    ensure  => present,
    content => sorted_json($config),
    owner   => 'sensu',
    group   => 'monitoring',
    mode    => '0440',
    require => File['/etc/sensu/conf.d'],
  }
}

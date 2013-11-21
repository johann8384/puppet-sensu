# == Class: sensu::server
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
class sensu::server(
  $redis_server   = 'localhost',
  $redis_port     = '6379',
  $dashboard_host = $fqdn,
  $dashboard_port = 8080,
  $api_host       = $fqdn,
  $api_port       = 4567,
) inherits ::sensu {

  $api_config       = "{'api':{
                        'port':${api_port},
                        'host':'${api_host}'
                      }}"

  $redis_config     = "{'redis':{
                        'host':'${redis_server}',
                        'port':'${redis_port}'
                      }}"

  $dashboard_config = "{'dashboard':{
                        'user':'${dashboard_user}',
                        'password':'${dashboard_password}',
                        'host':'${dashboard_host}',
                        'port':'${redis_port}'
                      }}"

  file { '/etc/sensu/conf.d/api.json':
    ensure  => present,
    content => sorted_json($api_config),
    owner   => 'sensu',
    group   => 'monitoring',
    mode    => '0440',
    require => File['/etc/sensu/conf.d'],
  }

  file { '/etc/sensu/conf.d/redis.json':
    ensure  => present,
    content => sorted_json($redis_config),
    owner   => 'sensu',
    group   => 'monitoring',
    mode    => '0440',
    require => File['/etc/sensu/conf.d'],
  }

  file { '/etc/sensu/conf.d/dasboard.json':
    ensure  => present,
    content => sorted_json($dashboard_config),
    owner   => 'sensu',
    group   => 'monitoring',
    mode    => '0440',
    require => File['/etc/sensu/conf.d'],
  }
}

# == Class: sensu
#
# Full description of class sensu here.
#
# === Examples
#
#  class { sensu: }
#
# === Authors
#
# Jonathan Creasy <jonathan.creasy@contegix.com>
#
# === Copyright
#
# Copyright 2013 Contegix LLC, all rights reserved.
#
class sensu(
  $rabbitmq_host      = 'mgmt-data01.contegix.svc',
  $rabbitmq_port      = 5672,
  $rabbitmq_vhost     = 'sensu',
  $rabbitmq_user      = 'sensu',
  $rabbitmq_password  = 'secret',
) {
  package { 'contegix-sensu':
    ensure  => installed,
  }

  $rabbitmq_config  = "{'rabbitmq':{
                        'host':'${rabbitmq_server}',
                        'port':'${rabbitmq_port}',
                        'vhost':'${rabbitmq_vhost}',
                        'user':'${rabbitmq_user}',
                        'password':'${rabbitmq_password}'
                      }}"

  file { '/etc/sensu':
    ensure  => directory,
    owner   => 'sensu',
    group   => 'monitoring',
    mode    => '0550',
    require => Package['contegix-sensu'],
  }

  file { '/etc/sensu/handlers':
    ensure  => directory,
    owner   => 'sensu',
    group   => 'monitoring',
    mode    => '0550',
    force   => 'true',
    recurse => 'true',
    purge   => 'true',
    source  => 'puppet:///modules/sensu/etc/sensu/handlers',
    require => File['/etc/sensu'],
  }

  file { '/etc/sensu/plugins':
    ensure  => directory,
    owner   => 'sensu',
    group   => 'monitoring',
    mode    => '0550',
    force   => 'true',
    recurse => 'true',
    purge   => 'true',
    source  => 'puppet:///modules/sensu/etc/sensu/plugins',
    require => File['/etc/sensu'],
  }

  file { '/etc/sensu/mutators':
    ensure  => directory,
    owner   => 'sensu',
    group   => 'monitoring',
    mode    => '0550',
    force   => 'true',
    recurse => 'true',
    purge   => 'true',
    source  => 'puppet:///modules/sensu/etc/sensu/mutators',
    require => File['/etc/sensu'],
  }

  file { '/etc/sensu/extensions':
    ensure  => directory,
    owner   => 'sensu',
    group   => 'monitoring',
    mode    => '0550',
    force   => 'true',
    recurse => 'true',
    purge   => 'true',
    source  => 'puppet:///modules/sensu/etc/sensu/extensions',
    require => File['/etc/sensu'],
  }

  file { '/etc/sensu/conf.d':
    ensure  => directory,
    owner   => 'sensu',
    group   => 'monitoring',
    mode    => '0550',
    force   => 'true',
    recurse => 'true',
    purge   => 'true',
    require => File['/etc/sensu'],
  }

  file { '/etc/sensu/config.json':
    ensure  => absent,
  }

  file { '/etc/sensu/conf.d/rabbitmq.json':
    ensure  => present,
    content => sorted_json($rabbitmq_config),
    owner   => 'sensu',
    group   => 'monitoring',
    mode    => '0440',
    require => File['/etc/sensu/conf.d'],
  }
}

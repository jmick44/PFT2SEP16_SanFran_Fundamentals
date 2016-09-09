class nginx (
  $message  = "Puppet is awesome",
  $package,
  $owner,
  $group,
  $docroot  = $nginx::params::docroot,
  $confdir  = $nginx::params::confdir,
  $blockdir = $nginx::params::blockdir,
  $logdir   = $nginx::params::logdir,
  $service  = $nginx::params::service,
  $user     = $nginx::params::user,
) inherits nginx::params {
  notify { "$message": }

  File {
    owner => $owner,
    group => $group,
    mode  => '0664',
  }

  package { $package:
    ensure => present,
  }

  file { $docroot:
    ensure => directory,
    #owner  => 'root',
    #group  => 'root',
    mode   => '0775',
  }

  file { "${docroot}/index.html":
    ensure  => file,
    #owner  => 'root',
    #group  => 'root',
    #mode   => '0664',
    #source => 'puppet:///modules/nginx/index.html',
    content => template('nginx/index.html.erb'),
  }

  file { "${confdir}/nginx.conf":
    ensure  => file,
    #owner   => 'root',
    #group   => 'root',
    #mode    => '0664',
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package[$package],
    # notify  => Service['nginx'],
  }

  file { "${blockdir}/default.conf":
    ensure  => file,
    #owner   => 'root',
    #group   => 'root',
    #mode    => '0664',
    source  => 'puppet:///modules/nginx/default.conf',
    require => Package[$package],
    # notify  => Service['nginx'],
  }

  service { $service:
    ensure    => running,
    enable    => true,
    subscribe => [File["${confdir}/nginx.conf"],File["${blockdir}/default.conf"]]
  }

  file { '/var/www/vhosts':
    ensure => directory,
  }

  nginx::vhost { 'elmo.puppet.com':
    port    => '8080',
    require => File['/var/www/vhosts'],
  }

  nginx::vhost { 'misspiggy.puppet.com':
    port    => '9000',
    require => File['/var/www/vhosts'],
  }
}

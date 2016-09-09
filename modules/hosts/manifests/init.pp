class hosts {
  host { 'testing.puppetlabs.vm':
    ensure => present,
    ip     => '127.0.0.1',
  }

  #  host { 'manage_localhost':
  #  ensure => present,
  #  name   => 'testing.puppetlabs.vm',
  #  ip     => '127.0.0.1',
  #}
}

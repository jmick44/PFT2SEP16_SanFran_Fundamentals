define nginx::vhost (
  $docroot    = "${nginx::docroot}/vhosts/${title}",
  $port       = '80',
  $servername = $title,
) {

  file {  $docroot:
    ensure => directory
  }

  file { "${docroot}/${title}.conf":
    ensure  => file,
    content => "This is a config file for ${servername} that runs on port ${port}",
    require => File[$docroot],
  }
}


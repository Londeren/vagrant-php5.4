class apache 
{      
    file { [ "/etc/apache2", "/etc/apache2/logs"]:
        ensure => "directory",
        mode => 776
    }

    package 
    { 
        "apache2":
            ensure  => present,
            require => [Exec['apt-get update'], Package['php5'], Package['php5-dev'], Package['php5-cli']]
    }    
    
    service 
    { 
        "apache2":
            ensure      => running,
            enable      => true,
            require     => Package['apache2'],
            subscribe   => [
                File["/etc/apache2/mods-enabled/rewrite.load"],
                File["/etc/apache2/sites-available/default"],
                File["/etc/apache2/conf.d/phpmyadmin.conf"]
            ],
    }

    file 
    { 
        "/etc/apache2/mods-enabled/rewrite.load":
            ensure  => link,
            target  => "/etc/apache2/mods-available/rewrite.load",
            require => Package['apache2'],
    }

    file 
    { 
        "/etc/apache2/sites-available/default":
            ensure  => present,
            owner => root, group => root,
            mode   => '0766',
            # source  => "/vagrant/puppet/templates/vhost",
            content => template('apache/vhost.erb'),
            require => Package['apache2'],
    }

    exec 
    { 
        'echo "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn':
            require => Package['apache2'],
    }
}

class cytube (
    String  $install_path,
    String  $install_user,

    String $mysql_database = $cytube::params::mysql_database,
    String $mysql_username = $cytube::params::mysql_username,
    String $mysql_password = $cytube::params::mysql_password,

    Boolean $use_ffmpeg = $cytube::params::use_ffmpeg,
	
	Optional[String] $youtube_api    = $cytube::params::youtube_api,
	Optional[String] $twitch_api     = $cytube::params::twitch_api,
	Optional[String] $mixer_api      = $cytube::params::mixer_api
) inherits cytube::params {
    # Install prerequisites
    ensure_packages(['build-essential'])

    class { 'nodejs':
        repo_url_suffix => '10.x'
    }

    if $use_ffmpeg {
        ensure_packages(['ffmpeg'])
    }

    # Download CyTube from repository
    include git
    vcsrepo { $install_path:
        ensure   => present,
        provider => git,
        source   => 'https://github.com/calzoneman/sync.git',
        revision => '3.0',
        user     => $install_user
    }

    # Install node.js libraries
    nodejs::npm { 'cytube':
        target           => $install_path,
        user             => $install_user,
        home_dir         => "/home/${install_user}/.npm",
        use_package_json => true,
        require          => Vcsrepo[$install_path]
    }

    # Create the config file
    file { "${install_path}/config.yaml":
        content => epp('cytube/config.yaml.epp'),
        require => Vcsrepo[$install_path]
    }
}

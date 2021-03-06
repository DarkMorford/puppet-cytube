# CyTube installer
class cytube (
    String $install_path,
    String $install_user,

    String $site_name,
    String $site_tagline,

    String  $mysql_host,
    Integer $mysql_port,
    String  $mysql_database,
    String  $mysql_username,
    String  $mysql_password,

    Boolean $use_ffmpeg,
    String  $ffprobe_exe,

    Boolean $use_email,

    Optional[String] $youtube_api,
    Optional[String] $twitch_api,
    Optional[String] $mixer_api
) {
    # Install prerequisites
    ensure_packages(['build-essential'])

    class { 'nodejs':
        repo_url_suffix => '10.x'
    }

    if $use_ffmpeg {
        ensure_packages(['ffmpeg'])
    }

    # Prepare SQL database
    mysql::db { $mysql_database:
        user     => $mysql_username,
        password => mysql::password($mysql_password),
        host     => 'localhost',
        grant    => 'ALL'
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
    nodejs::npm { 'cytube-node-deps':
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

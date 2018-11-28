# CyTube default parameters
class cytube::params {
    $mysql_host     = 'localhost'
    $mysql_port     = 3306
    $mysql_database = 'cytube3'
    $mysql_username = 'cytube3'
    $mysql_password = 'cytube3'

    $use_ffmpeg  = false
    $ffprobe_exe = 'ffprobe'

    $youtube_api = undef
    $twitch_api  = undef
    $mixer_api   = undef
}

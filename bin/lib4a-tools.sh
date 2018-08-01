stdout_in_terminal=0
[[ -t 1 ]] && stdout_in_terminal=1
function color {
	[[ $stdout_in_terminal == 0 ]] && return
	for k in $*; do
		case $k in
			bold) tput bold 2>/dev/null;;
			none) tput sgr0 2>/dev/null;;
			*) tput setaf $k 2>/dev/null;;
		esac
	done
}
color_green=$(color bold 2)
color_yellow=$(color bold 3)
color_red=$(color bold 1)
color_blue=$(color bold 4)
color_none=$(color none)

function error() { echo "${color_red}$@${color_none}" >&2; }
function warning() { echo "${color_yellow}$@${color_none}" >&2; }
function info() { echo "${color_green}$@${color_none}" >&2; }
function log() { echo "$@" >&2; }
function debug() { [[ "$DEBUG" == 1 ]] && echo "${color_blue}DEBUG:" "$@" "${color_none}" >&2; }

function 4a-client() {
	# get port for audio service
	local port=""
	local token="HELLO"
	local unitfile=$( ls /var/local/lib/systemd/system/afm-service-agl-service-audio-4a*.service )

	if [ -f "$unitfile" ]; then
		log "Detected systemd unit file!"
		port=$( grep -sr X-AFM-http /var/local/lib/systemd/system/afm-service-agl-service-audio-4a*.service | cut -f2 -d'=' )
		log "Port detected: $port"
	else
		log "No systemd unit file detected, assuming running on host, please set 'API_4A_PORT' and 'API_4A_TOKEN' environment variables to correct values!"
		port=${API_4A_PORT:-1234}
		token=${API_4A_TOKEN:-"HELLO"}
		log "Port: $port, token: $token"
	fi

	afb-client-demo -H "localhost:$port/api?token=$token&uuid=magic" "$@"
}

function 4a-roles() {
	4a-client ahl-4a get_roles "" | tail -n +2 | jq '.response|.[]'
}

function mediascanner-client() {
	afb-client-demo -H -d unix:/run/user/0/apis/ws/mediascanner "$@"
}
function mediaplayer-client() {
	afb-client-demo -H -d unix:/run/user/0/apis/ws/mediaplayer "$@"
}



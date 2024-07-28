#!/usr/bin/env bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
DOCKER_CONT_NAME=$(basename -s .git `git config --get remote.origin.url`)
DOCKER_CONT_NAME=$(echo "$DOCKER_CONT_NAME" | tr '[:upper:]' '[:lower:]')
echo "DOCKER_CONT_NAME $DOCKER_CONT_NAME"
script_dir=$(dirname "$(readlink -f "$0")")
echo "script_dir $script_dir"
Shell=
Build=
Remove=
function usage()
{
  echo "-s shell into the dev env"
  echo "-b build application in dev env"
  echo "-c clean dev env and remove"
  echo "Usage:"
  echo "sudo ./$script_name -s -t=arm -v=<path> -b -r"
  echo
	exit 0
}

# Parse options
for opt in $*; do
	case "$opt" in
		-h)
			usage
			;;
        -s)
            Shell=true
            ;;
        -b)
            Build=true
            ;;
        -c)
            Remove=true
            ;;
		*)
			usage
			;;
	esac
done

if docker ps --format '{{.Names}}' | grep -q "^${DOCKER_CONT_NAME}$"; then
    echo "docker-compose up $DOCKER_CONT_NAME is running."
else
    echo "docker-compose up $DOCKER_CONT_NAME"
    sudo docker-compose -f $script_dir/.docker/docker-compose.yml up --build -d
fi

if [ -n "$Build" ]; then
    echo "Building"
    sudo docker exec --workdir /root/workspace $DOCKER_CONT_NAME ./cerbero-uninstalled -c config/cross-android-universal.cbc bootstrap
    sudo docker exec --workdir /root/workspace $DOCKER_CONT_NAME ./cerbero-uninstalled -c config/cross-android-universal.cbc package gstreamer-1.0
fi
if [ -n "$Shell" ]; then
    echo "Shell into container $DOCKER_CONT_NAME"
    sudo docker exec -it $DOCKER_CONT_NAME bash
fi
if [ -n "$Remove" ]; then
    echo "docker-compose down $DOCKER_CONT_NAME"
    sudo docker-compose -f $script_dir/.docker/docker-compose.yml down
fi
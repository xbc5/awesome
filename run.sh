#!/bin/bash


project_root="$(dirname `realpath $0`)"


case "$1" in
	shell)
		docker run \
			--user root \
			--rm \
			-it \
			--volume ${project_root}/container-scripts:/init \
			--volume ${project_root}/src/:/home/limited/.config/awesome/ \
			foo/awesome:dom0
		;;

	attach)
		docker exec -it "$2" /bin/bash
		;;

	awesome)
		# docker run \
		# 	--rm \
		# 	--volume /tmp/.X11-unix:/tmp/.X11-unix \
		# 	--volume $HOME/.Xauthority:/home/limited/.Xauthority:rw \
		# 	--volume ${project_root}/src/:/home/limited/.config/awesome/ \
		# 	--env DISPLAY=:0 \
		# 	--hostname $HOSTNAME \
		# 	foo/awesome:dom0
		${project_root}/x11docker/x11docker \
			--user=RETAIN \
			--desktop \
			--hostdbus \
			-- \
			--rm \
			--volume ${project_root}/src/:/home/limited/.config/awesome:ro \
			--volume ${project_root}/container-scripts:/init:ro \
			-- \
			foo/awesome:dom0
		;;

	*)
		echo "options: shell | awesome"
esac
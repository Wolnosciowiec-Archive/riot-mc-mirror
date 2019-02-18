SUDO=sudo

build:
	${SUDO} docker build . -t wolnosciowiec/riot-mc-mirror

run:
	${SUDO} docker run --name riot-mc-mirror --rm -d wolnosciowiec/riot-mc-mirror

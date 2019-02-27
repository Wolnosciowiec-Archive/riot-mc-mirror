SUDO=sudo

all: build build_arm

build:
	${SUDO} docker build . -t wolnosciowiec/riot-mc-mirror

build_arm:
	${SUDO} docker build -f ./armhf.Dockerfile . -t wolnosciowiec/riot-mc-mirror:armhf

run:
	${SUDO} docker run --name riot-mc-mirror --rm -d wolnosciowiec/riot-mc-mirror

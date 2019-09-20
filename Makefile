SUDO=sudo
RIOTKIT_UTILS_VER=v2.0.0
.SILENT:
SHELL=/bin/bash
PUSH=true

help:
	@grep -E '^[a-zA-Z\-\_0-9\.@]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: all_x86_64 all_arm ## Build last 4 versions for both ARM and X86_64

all_arm: _download_tools ## Build last 4 versions
	BUILD_PARAMS="--dont-rebuild "; \
	if [[ "$$TRAVIS_COMMIT_MESSAGE" == *"@force-rebuild"* ]]; then \
		BUILD_PARAMS=" "; \
	fi; \
	./.helpers/for-each-github-release --exec "make build_arm PUSH=${PUSH} VERSION=RELEASE%MATCH_0%" --repo-name minio/mc --dest-docker-repo quay.io/riotkit/riot-mc-mirror $${BUILD_PARAMS}--allowed-tags-regexp="RELEASE(.*)$$" --release-tag-template="RELEASE%MATCH_0%-arm" --max-versions=4 --verbose

all_x86_64: _download_tools ## Build last 4 versions
	BUILD_PARAMS="--dont-rebuild "; \
	if [[ "$$TRAVIS_COMMIT_MESSAGE" == *"@force-rebuild"* ]]; then \
		BUILD_PARAMS=" "; \
	fi; \
	./.helpers/for-each-github-release --exec "make build_x86_64 PUSH=${PUSH} VERSION=RELEASE%MATCH_0%" --repo-name minio/mc --dest-docker-repo quay.io/riotkit/riot-mc-mirror $${BUILD_PARAMS}--allowed-tags-regexp="RELEASE(.*)$$" --release-tag-template="RELEASE%MATCH_0%-x86_64" --max-versions=4 --verbose


build_x86_64: ## Build x86-64 image (args: VERSION)
	make generate_dockerfile _build ARCH=x86_64 IMAGE=alpine:3.9 VERSION=${VERSION} PUSH=${PUSH}

build_arm: ## Build ARM image (args: VERSION)
	make generate_dockerfile _inject_qemu _build ARCH=arm IMAGE=balenalib/armv7hf-alpine:3.9 VERSION=${VERSION} PUSH=${PUSH}

_build:
	${SUDO} docker build . -f ./Dockerfile -t quay.io/riotkit/riot-mc-mirror:${VERSION}-${ARCH}
	${SUDO} docker tag quay.io/riotkit/riot-mc-mirror:${VERSION}-${ARCH} quay.io/riotkit/riot-mc-mirror:${VERSION}-${ARCH}-$$(date '+%Y-%m-%d')

	if [[ ${PUSH} == true ]]; then \
		${SUDO} docker push quay.io/riotkit/riot-mc-mirror:${VERSION}-${ARCH}; \
		${SUDO} docker push quay.io/riotkit/riot-mc-mirror:${VERSION}-${ARCH}-$$(date '+%Y-%m-%d'); \
	fi

generate_dockerfile:  ## Generate the docker file (args: VERSION, ARCH, IMAGE)
	ARCH=${ARCH} VERSION=${VERSION} IMAGE=${IMAGE} j2 ./Dockerfile.j2 > ./Dockerfile

clean: ## Clean up build files
	rm -f ./Dockerfile

### COMMON AUTOMATION

dev@generate_readme: ## Renders the README.md from README.md.j2
	RIOTKIT_PATH=./.helpers DOCKERFILE_PATH=Dockerfile.j2 ./.helpers/docker-generate-readme

dev@before_commit: dev@generate_readme ## Git hook before commit
	git add README.md

dev@develop: ## Setup development environment, install git hooks
	echo " >> Setting up GIT hooks for development"
	mkdir -p .git/hooks
	echo "#\!/bin/bash" > .git/hooks/pre-commit
	echo "make dev@before_commit" >> .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit

_download_tools:
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/extract-envs-from-dockerfile > .helpers/extract-envs-from-dockerfile
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/env-to-json                  > .helpers/env-to-json
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/for-each-github-release      > .helpers/for-each-github-release
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/docker-generate-readme       > .helpers/docker-generate-readme
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/inject-qemu-bin-into-container > .helpers/inject-qemu-bin-into-container
	curl -s https://raw.githubusercontent.com/riotkit-org/ci-utils/${RIOTKIT_UTILS_VER}/bin/setup-travis-arm-builds        > .helpers/setup-travis-arm-builds
	chmod +x .helpers/*

_inject_qemu:
	${SUDO} ./.helpers/inject-qemu-bin-into-container ${IMAGE}

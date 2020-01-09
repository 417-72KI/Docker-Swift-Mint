IMAGE_NAME = swift-mint-dev

build:
	docker build -t $(IMAGE_NAME) .

swift_version: build
	docker run ${IMAGE_NAME} swift --version

mint_version: build
	docker run ${IMAGE_NAME} mint version

run: build
	docker run -it $(IMAGE_NAME)

release: build
	@scripts/release.sh $(IMAGE_NAME)

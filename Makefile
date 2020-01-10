IMAGE_NAME = swift-mint

build:
	docker build -t $(IMAGE_NAME) .

swift_version: build
	docker run ${IMAGE_NAME} swift --version

mint_version: build
	docker run ${IMAGE_NAME} mint version

run: build
	docker run -it $(IMAGE_NAME)

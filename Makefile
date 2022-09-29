DOCKER_USER = 41772ki
IMAGE_NAME = swift-mint
LATEST_SWIFT_VERSION = 5.7

build:
	docker build -t $(IMAGE_NAME) .

swift_version: build
	docker run ${IMAGE_NAME} swift --version

mint_version: build
	docker run ${IMAGE_NAME} mint version

run: build
	docker run -it $(IMAGE_NAME)

clean:
	docker rmi $(IMAGE_NAME):latest

buildx:
	docker buildx build \
	--push \
	--platform linux/arm64,linux/amd64 \
	--tag $(DOCKER_USER)/$(IMAGE_NAME):latest \
	--tag $(DOCKER_USER)/$(IMAGE_NAME):$(LATEST_SWIFT_VERSION) \
	.

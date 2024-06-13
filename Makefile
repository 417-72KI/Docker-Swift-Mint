DOCKER_USER = 41772ki
IMAGE_NAME = swift-mint
LATEST_SWIFT_VERSION = 5.10
SWIFT_VERSION = $(LATEST_SWIFT_VERSION)

build:
	docker build --build-arg SWIFT_VERSION=$(SWIFT_VERSION) -t $(IMAGE_NAME):$(SWIFT_VERSION) .

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

arm64:
	@scripts/build_and_push_arm64_image.sh $(DOCKER_USER) $(IMAGE_NAME)

arm64-v:
	@scripts/build_and_push_arm64_image.sh -s $(shell cat .github/matrix.json | jq -r '.swift_version[]' | peco) -f $(DOCKER_USER) $(IMAGE_NAME)

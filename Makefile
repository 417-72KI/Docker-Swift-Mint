# .SILENT:

DOCKER_USER = 41772ki
IMAGE_NAME = swift-mint
LATEST_SWIFT_VERSION = 6.0

build: $(addprefix build-, $(LATEST_SWIFT_VERSION))

build-%:
	cat .github/matrix.json \
		| jq -r '.mint_revision["${@:build-%=%}"]' \
		| xargs -I {} docker build \
			--build-arg SWIFT_VERSION=${@:build-%=%} \
			--build-arg MINT_REVISION={} \
			--target base \
			-t $(DOCKER_USER)/$(IMAGE_NAME):${@:build-%=%} \
			.

npm: $(addprefix npm-, $(LATEST_SWIFT_VERSION))

npm-%:
	cat .github/matrix.json \
		| jq -r '.mint_revision["${@:npm-%=%}"]' \
		| xargs -I {} docker build \
			--build-arg SWIFT_VERSION=${@:npm-%=%} \
			--build-arg MINT_REVISION={} \
			--target npm \
			-t $(DOCKER_USER)/$(IMAGE_NAME):${@:npm-%=%}-npm \
			.

swift-version: $(addprefix swift-version-, $(LATEST_SWIFT_VERSION))

swift-version-%: build-%
	docker run --rm $(DOCKER_USER)/$(IMAGE_NAME):${@:swift-version-%=%} swift --version

mint-version: $(addprefix mint-version-, $(LATEST_SWIFT_VERSION))

mint-version-%: build-%
	docker run --rm $(DOCKER_USER)/$(IMAGE_NAME):${@:mint-version-%=%} mint version

run: $(addprefix run-, $(LATEST_SWIFT_VERSION))

run-%: build-%
	docker run --rm -it $(DOCKER_USER)/$(IMAGE_NAME):${@:run-%=%}

clean: $(addprefix clean-, $(LATEST_SWIFT_VERSION))

clean-%:
	docker rmi $(DOCKER_USER)/$(IMAGE_NAME):${@:clean-%=%}

buildx:
	docker buildx build \
	--push \
	--platform linux/arm64,linux/amd64 \
	--tag $(DOCKER_USER)/$(IMAGE_NAME):latest \
	--tag $(DOCKER_USER)/$(IMAGE_NAME):$(LATEST_SWIFT_VERSION) \
	.

arm64:
	@scripts/build_and_push_arm64_image.sh $(DOCKER_USER) $(IMAGE_NAME)

arm64-%:
	@scripts/build_and_push_arm64_image.sh -s ${@:clean-%=%} -f $(DOCKER_USER) $(IMAGE_NAME)

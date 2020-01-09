IMAGE_NAME = swift-mint

build:
	docker build -t $(IMAGE_NAME) .

run: build
	docker run -it $(IMAGE_NAME)

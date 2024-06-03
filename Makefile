.PHONY: image

.DEFAULT_GOAL := all
all : mavlink-camera-manager

image:
	docker buildx build . -t camera
mavlink-camera-manager: image
	@CONTAINER=$$(docker create camera); \
	echo "$$CONTAINER"; \
	docker cp "$$CONTAINER:/camera/target/aarch64-unknown-linux-gnu/release/mavlink-camera-manager" .; \
	docker container rm $$CONTAINER \


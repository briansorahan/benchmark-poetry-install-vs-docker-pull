IMG = bsorahan/benchmark-poetry-install-vs-docker-pull

image:
	@docker build --no-cache -t $(IMG) .

push:
	@docker push $(IMG)

.PHONY: image push

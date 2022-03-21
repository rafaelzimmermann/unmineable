
build-%:
	docker build -t rafaelzimmermann/unmineable:$* .

release-%: build-%
	docker push rafaelzimmermann/unmineable:$*


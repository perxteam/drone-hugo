.PHONY: all test push build release clean

README_TEMPLATE=./docs/tmpl.md

all: release

test: Dockerfile drone-hugo.sh
	docker build --squash -t "perxteam/drone-hugo:$(release)_test" --build-arg HUGO_VERSION="$(hugo)" .

build: Dockerfile drone-hugo.sh
	docker build -t "perxteam/drone-hugo:$(release)" --build-arg HUGO_VERSION="$(hugo)" .
	docker build -t "perxteam/drone-hugo:latest" --build-arg HUGO_VERSION="$(hugo)" .

push: build
	docker push "perxteam/drone-hugo:$(release)"
	docker push "perxteam/drone-hugo:latest"

release: $(README_TEMPLATE) test push build clean
	sed 's/<HUGO_VERSION>/$(hugo)/g' $(README_TEMPLATE) > temp.md
	sed 's/<RELEASE>/$(release)/g' temp.md > README.md
	rm -rf temp.md
	git add .
	git commit -m "Updated to the latest Hugo version v.$(hugo), see https://github.com/gohugoio/hugo/releases"
	git push origin master

clean:
	docker rmi perxteam/drone-hugo:$(release)
	docker rmi perxteam/drone-hugo:latest
	docker rmi perxteam/drone-hugo:$(release)_test

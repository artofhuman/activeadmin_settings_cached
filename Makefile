RUN := run --rm --service-ports
DOCKER_COMPOSE_RUN := docker-compose $(RUN)

default: test

bash:
	${DOCKER_COMPOSE_RUN} app bash

test: appraisals
	bundle exec appraisal rspec ${T}

appraisals: setup
	bundle exec appraisal install

appraisals-generate:
	bundle exec appraisal generate


setup:
	gem install bundler
	bundle check || bundle install -j 2
	bundle exec appraisal rake setup

down:
	docker-compose down

clean:
	rm -f Gemfile.lock
	rm -rf spec/rails
	rm -rf gemfiles

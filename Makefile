BUNDLE_VERSION = 1.12.5

default: tests

test: setup
	bundle exec rspec

setup:
	gem list -i -v ${BUNDLE_VERSION} bundler > /dev/null || gem install bundler --no-ri --no-rdoc --version=${BUNDLE_VERSION}
	bundle install -j 2

clean:
	rm -rf spec/rails

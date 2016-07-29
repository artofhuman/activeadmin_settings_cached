BUNDLE_VERSION = 1.12.5
BUNDLE = bundle _${BUNDLE_VERSION}_

default: test

test: appraisals
	${BUNDLE} exec appraisal rspec ${T}

appraisals: setup
	${BUNDLE} exec appraisal install

setup:
	gem list -i -v ${BUNDLE_VERSION} bundler > /dev/null || gem install bundler --no-ri --no-rdoc --version=${BUNDLE_VERSION}
	${BUNDLE} check || ${BUNDLE} install -j 2

clean:
	rm -f Gemfile.lock
	rm -rf spec/rails
	rm -rf gemfiles

default: test

rake:
	bundle exec rake ${T}

test: appraisals
	bundle exec appraisal rspec ${T}

appraisals: setup
	bundle exec appraisal install

setup:
	gem install bundler --no-ri --no-rdoc
	bundle check || bundle install -j 2

clean:
	rm -f Gemfile.lock
	rm -rf spec/rails
	rm -rf gemfiles

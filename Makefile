all: clean build

dist: clean build doc test

clean:
	rm -rf lib test doc

build:
	@mkdir -p lib test
	coffee -cs < src/idiom.coffee > lib/idiom.js
	coffee -cs < src/test.coffee  > test/test.js

doc: build
	groc src/* README.md

gh-pages: doc
	git checkout gh-pages

	ls -1I doc | xargs rm -rf
	mv doc/* .
	rmdir doc

	git add *
	git commit -am "Generated at `date`"
	git checkout master

test: build
	mocha -R spec

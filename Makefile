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

pubdoc:
	groc --github src/* README.md

test: build
	mocha -R spec

all: clean build

clean:
	rm -rf lib test

build:
	@mkdir -p lib test
	coffee -cs < src/idiom.coffee > lib/idiom.js
	coffee -cs < src/test.coffee  > test/test.js

.PHONY: test
test:
	mocha -R spec

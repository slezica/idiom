assert = require 'assert'

require('../lib/idiom').export()

describe '#take()', ->
  it 'should run a function in a context', ->
    ctx = {}
    foo = -> @key = 'value'; @

    assert take(ctx, foo) is ctx
    assert.equal ctx.key, 'value'

describe '#kindof()', ->
  it 'should recognize undefined', ->
    assert.equal kindof(undefined), 'undefined'

  it 'should recognize null', ->
    assert.equal kindof(null), 'null'

  it 'should recognize numbers', ->
    assert.equal kindof(1)  , 'Number'
    assert.equal kindof(0.5), 'Number'

  it 'should recognize strings', ->
    assert.equal kindof('foo'), 'String'

  it 'should recognize arrays', ->
    assert.equal kindof([]), 'Array'

  it 'should recognize plain objects', ->
    assert.equal kindof({}), 'Object'

  it 'should recognize custom classes', ->
    class TestClass
    assert.equal kindof(new TestClass), 'TestClass'

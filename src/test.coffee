# This module is written for mocha
#   1. Install with `npm install -g mocha`
#   2. Run `mocha` (recommended `mocha -R spec`) on package root

assert = require 'assert'

require('../lib/idiom').export()

describe '#take()', ->
  it 'should run a function in a context and return it', ->
    ctx = {}
    foo = -> @key = 'value'

    assert take(ctx, foo) is ctx
    assert.equal ctx.key, 'value'


describe '#kindof()', ->
  it 'should identify undefined', ->
    assert.equal kindof(undefined), 'undefined'

  it 'should identify null', ->
    assert.equal kindof(null), 'null'

  it 'should identify numbers', ->
    assert.equal kindof(1)  , 'Number'
    assert.equal kindof(0.5), 'Number'

  it 'should identify strings', ->
    assert.equal kindof('foo'), 'String'

  it 'should identify arrays', ->
    assert.equal kindof([]), 'Array'

  it 'should identify plain objects', ->
    assert.equal kindof({}), 'Object'

  it 'should identify custom classes', ->
    assert.equal kindof(new class TestClass), 'TestClass'


describe '#async()', ->
  $err = $obj = null
  $ = (err, obj) ->
    $err = err
    $obj = obj

  it 'should forward returns to a callback', ->
    (async -> 8)($)
    assert.equal $err, null
    assert.equal $obj, 8

  it 'should forward exceptions as errors', ->
    (async -> throw 8)($)
    assert.equal $err, 8
    assert.equal $obj, null


describe '#extend()', ->
  x = { a: 1, b: 2, c: 3, d: 4}
  y = { c: 4, d: 3, e: 2, f: 1}
  z = extend x, y

  it 'should return its first argument', ->
    assert x is z

  it 'should copy all own properties', ->
    assert key of z for own key of x
    assert key of z for own key of y

  it 'should override repeated properties', ->
    assert.equal z[key], y[key] for own key of y


describe '#merge()', ->
  x = { a: 1, b: 2, c: 3, d: 4}
  y = { c: 4, d: 3, e: 2, f: 1}
  z = merge x, y

  it 'should create new objects', ->
    assert x isnt merge x

  it 'should copy all own properties', ->
    assert key of z for own key of x
    assert key of z for own key of y

  it 'should override repeated properties', ->
    assert.equal z[key], y[key] for own key of y


describe '#dict()', ->
  it 'should work with no arguments', ->
    assert.deepEqual dict(), {}

  it 'should merge key-value pairs into an object', ->
    x = dict([a, a + 3] for a in [1..10])
    assert.equal x[key], key + 3 for key in [1..10]

  it 'should override repeated properties', ->
    x = dict([ [1, 1], [1, 2], [1, 3] ])
    assert.equal x[1], 3

describe '#clone()', ->
  test = (orig) ->
    assert.deepEqual orig, clone orig

  it 'should handle undefined', -> test undefined
  it 'should handle null'     , -> test null
  it 'should handle numbers'  , -> test 10
  it 'should handle strings'  , -> test 'hello'

  it 'should handle arrays', ->
    inner = [1]
    outer = [1, inner, 2]
    copy  = clone outer

    assert copy instanceof Array
    assert.deepEqual outer, copy
    inner.push 2
    assert.notDeepEqual outer, copy

  it 'should handle objects', ->
    inner = { foo: "bar" }
    outer = new -> @inner = inner # Nested to test deep cloning
    copy  = clone outer

    assert copy instanceof outer.constructor
    assert.deepEqual outer, copy
    inner.foo = "baz"
    assert.notDeepEqual outer, copy

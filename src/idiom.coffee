# `apply` is a shortcut to Function.apply with `this` as third,
# optional parameter (defaults to `null`).
@apply = apply = (f, args, ctx = null) ->
  f.apply ctx, args


# ---

# `take` runs a function with a given context and returns it, encapsulating
# the usage of an object.

#     first3 = take ([1, 2]) -> @push 3
@take = take = (x, f) ->
  f.call x; x


# ---

# `kindof` returns the class of an object. It plays the role of `typeof`, only
# it doesn't report 'object' for pretty much everything.

#     kindof(undefined)   is 'undefined'
#     kindof(null)        is 'null'
#     kindof(1)           is 'Number'
#     kindof('foo')       is 'String'
#     kindof([])          is 'Array'
#     kindof({})          is 'Object'
#     kindof(new class X) is 'X'
@kindof = (x) ->
  if x isnt null
    if x? and x.constructor? then x.constructor.name else typeof x
  else 'null'


# ---

# `async` takes a sync function that `returns` or `throws` and creates an async
# version that takes a callback as last parameter. The callback is then
# invoked with either `(null, result)` or `(exception, null)`.
@async = (f) -> (args..., $) ->
  try
    $ null, apply f, args
  catch e
    $ e, null


# ---

# `extend` injects into its first argument all own properties of later
# arguments, from left to right, so that later parameters take precedence.
@extend = extend = (base, extras...) ->
  for object in extras
    base[key] = object[key] for own key of object
  base


# ---

# `merge` works like `extend`, but starts with a new empty base object.
@merge = (objects...) ->
  objects.unshift {}
  apply extend, objects


# ---

# `dict` creates an object from an array of `[key, value]` pairs, paving the way
# for python-like object comprehensions.

#     obj = dict([x, 'number: ' + x] for x in [1..10])
@dict = (pairs = []) ->
  take {}, ->
    @[pair[0]] = pair[1] for pair in pairs


# ---

# `clone` deep-clones an object of any type. `null`, `undefined`, numbers and
# strings `clone` to themselves. Nested arrays and objects are properly
# duplicated.
@clone = clone = (object) ->
  if object? and typeof object is 'object'
    take Object.create(object.constructor.prototype), ->
      @[key] = clone object[key] for own key of object
  else
    object


# ---

# `export` makes idioms globally available. You can inject into another object,
# instead of `global`, by passing it as parameter.
@export = (host = global) =>
  host[key] = @[key] for key of @ when key isnt 'export'
  @

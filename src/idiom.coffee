
# `take` runs a function with a given context, encapsulating the usage of an
# object to make use of the `@` notation
#
# Example:
# four = take [1, 2, 3], ->
#   @push 4
#   @pop
@take = (x, f) ->
  f.call x


# `kindof` returns the class of an object. It plays the role of `typeof`, only
# it doesn't report 'object' for pretty much everything.
#
# Examples:
#   - kindof null is 'null'
#   - kindof undefined is 'undefined'
#   - kindof 1 is 'Number'
#   - kindof 'foo' is 'String'
#   - kindof [] is 'Array'
#   - kindof {} is 'Object'
#   - kindof (new class Foo) is 'Foo'
@kindof = (x) ->
  if x isnt null
    if x? and x.constructor? then x.constructor.name else typeof x
  else 'null'


# `async` takes a sync function that returns or raises and creates an async
# version, that takes a callback as last parameter and calls callback(err, obj)
@async = (f) -> (args..., $) ->
  try
    $ null, f.apply null, args
  catch e
    $ e, null

# `export` makes idioms globally available. You can inject into another object,
# instead of `global`, by passing it as parameter.
@export = (host = global) =>
  host[key] = @[key] for key of @ when key isnt 'export'
  @

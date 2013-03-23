
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
#   1. kindof null is 'null'
#   2. kindof undefined is 'undefined'
#   3. kindof 1 is 'Number'
#   4. kindof 'foo' is 'String'
#   5. kindof [] is 'Array'
#   6. kindof {} is 'Object'
#   7. kindof (new class Foo) is 'Foo'
@kindof = (x) ->
  if x isnt null
    if x? and x.constructor? then x.constructor.name else typeof x
  else 'null'

# `export` makes idioms globally available. You can inject into another object,
# instead of `global`, by passing it as parameter.
@export = (host = global) =>
  host[key] = @[key] for key of @ when key isnt 'export'
  @

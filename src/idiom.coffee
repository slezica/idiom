
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
@kindof = (x) ->
  if x isnt null
    if x? and x.constructor? then x.constructor.name else typeof x
  else 'null'

@export = (host = global) =>
  host[key] = @[key] for key of @ when key isnt 'export'
  @

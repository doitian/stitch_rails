# https://gist.github.com/1153919

modules = {}
cache = {}

require = (name, root) ->
  if module = cache[name]
    return module

  path = expand(root, name)
  if fn = modules[path] || modules[path = expand(path, './index')]
    module = id: name, exports: {}
    try
      cache[name] = module.exports
      fn(module.exports, ((name) -> require(name, dirname(path))), module)
      cache[name] = module.exports
    catch err
      delete cache[name];
      throw err
  else
    throw "module #{name} not found"


expand = (root, name) ->
  results = []
  if /^\.\.?(\/|$)/.test(name)
    parts = [root, name].join('/').split('/')
  else
    parts = name.split('/')

  for part in parts
    if part is '..'
      results.pop()
    else if part isnt '.' && part isnt ''
      results.push(part)

  results.join('/')

dirname = (path) ->
  path.split('/').slice(0, -1).join('/')

@require = (name) ->
  require(name, '')

@requireIf = (nameAssertion, callback) ->
  for name of modules when nameAssertion(name)
    exports = require(name)
    callback?(name, exports)
  null

@require.define = (bundle) ->
  for key of bundle
    modules[key] = bundle[key];
  bundle

module?.exports = { require, requireIf }

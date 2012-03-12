# https://gist.github.com/1153919

modules = {}
cache = {}

require = (name, root) ->
  return cache[name] if name of cache

  path = expand(root, name)
  if fn = modules[path]
    dir = dirname(path)
  else if fn = modules[path + '/index']
    dir = path

  return throw "module #{name} not found" unless fn

  return cache[path] if path of cache
  module = id: name, exports: {}
  fn(module.exports, ((name) -> require(name, dir)), module)
  cache[path] = module.exports

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

{print}   = require 'util'
{spawn}   = require 'child_process'
fs        = require 'fs'
path      = require 'path'

task 'build', 'Build from ./', (callback) ->
  coffee = spawn 'coffee', ['-c', '-o', '.', '.']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

task 'watch', 'Watch ./ for changes', ->
  coffee = spawn 'coffee', ['-w', '-c', '-o', '.', '.']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()

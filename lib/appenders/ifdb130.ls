#!/usr/bin/env lsc
#
require! <[colors moment request]>
BaseAppender = require \./base

class Measurement
  (@name, @tags, @kvs, @timestamp=0ms) ->
    @timestamp = timestamp - 0
    return

  to-ifdb-line: ->
    {name, tags, kvs, timestamp} = self = @
    xs = [ "#{t}=#{v}" for t, v of tags ]
    xs = [name] ++ xs
    metadata = xs.join ","
    ys = [ "#{k}=#{v}" for k, v of kvs ]
    field-values = ys.join ","
    zs = [metadata, field-values, "#{timestamp}000000" ]
    # ys = [ metadata ] ++ ys
    return zs.join " "


module.exports = exports = class Appender extends BaseAppender
  (@args) ->
    super ...
    return

  init: (done) ->
    {args} = self = @
    [address, username, password, database] = args
    return done "missing address" unless address?
    return done "missing username" unless username?
    return done "missing password" unless password?
    return done "missing database" unless database?
    self.address = address
    self.username = username
    self.password = password
    self.database = database
    opts = url: "#{address}/query", qs: {u: username, p: password, q: "CREATE DATABASE #{database}"}
    (err, rsp, body) <- request.post opts
    return done err if err?
    return done "missing response for the http request: #{JSON.stringify opts}" unless rsp?
    return done "unexpected response code: #{rsp.status-code}" unless rsp.status-code is 200
    console.log "successfully create database #{database}"
    return done!

  append-internal: (timestamp, node, board_type, board_id, sensor_type, sensor_id, points) ->
    {address, username, password, database} = self = @
    self.value-sets = []
    time = moment timestamp
    prefix = time.format 'MM/DD HH:mm:ss SSS' .gray
    kvs = { [p.data_type, p.value] for p in points }
    m = new Measurement sensor_type, {node, board_type, board_id, sensor_id}, kvs, timestamp
    text = m.to-ifdb-line!
    opts = url: "#{address}/write", qs: {u: username, p: password, db: database}, body: text
    (err, rsp, body) <- request.post opts
    return console.error err if err?
    return console.error "missing response for the http request: #{JSON.stringify opts}" unless rsp?
    return console.error "unexpected response code: #{rsp.status-code}. (request: #{JSON.stringify opts}) (response: #{JSON.stringify rsp} #{body})" unless rsp.status-code is 204
    console.log "successfully insert to #{database}"
    for p in points
      {data_type, unit_length, value} = p
      value = value.to-string!
      console.log "#{prefix} #{node.yellow}/#{board_type.cyan}/#{board_id.cyan}/#{sensor_type.cyan}/#{sensor_id.cyan} => #{data_type.magenta}: #{value.green}#{unit_length.gray}"





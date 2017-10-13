#!/usr/bin/env lsc
#
require! <[colors moment]>
BaseAppender = require \./base

module.exports = exports = class Appender extends BaseAppender
  (@args) ->
    super ...
    return

  init: (done) ->
    {args} = self = @
    [out] = args
    self.output = if out is \stdout then process.stdout else process.stderr
    return done!

  append-internal: (timestamp, node, board_type, board_id, sensor_type, sensor_id, points) ->
    {output} = self = @
    time = moment timestamp
    prefix = time.format 'MM/DD HH:mm:ss SSS' .gray
    for p in points
      {data_type, unit_length, value} = p
      value = value.to-string!
      output.write "#{prefix} #{node.yellow}/#{board_type.cyan}/#{board_id.cyan}/#{sensor_type.cyan}/#{sensor_id.cyan} => #{data_type.magenta}: #{value.green}#{unit_length.gray}\n"


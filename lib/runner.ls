periodic-random = require \./generators/periodic-random
simple-random = require \./generators/simple-random


ERR_EXIT = (message) ->
  console.error message
  process.exit 1


class Generator
  (@type, @unit, @opts, @clazz) ->
    @generator = new clazz opts

  get-next-point: ->
    {type, unit, generator} = self = @
    data_type = type
    unit_length = unit
    value = generator.next!
    return {data_type, value, unit_length}




module.exports = exports = class Runner
  (@opts, extras) ->
    self = @
    {delay, period, points} = opts
    xs = opts.metadata.split "/"
    return ERR_EXIT "insufficient parameters: #{opts.metadata}" if xs.length < 4
    [board_type, board_id, sensor_type, sensor_id] = xs
    self.metadata = {board_type, board_id, sensor_type, sensor_id}
    self.metadata <<< extras
    self.delay = delay
    self.period = period
    self.counter = period + delay
    self.generators = []
    console.log "metadata: #{JSON.stringify self.metadata}"
    [ self.init-generator p for p in points ]


  init-generator: (args) ->
    [type, unit, clazz, ...xs] = args
    if clazz is \periodic-random
      [fixed, digits, min_value, max_value, delta, increasing_ratio] = xs
      clazz = periodic-random
      gopts = {fixed, digits, min_value, max_value, delta, increasing_ratio}
    else
      [fixed, digits, min_value, max_value] = xs
      clazz = simple-random
      gopts = {fixed, digits, min_value, max_value}
    g = new Generator type, unit, gopts, clazz
    @generators.push g


  get-next-points: (timestamp=null) ->
    {generators, metadata} = self = @
    points = [ (g.get-next-point!) for g in generators ]
    timestamp = new Date! unless timestamp?
    return {metadata, points, timestamp}


  at-next-second: (timestamp) ->
    {counter} = self = @
    self.counter = counter - 1
    return null unless self.counter < 0
    self.counter = self.period
    return self.get-next-points timestamp


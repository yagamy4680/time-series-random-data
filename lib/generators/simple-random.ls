#!/usr/bin/env lsc
#
BaseGenerator = require \./base

module.exports = exports = class Generator extends BaseGenerator
  (@opts) ->
    {fixed, digits, max_value, min_value} = opts
    super {fixed, digits}
    @max_value = max_value
    @min_value = min_value
    @delta = max_value - min_value

  next-internal: ->
    {min_value, delta} = self = @
    return min_value + delta * Math.random!


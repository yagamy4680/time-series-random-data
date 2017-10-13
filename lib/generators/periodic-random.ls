#!/usr/bin/env lsc
#
BaseGenerator = require \./base

module.exports = exports = class Generator extends BaseGenerator
  (@opts) ->
    {fixed, digits, max_value, min_value, delta, increase_ratio} = opts
    super {fixed, digits}
    @max_value = max_value
    @max_value = 100 unless @max_value?
    @min_value = min_value
    @min_value = 0 unless @min_value?
    @delta = delta
    @delta = 5 unless @delta?
    @increase_ratio = increase_ratio
    @increase_ratio = 0.6 unless @increase_ratio?
    @increase_ratio = 0.6 if @increase_ratio > 1 or @increase_ratio < 0
    @current = min_value + (max_value - min_value) * Math.random!
    # console.log "initial value: #{@current}"

  next-internal: ->
    {max_value, min_value, delta, increase_ratio, current} = self = @
    d = delta * Math.random!
    x = if Math.random! < increase_ratio then direction = 1 else -1
    c = @current = current + d * x
    # console.log "d => #{d}, x => #{x}, c = #{c}, max_value => #{max_value}, min_value => #{min_value}"
    if c >= max_value
      @increase_ratio = 1 - @increase_ratio
      @current = max_value
    if c <= min_value
      @increase_ratio = 1 - @increase_ratio
      @current = min_value
    # console.log "@current => #{@current}"
    return @current


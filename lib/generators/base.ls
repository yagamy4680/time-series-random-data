##
#
# Base Data Generator
#

class BaseGenerator
  (opts) ->
    {fixed, digits} = opts
    fixed = yes unless fixed?
    digits = 0 unless digits?
    @fixed = fixed
    @digits = digits

  next: ->
    {fixed, digits} = self = @
    x = self.next-internal!
    return x.to-fixed! if fixed
    return x.to-fixed digits

  next-internal: ->
    return 0

module.exports = exports = BaseGenerator
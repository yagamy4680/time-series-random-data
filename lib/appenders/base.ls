##
#
# Base Appender
#

class BaseAppender
  ->
    return

  init: ->
    return

  append-internal: (timestamp, node, board_type, board_id, sensor_type, sensor_id, points) ->
    return

  append: (data) ->
    {metadata, timestamp, points} = data
    {board_type, board_id, sensor_type, sensor_id, node} = metadata
    return @.append-internal timestamp, node, board_type, board_id, sensor_type, sensor_id, points


module.exports = exports = BaseAppender

# Description:
#   Hammertime
#
# Commands:

module.exports = (robot) ->
  robot.respond /chue alert( )?(.*)?/i, (msg) ->
    timeout = msg.match[2]
    if timeout is undefined
        timeout = 5502
    robot.http("http://gadgetlab.chnet/alert?timeout=#{timeout}")
        .get() (err, res, body) ->
            msg.emote "Blinking hue lamps at CH"

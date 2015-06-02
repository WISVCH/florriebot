# Description:
#   CHue
#
# Commands:
#   hubot alert [<timeout>]- Blink hue lamps at CH for <timeout> milliseconds

module.exports = (robot) ->
  robot.respond /chue alert ?(.*)?/i, (msg) ->
    timeout = if msg.match[1] is undefined then 5502 else msg.match[1]
    msg.send "http://gadgetlab.chnet/alert?timeout=#{timeout}"
    robot.http("http://gadgetlab.chnet/alert?timeout=#{timeout}")
        .get() (err, res, body) ->
            msg.emote "Blinking hue lamps at CH"

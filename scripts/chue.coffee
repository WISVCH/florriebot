# Description:
#   CHue
#
# Commands:
#   hubot alert [<timeout>] - Blink hue lamps at CH for <timeout> milliseconds
#   hubot bvoranje - B'voranje :owl:

module.exports = (robot) ->
  robot.respond /chue alert ?(.*)?/i, (msg) ->
    timeout = if msg.match[1] is undefined then 5502 else msg.match[1]
    robot.http("http://gadgetlab.chnet/alert?timeout=#{timeout}")
        .get() (err, res, body) ->
            msg.emote "Blinking hue lamps at CH"

  robot.respond /bvoranje/i, (msg) ->
    robot.http("http://gadgetlab.chnet/oranje")
        .get() (err, res, body) ->
            msg.emote ":owl:"

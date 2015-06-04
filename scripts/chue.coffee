# Description:
#   CHue
#
# Commands:
#   hubot chue alert [<timeout>] - Blink hue lamps at CH for <timeout> milliseconds
#   hubot chue color [<lamp>] #<hex> - Change hue lamp <lamp> (or all) to color <hex>
#   hubot bvoranje - B'voranje :owl:

module.exports = (robot) ->
  robot.respond /chue alert ?(.*)?/i, (msg) ->
    timeout = if msg.match[1] is undefined then 5502 else msg.match[1]
    robot.http("http://gadgetlab.chnet/alert?timeout=#{timeout}")
        .get() (err, res, body) ->
            msg.emote "Blinking hue lamps at CH"

  robot.respond /chue color (\d*)? ?#(.*)/i, (msg) ->
    lamp = if msg.match[1] is undefined then "all" else msg.match[1]
    color = msg.match[2]

    robot.http("http://gadgetlab.chnet/color/#{lamp}/#{color}")
        .get() (err, res, body) ->
            msg.emote "Changed color of lamps (#{lamp}) to ##{color}"

  robot.respond /bvoranje/i, (msg) ->
    robot.http("http://gadgetlab.chnet/oranje")
        .get() (err, res, body) ->
            msg.emote ":owl:"

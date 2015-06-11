# Description:
#   CHue
#
# Commands:
#   hubot chue alert [<timeout>] - Blink hue lamps at CH for <timeout> milliseconds
#   hubot chue colour [<lamp>] #<hex> - Change hue lamp <lamp> (or all) to colour <hex>
#   hubot chue colourloop - Set hue lamps on colourloop
#   hubot chue random - Change hue lamps to a random colour
#   hubot bvoranje - B'voranje :owl:

module.exports = (robot) ->
  chueURL = 'https://gadgetlab.chnet/chue/'
  robot.respond /chue alert ?(.*)?/i, (msg) ->
    timeout = if msg.match[1] is undefined then 5502 else msg.match[1]
    robot.http("#{chueURL}alert?timeout=#{timeout}")
        .get() (err, res, body) ->
            msg.emote "Blinking hue lamps at CH"

  robot.respond /chue random/i, (msg) ->
    robot.http("#{chueURL}random")
        .get() (err, res, body) ->
            msg.emote "Changed colour of hue lamps at CH to a random colour"

  robot.respond /chue colou?rloop/i, (msg) ->
    robot.http("#{chueURL}colorloop")
        .get() (err, res, body) ->
            msg.emote "Put on a colourloop at CH"

  robot.respond /chue colou?r (\d)? ?#?(.*)/i, (msg) ->
    lamp = if msg.match[1] is undefined then "all" else msg.match[1]
    colour = msg.match[2]

    robot.http("#{chueURL}color/#{lamp}/#{colour}")
        .get() (err, res, body) ->
            if res.statusCode == 200
              msg.emote body

  robot.respond /bvoranje/i, (msg) ->
    robot.http("#{chueURL}oranje")
        .get() (err, res, body) ->
            msg.emote ":owl:"

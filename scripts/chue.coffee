# Description:
#   CHue
#
# Commands:
#   hubot chue alert [<lamp>] [<timeout>] - Blink hue lamps at CH for <timeout> milliseconds
#   hubot chue colour [<lamp>] #<hex> - Change hue lamp <lamp> (or all) to colour <hex>
#   hubot chue colourloop [<lamp>] - Set hue lamps on colourloop
#   hubot chue random [<lamp>] - Change hue lamps to a random colour
#   hubot bvoranje - B'voranje :owl:
#
# Configuration:
#   HUBOT_CHUE_URL = <scheme>://<host:port>/<basepath>/

module.exports = (robot) ->
  chueURL = process.env.HUBOT_CHUE_URL
  unless chueURL?
    robot.logger.error "Missing HUBOT_CHUE_URL in environment"
    return

  robot.respond /chue alert\s+(\d+)\s+(\d+)|chue alert\s+(\d+)|chue alert/i, (msg) ->
    timeout = msg.match[2] || msg.match[3] || 5502
    robot.http("#{chueURL}alert?timeout=#{timeout}")
        .get() (err, res, body) ->
            if res.statusCode == 200
              msg.emote "Blinking hue lamps at CH"
            else
              msg.emote "Sorry... " + body

  robot.respond /chue random ?(\d+)?/i, (msg) ->
    lamp = if msg.match[1] is undefined then "" else msg.match[1]
    robot.http("#{chueURL}random/#{lamp}")
        .get() (err, res, body) ->
            if res.statusCode == 200
              msg.emote body
            else
              msg.emote "Sorry... " + body

  robot.respond /chue colou?rloop ?(\d+)?/i, (msg) ->
    lamp = if msg.match[1] is undefined then "" else msg.match[1]
    robot.http("#{chueURL}colorloop/#{lamp}")
        .get() (err, res, body) ->
            if res.statusCode == 200
              msg.emote "Put on a colourloop at CH"
            else
              msg.emote "Sorry... " + body

  robot.respond /chue colou?r (\d+)? ?#?(.*)/i, (msg) ->
    lamp = if msg.match[1] is undefined then "" else msg.match[1]
    colour = msg.match[2]

    robot.http("#{chueURL}color/#{colour}/#{lamp}")
        .get() (err, res, body) ->
            if res.statusCode == 200
              msg.emote body
            else
              msg.emote "Sorry... " + body

  robot.respond /bvoranje/i, (msg) ->
    robot.http("#{chueURL}oranje")
        .get() (err, res, body) ->
            if res.statusCode == 200
              msg.emote ":owl:"
            else
              msg.emote "Sorry... " + body

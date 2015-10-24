# Description:
#   Give an alert in general and strobe in CH when /Pub opens
#
# Commands:

TIMEZONE = "Europe/Amsterdam"
#I don't know the pattern for only wednesday and friday...
PUB_TIME = '00 00 16 * * 3-5' # W-F 4pm
lamp = "all"
duration = 1000
ROOM = process.env.HUBOT_PUBALERT_ROOM
unless ROOM?
  robot.logger.error "Missing HUBOT_PUBALERT_ROOM in environment"
  return

cronJob = require('cron').CronJob

module.exports = (robot) ->
    chueURL = process.env.HUBOT_CHUE_URL
    unless chueURL?
      robot.logger.error "Missing HUBOT_CHUE_URL in environment"
      return
    gohome = new cronJob PUB_TIME,
        ->
            robot.messageRoom ROOM, "De /Pub is weer open! :beers:"
            #implement the CHue strobe here....
            robot.http("#{chueURL}strobe/#{lamp}" + duration)
        null
        true
        TIMEZONE

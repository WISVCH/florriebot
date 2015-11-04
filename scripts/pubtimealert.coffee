# Description:
#   Give an alert in general and strobe in CH when /Pub opens
#
# Commands:

TIMEZONE = "Europe/Amsterdam"
PUB_TIME = "00 00 16 * * 3-5" # Wed-Fri 16:00
DURATION = 10000

cronJob = require('cron').CronJob

module.exports = (robot) ->
  ROOM = process.env.HUBOT_PUBALERT_ROOM
  unless ROOM?
    robot.logger.error "Missing HUBOT_PUBALERT_ROOM in environment"
    return

  chueURL = process.env.HUBOT_CHUE_URL
  unless chueURL?
    robot.logger.error "Missing HUBOT_CHUE_URL in environment"
    return

  pubtime = new cronJob PUB_TIME,
    ->
      robot.messageRoom ROOM, "The /Pub is open! Have a beer! 🍻"
      if robot.adapterName == 'slack'
        robot.http("#{chueURL}alert?timeout=#{DURATION}")
          .get() (err, res, body) ->
    null
    true
    TIMEZONE

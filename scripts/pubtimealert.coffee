# Description:
#   Give an alert in general and strobe in CH when /Pub opens
#
# Commands:

TIMEZONE = "Europe/Amsterdam"
PUB_TIME = "00 00 16 * * 3-5" # Wed-Fri 16:00
DURATION = 10000

ical = require('ical')

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

  alertRooms = (reason) ->
    robot.messageRoom ROOM, reason
    if robot.adapterName == 'slack'
      robot.http("#{chueURL}alert?timeout=#{DURATION}")
        .get() (err, res, body) ->

  pubtime = new cronJob PUB_TIME,
    ->
      now = new Date()
      now.setHours(16, 0, 0, 0);
      now = now.getTime()
      # Verify opening via /pub iCal
      robot.http("https://pub.etv.tudelft.nl/ical/getcalender?barkeeperId=all")
          .get() (err, res, body) ->
              if res.statusCode == 200
                iCalParsed = ical.parseICS(body)
                for key in Object.keys(iCalParsed)
                  event = iCalParsed[key]
                  try
                    if event.start.getTime() == now
                      alertRooms("The /Pub is open! #{event.summary}. Have a beer! 🍻")
                  catch error
              else
                alertRooms "The /Pub might be open (iCal feed broken). Try to get some beer! 🍻"
    null
    true
    TIMEZONE

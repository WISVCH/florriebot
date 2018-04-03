// Description:
//   Give an alert in general and strobe in CH when /Pub opens
//
// Commands:

const TIMEZONE = "Europe/Amsterdam";
const PUB_TIME = "00 00 16 * * 3-5"; // Wed-Fri 16:00
const DURATION = 10000;

const ical = require('ical');

const cronJob = (require('cron')).CronJob;

module.exports = function(robot) {
  let pubtime;
  const ROOM = process.env.HUBOT_PUBALERT_ROOM;
  if (ROOM == null) {
    robot.logger.error("Missing HUBOT_PUBALERT_ROOM in environment");
    return;
  }

  const chueURL = process.env.HUBOT_CHUE_URL;
  if (chueURL == null) {
    robot.logger.error("Missing HUBOT_CHUE_URL in environment");
    return;
  }

  const alertRooms = function(reason) {
    robot.messageRoom(ROOM, reason);
    if (robot.adapterName === 'slack') {
      return robot.http(`${chueURL}alert?timeout=${DURATION}`)
        .get()(function(err, res, body) {});
    }
  };

  return pubtime = new cronJob(PUB_TIME,
    function() {
      let now = new Date();
      now.setHours(16, 0, 0, 0);
      now = now.getTime();
      // Verify opening via /pub iCal
      return robot.http("https://pub.etv.tudelft.nl/ical/getcalender?barkeeperId=all")
          .get()(function(err, res, body) {
              if (res.statusCode === 200) {
                const iCalParsed = ical.parseICS(body);
                return (() => {
                  const result = [];
                  for (let key of Array.from(Object.keys(iCalParsed))) {
                    const event = iCalParsed[key];
                    try {
                      if (event.start.getTime() === now) {
                        result.push(alertRooms(`The /Pub is open! ${event.summary}. Have a beer! 🍻`));
                      } else {
                        result.push(undefined);
                      }
                    } catch (error) {}
                  }
                  return result;
                })();
              } else {
                return alertRooms("The /Pub might be open (iCal feed broken). Try to get some beer! 🍻");
              }
      });
    },
    null,
    true,
    TIMEZONE);
};

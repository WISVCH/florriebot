// Description:
//   Give an alert in general and strobe in CH when /Pub opens
//
// Commands:

const fetch = require('node-fetch');

const TIMEZONE = "Europe/Amsterdam";
const PUB_TIME = "00 00 16 * * 3-4"; // Wed-Thu 16:00

const ical = require('ical');

const cronJob = (require('cron')).CronJob;

module.exports = function(robot) {
  const ROOM = process.env.HUBOT_PUBALERT_ROOM;

  if (ROOM == null) {
    robot.logger.error("Missing HUBOT_PUBALERT_ROOM in environment");
    return;
  }

  const alertRooms = function(reason) {
    robot.messageRoom(ROOM, reason);
  };

  async function cronCallback() {
    const now = new Date();
    now.setHours(16, 0, 0, 0);
    const todaysStartTime = now.getTime();

    try {
      const calendar = await fetch('https://pub.ewi.tudelft.nl/ical/feed/all');
      const calendarEvents = ical.parseICS((await calendar.text()).split('\n').map(_ => {return _.trim()}).join('\n'));

      const event = Object.values(calendarEvents)
          .filter(event => {
            if (event.start.getTime) {
              return event.start.getTime() === todaysStartTime
            }
            return false;
          }
          )[0];

      if (event) {
        alertRooms(`The /Pub is open! ${event.summary}. Have a beer! 🍻`)
      }
    } catch (e) {
      alertRooms(`The /Pub might be open (iCal feed broken). Try to get some beer! 🍻: ${e}`);
    }
  }

  return new cronJob(PUB_TIME, cronCallback, null, true, TIMEZONE);
};

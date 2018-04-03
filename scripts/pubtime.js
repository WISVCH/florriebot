// Description:
//   Give the remaining time until the /Pub opens
//
// Commands:

module.exports = robot =>
  robot.hear(/(?:is het (al )?pubtijd|is it pubtime)/i, function(msg) {
    const now = new Date;

    if ((now.getDay() === 3) || (now.getDay() === 5)) {
      // /Pub opens at 16:00:00
      const dateOpen = new Date;
      dateOpen.setHours(16);
      dateOpen.setMinutes(0);
      dateOpen.setSeconds(0);

      const timeLeft = (dateOpen - now) / 1000;

      if (timeLeft <= 0) {
        return msg.send("YES! Go grab a beer! :beers:");
      } else {
        const hours = Math.floor(timeLeft / 60 / 60);
        const minutes = Math.floor(timeLeft / 60) - (hours * 60);
        const seconds = Math.round(timeLeft - (hours * 3600) - (minutes * 60));

        const hourString = hours + " " + ((hours == 1) ? "hour" : "hours");
        const minuteString = minutes + " " + ((minutes == 1) ? "minute" : "minutes");
        const secondString = seconds + " " + ((seconds == 1) ? "second" : "seconds");

        if (hours >= 1) {
          return msg.send(`Still ${hourString}, ${minuteString} and ${secondString} left... Hang on!`);
        } else if (minutes >= 1) {
          return msg.send(`Still ${minuteString} and ${secondString} left... Almost there!`);
        } else {
          return msg.send(`Only ${secondString} left! Get ready!`);
        }
      }
    } else {
      return msg.send("Not today, I'm sorry...");
    }
  })
;

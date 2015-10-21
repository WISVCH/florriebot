# Description:
#   Give the remaining time until the /Pub opens
#
# Commands:

module.exports = (robot) ->
  robot.hear /(?:is het (al )?pubtijd|is it pubtime)/i, (msg) ->
    now = new Date

    if now.getDay() is 3 or now.getDay() is 5
      # /Pub opens at 16:00:00
      dateOpen = new Date
      dateOpen.setHours(16)
      dateOpen.setMinutes(0)
      dateOpen.setSeconds(0)

      timeLeft = (dateOpen - now) / 1000

      if timeLeft <= 0
        msg.send("YES! Go grab a beer! :beers:")
      else
        hours = Math.floor(timeLeft / 60 / 60)
        minutes = Math.floor(timeLeft / 60) - hours * 60
        seconds = timeLeft - hours * 3600 - minutes * 60

        hourString = hours + " " + `((hours == 1) ? "hour" : "hours")`
        minuteString = minutes + " " + `((minutes == 1) ? "minute" : "minutes")`
        secondString = seconds + " " + `((seconds == 1) ? "second" : "seconds")`

        if hours >= 1
          msg.send("Still " + hourString + ", " + minuteString + " and " + secondString + " left... Hang on!")
        else if minutes >= 1
          msg.send("Still " + minuteString + " and " + secondString + " left... Almost there!")
        else
          msg.send("Only " + secondString + " left! Get ready!")
    else
      msg.send("Not today, I'm sorry...")

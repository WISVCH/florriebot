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
        if timeLeft > 60*60
          msg.send("Still " + Math.round(timeLeft / 60 / 60) + " hours left... Hang on!")
        else if timeLeft > 60
          msg.send("Still " + Math.round(timeLeft / 60) + " minutes left... Almost there!")
        else
          msg.send("Only " + timeLeft + " seconds left! Get ready!")
    else
      msg.send("Not today, I'm sorry...")
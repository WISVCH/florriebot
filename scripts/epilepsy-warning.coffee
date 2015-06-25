# Description:
#   Warn about epilepsy
#
# Commands:

module.exports = (robot) ->
  robot.hear /(?:strobe|epilepsy|epilepsie)/i, (msg) ->
    msg.send "WARNING! http://silviolorusso.com/wp-content/uploads/2013/09/epilepsy-warning.gif"

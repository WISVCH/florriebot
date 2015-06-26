# Description:
#   Warn about epilepsy
#
# Commands:

module.exports = (robot) ->
  robot.hear /(?:strobe|epilepsy|epilepsie)/i, (msg) ->
    msg.send "WARNING! http://blogfiles.wfmu.org/KF/2012/12/19/epilepsy_warning.gif"

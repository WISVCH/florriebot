# Description:
#   Warn about epilepsy
#
# Commands:

module.exports = (robot) ->
  robot.hear /(?:strobe|epilepsy|epilepsie)/i, (msg) ->
    strobes = [
      'http://silviolorusso.com/wp-content/uploads/2013/09/epilepsy-warning.gif',
      'http://blogfiles.wfmu.org/KF/2012/12/19/epilepsy_warning.gif',
      'http://cdn.yourepeat.com/media/gif/000/209/271/e3cde5c8359e2b41f864917e3dc30bf0.gif',
      'http://orig00.deviantart.net/4993/f/2012/363/9/3/monitor_self_test__epilepsy_warning__by_megabunneh-d5plsqi.gif',
      'http://media1.giphy.com/media/DOyoCmR7sCxHy/giphy.gif',
      'http://i258.photobucket.com/albums/hh259/canibus86/SEIZURE.gif',
      'http://i.imgur.com/1VV9iAO.gif',
      'http://24.media.tumblr.com/c7182f9fe0d25b2c4918d44432cf8c37/tumblr_mvg8i85TDQ1smtd9go1_500.gif',
    ]
    msg.send 'WARNING! ' + msg.random strobes

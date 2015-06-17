# Description:
#   anonymous gossip
#
# Commands:
#   hubot gossip <message> - Sends <message> to #gossip on Slack

module.exports = (robot) ->
  if robot.adapterName == 'slack'
    robot.respond /gossip[\s]+(.*)/i, (msg) ->
      msg = msg.match[1]
      robot.customMessage {channel: '#anon', text: msg}
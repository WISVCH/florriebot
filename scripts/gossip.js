// Description:
//   anonymous gossip
//
// Commands:
//   hubot gossip <message> - Sends <message> to #gossip on Slack

module.exports = function(robot) {
  if (robot.adapterName === 'slack') {
    return robot.respond(/gossip[\s]+(.*)/i, function(msg) {
      msg = msg.match[1];
      return robot.messageRoom('#anon', msg);
    });
  }
};

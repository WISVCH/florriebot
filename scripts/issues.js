// Description:
//   Create GitHub issues for CH beheer and PC.COM. Please be concise.
//
// Dependencies:
//   octonode
//
// Configuration:
//   HUBOT_GITHUB_TOKEN = <accessToken>
//
// Commands:
//   @pccom issue (me) <query> - Creates a new issue and tags it 'pccom'
//   @beheer issue (me) <query> - Creates a new issue and tags it 'beheer'

const github = require('octonode');

const githubToken = process.env.HUBOT_GITHUB_TOKEN;

module.exports = function(robot) {
  if (githubToken == null) {
    robot.logger.error("Missing HUBOT_GITHUB_TOKEN in environment");
    return;
  }
  return robot.listen(
    function(message) {
      // The following fails due to a bug in the hubot-slack adapter
      // See https://github.com/slackhq/hubot-slack/issues/288
      //match = message.text?.match /^@(pccom|beheer) issue (?:me )?(.*)/i

      // Match the raw text for now. Note that this only works for slack
      const match = message.rawText != null ? message.rawText.match(/^(?:<!subteam\^[A-Z0-9]{9}\|)@(pccom|beheer)> issue (?:me )?(.*)/i) : undefined;

      // some clients contain an e-mail address, use that if present
      const nameText = message.user.email_address ? `[${message.user.name}](mailto:${message.user.email_address})` : message.user.name;
      if (match) {
        let issue;
        return issue = {
          title: match[2],
          body: `Issue added by ${nameText}`,
          labels: ['slack', match[1]]
        };
      } else {
        return false;
      }
    },
    function(response) {
      // response.match contains the return value of the matcher function defined above.
      if (response.match) {
        const client = github.client(githubToken);
        return client.repo("WISVCH/pccom-beheer").issue(response.match, function(err, data, headers) {
          if (err) {
            return response.reply(`Something went wrong while communicating with GitHub, sorry ${response.message.user.name}!`);
          } else {
            return response.reply(`Thanks ${response.message.user.name}, I created an issue for you: ${response.match.title}`);
          }
      });
      }
  });
};

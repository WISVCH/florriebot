# Description:
#   Create GitHub issues for CH beheer and PC.COM. Please be concise.
#
# Dependencies:
#   octonode
#
# Configuration:
#   HUBOT_GITHUB_TOKEN = <accessToken>
#
# Commands:
#   @pccom issue (me) <query> - Creates a new issue and tags it 'pccom'
#   @beheer issue (me) <query> - Creates a new issue and tags it 'beheer'

github = require 'octonode'

githubToken = process.env.HUBOT_GITHUB_TOKEN;

module.exports = (robot) ->
  unless githubToken?
    robot.logger.error "Missing HUBOT_GITHUB_TOKEN in environment"
    return
  robot.listen(
    (message) ->
      # The following fails due to a bug in the hubot-slack adapter
      # See https://github.com/slackhq/hubot-slack/issues/288
      #match = message.text?.match /^@(pccom|beheer) issue (?:me )?(.*)/i

      # Match the raw text for now. Note that this only works for slack
      match = message.rawText?.match /^(?:<!subteam\^[A-Z0-9]{9}\|)@(pccom|beheer)> issue (?:me )?(.*)/i
      if match
        issue =
          title: match[2],
          body: "Issue added by #{message.user.name}"
          labels: ['slack', match[1]]
      else
        false
    (response) ->
      # response.match contains the return value of the matcher function defined above.
      if response.match
        client = github.client githubToken
        client.repo("WISVCH/pccom-beheer").issue response.match, (err, data, headers) ->
          if err
            response.reply "Something went wrong while communicating with GitHub, sorry #{response.message.user.name}!"
          else
            response.reply "Thanks #{response.message.user.name}, I created an issue for you: #{response.match.title}"
  )

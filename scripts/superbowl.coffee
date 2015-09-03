# Description:
#   Superb owl
#
# Commands:
#   hubot owl - Returns a superb owl

owls = {
  "lastRefresh": 0,
  "data": null
}

timeout = 24 * 60 * 60 * 1000   # 1 day

module.exports = (robot) ->
  robot.respond /(?:superb[\s]*)?(?:owl)(?:[\s]+me)?/i, (msg) ->
    getOwl(msg)

getOwl = (msg) ->
  if owls.lastRefresh + timeout < Date.now()
    newOwls = msg.http('https://api.reddit.com/r/superbowl')
      .get() (err, res, body) ->
        if err
          return
        owls.lastRefresh = Date.now()
        owls.data = JSON.parse(body)
        getOwl(msg)
    return
  owl = msg.random owls.data.data.children.filter((item) ->
    if item == null
      return false
    return item.data.domain == 'i.imgur.com' || item.data.domain == 'imgur.com')
  msg.send owl.data.url
  
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
imgurRegex = /https?:\/\/(?:www\.)?(?:i\.)?imgur\.com\/(.*?)(?:[#\/\.].*|$)/i

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
    return item.data.url.match(imgurRegex) != null
  ).map((item) ->
    match = item.data.url.match imgurRegex
    if match != null
      return match[1]
    return null   # should be impossible
  )
  if owl != null
    msg.send 'https://i.imgur.com/' + owl + '.gifv'

# Description:
#   Search a defined subreddit for imgur images.
#
# Commands:
#   hubot owl - Returns a superb owl
#   hubot boob(s) (me) - Returns me some boobs! NSFW of course.
#   hubot /r/<subreddit> - Return a "hot" image from the given reddit.com subreddit

meta = {
  "lastRefresh": {
    "superbowl": 0,
    "boobs": 0
  },
  "data": {
    "superbowl": null,
    "boobs": null
  }
}

timeout = 24 * 60 * 60 * 1000   # 1 day
imgurRegex = /https?:\/\/(?:www\.)?(?:i\.)?imgur\.com\/(.*)(?:[#\/\.].*|$)/i

module.exports = (robot) ->
  robot.respond /(?:superb[\s]*)?(?:owl)(?:[\s]+me)?/i, (msg) ->
    getImage(msg, 'superbowl')
  robot.respond /(?:boob(s?))(?:[\s]+me)?/i, (msg) ->
    getImage(msg, 'boobs')
  robot.respond /\/?r\/([A-Za-z0-9][A-Za-z0-9_]{2,20})/i, (msg) ->
    getImage(msg, msg.match[1])

getImage = (msg, subreddit) ->
  if meta.lastRefresh[subreddit] == undefined
    meta.lastRefresh[subreddit] = 0
    meta.data[subreddit] = null

  if meta.lastRefresh[subreddit] + timeout < Date.now()
    msg.http('https://api.reddit.com/r/' + subreddit)
      .get() (err, res, body) ->
        if err
          return
        meta.lastRefresh[subreddit] = Date.now()
        meta.data[subreddit] = JSON.parse(body)
        getImage(msg, subreddit)
    return
  image = msg.random meta.data[subreddit].data.children.filter((item) ->
    return item.data.url.match(imgurRegex) != null
  ).map((item) ->
    match = item.data.url.match imgurRegex
    if match != null
      if match[1].match(/\./) == null
        return match[1] + '.gifv'
      else
        return match[1].replace /\.gif$/i, '.gifv'
    return null   # should be impossible
  )
  if image?
    msg.send 'https://i.imgur.com/' + image

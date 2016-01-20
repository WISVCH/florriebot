# Description:
#   Search a defined subreddit for imgur images.
#
# Commands:
#   hubot owl - Returns a superb owl
#   hubot boob(s) (me) - Returns me some boobs! NSFW of course.

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
imgurRegex = /https?:\/\/(?:www\.)?(?:i\.)?imgur\.com\/(.*?)(?:[#\/\.].*|$)/i

module.exports = (robot) ->
  robot.respond /(?:superb[\s]*)?(?:owl)(?:[\s]+me)?/i, (msg) ->
    getImage(msg, 'superbowl')
  robot.respond /(?:boob(s?))(?:[\s]+me)?/i, (msg) ->
    getImage(msg, 'boobs')

getImage = (msg, subreddit) ->
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
      return match[1]
    return null   # should be impossible
  )
  if image != null
    msg.send 'https://i.imgur.com/' + image + '.gifv'

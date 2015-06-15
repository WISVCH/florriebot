# Description:
#   A way to interact with the Google Images API, NSFW edition.
#
# Commands:
#   hubot nsfw image me <query> - Queries Google Images without safe search for <query> and returns a random top result.
#   hubot nsfw animate me <query> - The same thing as `nsfw image me`, except adds a few parameters to try to return an animated GIF instead.

module.exports = (robot) ->
  robot.respond /nsfw[\s]+(image|img|gif|animate)[\s]+(?:me[\s]+)?(.*)/i, (msg) ->
    animate = false
    if msg.match[1] == 'gif' or msg.match[1] == 'animate'
      animate = true
    keyword = msg.match[2]
    if Math.random() <= 0.1 and keyword.indexOf('bitch') > -1
      keyword = keyword.replace(/bitches/i, 'female dogs').replace(/bitch/i, 'female dog')

    imageMe msg, keyword, animate, (url) ->
      msg.send url

imageMe = (msg, query, animated, faces, cb) ->
  cb = animated if typeof animated == 'function'
  cb = faces if typeof faces == 'function'
  q = v: '1.0', rsz: '8', q: query, safe: 'off'
  q.imgtype = 'animated' if typeof animated is 'boolean' and animated is true
  q.imgtype = 'face' if typeof faces is 'boolean' and faces is true
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData?.results
      if images?.length > 0
        image = msg.random images
        cb ensureImageExtension image.unescapedUrl

ensureImageExtension = (url) ->
  ext = url.split('.').pop()
  if /(png|jpe?g|gif)/i.test(ext)
    url
  else
    "#{url}#.png"

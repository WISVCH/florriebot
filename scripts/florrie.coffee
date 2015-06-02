# Description:
#   Special Florrie features
#
# Commands:
#   hubot me - Florrie <3
#   hubot me gif - Florrie.gif <3

module.exports = (robot) ->
  robot.respond /(florrie )?me gif/i, (msg) ->
    imageMe msg, 'florrie', true, (url) ->
      msg.send url

  robot.respond /(florrie )?me(?! gif)/i, (msg) ->
    imageMe msg, 'florrie', (url) ->
      msg.send url

imageMe = (msg, query, animated, faces, cb) ->
  cb = animated if typeof animated == 'function'
  cb = faces if typeof faces == 'function'
  randomstart = Math.floor(Math.random() * 10)
  q = v: '1.0', rsz: '8', start: randomstart, q: query, safe: 'off'
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

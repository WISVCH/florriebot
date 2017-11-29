// Description:
//   A way to interact with the Google Images API, NSFW edition.
//
// Commands:
//   hubot nsfw image me <query> - Queries Google Images without safe search for <query> and returns a random top result.
//   hubot nsfw animate me <query> - The same thing as `nsfw image me`, except adds a few parameters to try to return an animated GIF instead.

module.exports = robot =>
  robot.respond(/nsfw[\s]+(image|img|gif|animate)[\s]+(?:me[\s]+)?(.*)/i, function(msg) {
    let animate = false;
    if ((msg.match[1] === 'gif') || (msg.match[1] === 'animate')) {
      animate = true;
    }
    let keyword = msg.match[2];
    if ((Math.random() <= 0.75) && (keyword.indexOf('bitch') > -1)) {
      keyword = keyword.replace(/bitches/i, 'female dogs').replace(/bitch/i, 'female dog');
    }

    return imageMe(msg, keyword, animate, url => msg.send(url));
  })
;

var imageMe = function(msg, query, animated, faces, cb) {
  if (typeof animated === 'function') { cb = animated; }
  if (typeof faces === 'function') { cb = faces; }
  const q = {v: '1.0', rsz: '8', q: query, safe: 'off'};
  if ((typeof animated === 'boolean') && (animated === true)) { q.imgtype = 'animated'; }
  if ((typeof faces === 'boolean') && (faces === true)) { q.imgtype = 'face'; }
  return msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get()(function(err, res, body) {
      let images = JSON.parse(body);
      images = images.responseData != null ? images.responseData.results : undefined;
      if ((images != null ? images.length : undefined) > 0) {
        const image = msg.random(images);
        return cb(ensureImageExtension(image.unescapedUrl));
      }
  });
};

var ensureImageExtension = function(url) {
  const ext = url.split('.').pop();
  if (/(png|jpe?g|gif)/i.test(ext)) {
    return url;
  } else {
    return `${url}#.png`;
  }
};

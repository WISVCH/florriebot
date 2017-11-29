// Description:
//   All praise GabeN
//
// Commands:
//   hubot gaben me <query> - Returns gentleman gaben on top of <query>
//   hubot cage me <query> - Returns a caged version of <query>
//   hubot putin me <query> - Returns your glorious leader on top of <query>

module.exports = robot =>
  robot.respond(/(gaben|cage|putin)[\s]+(?:me[\s]+)?(.*)/i, function(msg) {
    const keyword = msg.match[2];
    const type = msg.match[1].toLowerCase();
    return imageMe(msg, keyword, false, true, url => msg.send(`https://abb.ink/${type}/?${encodeURIComponent(url)}`));
  })
;

var imageMe = function(msg, query, animated, faces, cb) {
  if (typeof animated === 'function') { cb = animated; }
  if (typeof faces === 'function') { cb = faces; }
  const q = {v: '1.0', rsz: '8', q: query, safe: 'active'};
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

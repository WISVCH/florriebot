// Description:
//   Hammertime
//
// Commands:

module.exports = robot =>
  robot.hear(/^stop$/i, function(msg) {
    msg.send("HAMMERTIME!");
    return imageMe(msg, 'hammertime', true, url => msg.send(url));
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

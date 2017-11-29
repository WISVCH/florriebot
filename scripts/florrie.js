// Description:
//   Special Florrie features
//
// Commands:
//   hubot me - Florrie <3
//   hubot me gif - Florrie.gif <3

module.exports = function(robot) {
  robot.respond(/(florrie )?me(?! gif)/i, msg =>
    imageMe(msg, 'florrie', url => msg.send(url))
  );

  robot.respond(/(florrie )?me gif/i, msg =>
    imageMe(msg, 'florrie', true, url => msg.send(url))
  );

  return robot.hear(/gif me florrie/i, msg =>
    imageMe(msg, 'florrie', true, url => msg.send(url))
  );
};

var imageMe = function(msg, query, animated, faces, cb) {
  if (typeof animated === 'function') { cb = animated; }
  if (typeof faces === 'function') { cb = faces; }
  const randomstart = Math.floor(Math.random() * 10);
  const q = {v: '1.0', rsz: '8', start: randomstart, q: query, safe: 'off'};
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

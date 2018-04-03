// Description:
//   Search a defined subreddit for imgur images.
//
// Commands:
//   hubot owl - Returns a superb owl
//   hubot boob(s) (me) - Returns me some boobs! NSFW of course.
//   hubot /r/<subreddit> - Return a "hot" image/video/selfpost from the given reddit.com subreddit

const request = require('request');

const meta = {
  "lastRefresh": {
    "superbowl": 0,
    "boobs": 0
  },
  "data": {
    "superbowl": null,
    "boobs": null
  },
  "imgurContentTypes": {}
};

const timeout = 24 * 60 * 60 * 1000;   // 1 day
const imgurRegex = /https?:\/\/(?:www\.)?(?:i\.)?imgur\.com\/([^\.]*)(?:[\?#\/\.].*$)?/i;
const youtubeRegex = /http:\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-]+)(&(amp;)?[\w\?=]*)?/i;

module.exports = function(robot) {
  robot.respond(/(?:superb[\s]*)?(?:owl)(?:[\s]+me)?/i, msg => getImage(msg, 'superbowl', robot.adapterName));
  robot.respond(/(?:boob(s?))(?:[\s]+me)?/i, msg => getImage(msg, 'boobs', robot.adapterName));
  return robot.respond(/\/?r\/([A-Za-z0-9][A-Za-z0-9_]{2,20})\/?/i, msg => getImage(msg, msg.match[1], robot.adapterName));
};

const sendLink = function(msg, imgurId, title, contentType) {
  if (contentType === 'image/gif') {
    imgurId += '.gifv';
  } else {
    imgurId += '.jpg';
  }
  return msg.send(title + '\nhttps://i.imgur.com/' + imgurId);
};

var getImage = function(msg, subreddit, adapter) {
  if (meta.lastRefresh[subreddit] === undefined) {
    meta.lastRefresh[subreddit] = 0;
    meta.data[subreddit] = null;
  }

  if ((meta.lastRefresh[subreddit] + timeout) < Date.now()) {
    msg.http(`https://api.reddit.com/r/${subreddit}`)
      .get()(function(err, res, body) {
        if (err) {
          return;
        }
        meta.lastRefresh[subreddit] = Date.now();
        meta.data[subreddit] = JSON.parse(body);
        return getImage(msg, subreddit);
    });
    return;
  }
  const item = msg.random(meta.data[subreddit].data.children.filter(function(item) {
    const matchesImgur = item.data.url.match(imgurRegex) !== null;
    const matchesYoutube = item.data.url.match(youtubeRegex) !== null;
    const isSelf = item.data.is_self;
    const isStickied = item.data.stickied;
    return !isStickied && (matchesImgur || matchesYoutube || isSelf);
  }).map(function(item) {
    let type;
    const matchesImgur = item.data.url.match(imgurRegex);
    const matchesYoutube = item.data.url.match(youtubeRegex);
    const isSelf = item.data.is_self;

    if (isSelf) {
      if (item.data.selftext.trim() !== '') {
        item.data.selftext = `\n> ${item.data.selftext.trim().split('\n\n').join('\n> ')}`;
      }
      // abuse internal Slack url mechanism
      if (adapter === 'slack') {
        return {type: 'self', link: item.data.url, message: `<${item.data.url}|${item.data.title}>${item.data.selftext}`};
      } else {
        return {type: 'self', link: item.data.url, message: item.data.url + '\n' + item.data.title + item.data.selftext};
      }
    }
    if (matchesImgur) {
      type = 'imgur';
      if (matchesImgur[1] === 'a') {
        matchesImgur[1] = item.data.url;
        type = 'youtube';   // hack to post album links correctly (skip type detection)
      }
      return {type, link: matchesImgur[1], message: item.data.title};
    }
    if (matchesYoutube) {
      return {type: 'youtube', link: item.data.url, message: item.data.title};
    }
  })
  );
  if (item != null) {
    switch (item.type) {
      case 'self': return msg.send(item.message);
      case 'imgur':
        if (meta.imgurContentTypes[item.link]) {
          return sendLink(msg, item.link, item.message, meta.imgurContentTypes[item.link]);
        } else {
          return request.head(`https://i.imgur.com/${item.link}.png`, function(error, response, body) {
            if (error != null) {
              return;
            }
            const contentType = response.headers['content-type'];
            meta.imgurContentTypes[item.link] = contentType;
            return sendLink(msg, item.link, item.message, contentType);
          });
        }
      case 'youtube': return msg.send(item.message + '\n' + item.link);
    }
  }
};

// Description:
//   Returns the URL of the first google hit for a query
//
// Dependencies:
//   None
//
// Configuration:
//   None
//
// Commands:
//   hubot google me <query> - Googles <query> & returns 1st result's URL
//
// Author:
//   searls

const request = require('request');

module.exports = robot =>
  robot.respond(/(google)( me)? (.*)/i, msg =>
    googleMe(msg, msg.match[3], url => msg.send(url))
  )
;

var googleMe = (msg, query, cb) =>
  request({url:'https://www.google.com/search',qs:{q: query}}, (err, res, body) => cb(__guard__(body.match(/class="r"><a href="\/url\?q=([^"]*)(&amp;sa.*)">/), x => x[1]) || `Sorry, Google had zero results for '${query}'`))
;

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}

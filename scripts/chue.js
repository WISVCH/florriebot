// Description:
//   CHue
//
// Commands:
//   hubot chue alert [<lamp>] [<timeout>] - Blink hue lamps at CH for <timeout> milliseconds
//   hubot chue colour [<lamp>] #<hex> - Change hue lamp <lamp> (or all) to colour <hex>
//   hubot chue colourloop [<lamp>] - Set hue lamps on colourloop
//   hubot chue random [<lamp>] - Change hue lamps to a random colour
//   hubot bvoranje - B'voranje :owl:
//
// Configuration:
//   HUBOT_CHUE_URL = <scheme>://<host:port>/<basepath>/

module.exports = function(robot) {
  const chueURL = process.env.HUBOT_CHUE_URL;
  if (chueURL == null) {
    robot.logger.error("Missing HUBOT_CHUE_URL in environment");
    return;
  }

  robot.respond(/chue alert\s+(\d+)\s+(\d+)|chue alert\s+(\d+)|chue alert/i, function(msg) {
    const timeout = msg.match[2] || msg.match[3] || 5502;
    return robot.http(`${chueURL}alert?timeout=${timeout}`)
        .get()(function(err, res, body) {
            if (res.statusCode === 200) {
              return msg.emote("Blinking hue lamps at CH");
            } else {
              return msg.emote(`Sorry... ${body}`);
            }
    });
  });

  robot.respond(/chue random ?(\d+)?/i, function(msg) {
    const lamp = msg.match[1] === undefined ? "" : msg.match[1];
    return robot.http(`${chueURL}random/${lamp}`)
        .get()(function(err, res, body) {
            if (res.statusCode === 200) {
              return msg.emote(body);
            } else {
              return msg.emote(`Sorry... ${body}`);
            }
    });
  });

  robot.respond(/chue colou?rloop ?(\d+)?/i, function(msg) {
    const lamp = msg.match[1] === undefined ? "" : msg.match[1];
    return robot.http(`${chueURL}colorloop/${lamp}`)
        .get()(function(err, res, body) {
            if (res.statusCode === 200) {
              return msg.emote("Put on a colourloop at CH");
            } else {
              return msg.emote(`Sorry... ${body}`);
            }
    });
  });

  robot.respond(/chue colou?r (\d+)? ?#?(.*)/i, function(msg) {
    const lamp = msg.match[1] === undefined ? "" : msg.match[1];
    const colour = msg.match[2];

    return robot.http(`${chueURL}color/${colour}/${lamp}`)
        .get()(function(err, res, body) {
            if (res.statusCode === 200) {
              return msg.emote(body);
            } else {
              return msg.emote(`Sorry... ${body}`);
            }
    });
  });

  return robot.respond(/bvoranje/i, msg =>
    robot.http(`${chueURL}oranje`)
        .get()(function(err, res, body) {
            if (res.statusCode === 200) {
              return msg.emote(":owl:");
            } else {
              return msg.emote(`Sorry... ${body}`);
            }
    })
  );
};

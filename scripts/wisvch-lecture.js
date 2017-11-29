// Description:
//   Easily sign up for WISV.ch/lecture
//
// Commands:
//   hubot lecture me <phonenumber> - Signs you up for the next WISV CH lecture with request code/phonenumber

const signUpURL = 'https://wisv.ch/lecture';

module.exports = robot =>
  robot.respond(/lecture[\s]+(?:me[\s]+)?([\d]+)/i, function(msg) {
    const { message } = msg;
    if ((message.user == null)) {
      return msg.send(`Can't find your user details :cry:, you can manually sign up here: ${signUpURL}`);
    } else {
      const phone = msg.match[1];
      const email = message.user.email_address;
      const name = message.user.real_name || message.user.name;
      try {
        return signUp(name, email, phone, function(err, success) {
          if (err) {
            msg.send(err);
            return;
          }
          if (success) {
            return msg.send(`Signed up @${name}`);
          } else {
            return msg.send(`Signing up unsuccessful :cry:, you can manually sign up here: ${signUpURL}`);
          }
        });
      } catch (error) {
        const err = error;
        return msg.send(err);
      }
    }
  })
;

const request = require('request');

const getForm = function(cb) {
  let body = '';
  request.get(signUpURL)
  .on('error', function(err) {
    cb(err, false);
  }).on('response', function(response) {
    if (response.statusCode !== 200) {
      cb(`Expected status 200 from Google, received ${response.statusCode}`, false);
    }
  }).on('data', function(data) {
    body += data;
  }).on('end', function() {
    cb(null, body);
  });
};

const sendResponse = function(url, formFields, cb) {
  let body = '';
  request.post(url).form(formFields).on('error', function(err) {
    cb(err, false);
  }).on('response', function(response) {
    if (response.statusCode !== 200) {
      cb(`Expected status 200 from Google, received ${response.statusCode}`, false);
    }
  }).on('data', function(data) {
    body += data;
  }).on('end', function() {
    const success = /ss-assignment-turned-in/.test(body);
    cb(null, success);
  });
};

var signUp = function(name, email, phone, cb) {
  getForm(function(err, data) {
    if (err) {
      cb(err, false);
      return;
    }
    const postRegExp = /<form action="(.+?)"/;
    const inputRegExp = '<input.*name="(.+?)".*value="([^]*?)"(?:.*aria-label="([^\\s]+)[^]+?")?';
    const inputRegExpAll = new RegExp(inputRegExp, 'ig');
    const inputRegExpSingle = new RegExp(inputRegExp, 'i');
    const matches = data.match(inputRegExpAll);
    const formFields = {};
    if ((matches == null)) {
      cb('Form already closed', false);
      return;
    }
    matches.forEach(function(match) {
      const parts = match.match(inputRegExpSingle);
      switch (parts[3]) {
        case 'Full':
          parts[2] = name;
          break;
        case 'E-Mail':
          parts[2] = email;
          break;
        case 'Phone':
          parts[2] = phone;
          break;
      }
      formFields[parts[1]] = parts[2];
    });
    const postURL = data.match(postRegExp);
    sendResponse(postURL[1], formFields, function(err, success){
      cb(err, success);
    });
  });
};

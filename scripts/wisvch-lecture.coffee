# Description:
#   Easily sign up for WISV.ch/lecture
#
# Commands:
#   hubot lecture me <phonenumber> - Signs you up for the next WISV CH lecture with request code/phonenumber

signUpURL = 'https://wisv.ch/lecture'

module.exports = (robot) ->
  robot.respond /lecture[\s]+(?:me[\s]+)?(.*)/i, (msg) ->
    message = msg.message
    if !message.user?
      msg.send 'Can\'t find your user details :cry:, you can manually sign up here: ' + signUpURL
    else
      phone = msg.match[1]
      email = message.user.email_address
      name = message.user.real_name || message.user.name
      try
        signUp name, email, phone, (err, success) ->
          if err
            msg.send err
            return
          if success
            msg.send 'Signed up @'+ name
          else
            msg.send 'Signing up unsuccessful :cry:, you can manually sign up here: ' + signUpURL
      catch err
        msg.send err

request = require('request')

getForm = (cb) ->
  body = ''
  request.get(signUpURL)
  .on('error', (err) ->
    cb(err, false)
    return
  ).on('response', (response) ->
    if response.statusCode != 200
      cb('Expected status 200 from Google, received ' + response.statusCode, false)
    return
  ).on('data', (data) ->
    body += data
    return
  ).on 'end', ->
    cb(null, body)
    return
  return

sendResponse = (url, formFields, cb) ->
  body = ''
  request.post(url).form(formFields).on('error', (err) ->
    cb(err, false)
    return
  ).on('response', (response) ->
    if response.statusCode != 200
      cb('Expected status 200 from Google, received ' + response.statusCode, false)
    return
  ).on('data', (data) ->
    body += data
    return
  ).on 'end', ->
    success = /Your response has been recorded/.test(body)
    cb(null, success)
    return
  return

signUp = (name, email, phone, cb) ->
  getForm (err, data) ->
    if err
      cb(err, false)
      return
    postRegExp = /<form action="(.+?)"/
    inputRegExp = '<input.*name="(.+?)".*value="([^]*?)"(?:.*aria-label="([^\\s]+)[^]+?")?'
    inputRegExpAll = new RegExp(inputRegExp, 'ig')
    inputRegExpSingle = new RegExp(inputRegExp, 'i')
    matches = data.match(inputRegExpAll)
    formFields = {}
    if !matches?
      cb('Form already closed', false)
      return
    matches.forEach (match) ->
      parts = match.match(inputRegExpSingle)
      switch parts[3]
        when 'Full'
          parts[2] = name
        when 'E-Mail'
          parts[2] = email
        when 'Phone'
          parts[2] = phone
      formFields[parts[1]] = parts[2]
      return
    postURL = data.match(postRegExp)
    sendResponse postURL[1], formFields, (err, success)->
      cb(err, success)
      return
    return
  return

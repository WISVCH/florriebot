# Description:
#   Easily sign up for WISV.ch/lecture
#
# Commands:
#   hubot lecture <phonenumber> - Signs you up for the next WISV CH lecture with request code/phonenumber

module.exports = (robot) ->
  robot.respond /(lecture)[\s]+(.*)/i, (msg) ->
    if !msg.user?
      msg.send 'Can\'t find your user details :cry:, you can manually sign up here: https://wisv.ch/lecture'
    else
      phone = msg.match[1]
      email = msg.user.email_address
      name = msg.user.real_name || msg.user.name
      try
        signUp name, email, phone, (success) ->
          msg.send 'Signed up @'+ name
      catch err
        msg.send err

request = require('request')

getForm = (cb) ->
  body = ''
  request.get('https://wisv.ch/lecture')
  .on('error', (err) ->
    throw err
    return
  ).on('response', (response) ->
    if response.statusCode != 200
      throw 'Expected status 200 from Google, received ' + response.statusCode
    return
  ).on('data', (data) ->
    body += data
    return
  ).on 'end', ->
    cb bodya
    return
  return

sendResponse = (url, formFields, cb) ->
  body = ''
  request.post(url).form(formFields).on('error', (err) ->
    throw err
    return
  ).on('response', (response) ->
    if response.statusCode != 200
      throw 'Expected status 200 from Google, received ' + response.statusCode
    return
  ).on('data', (data) ->
    body += data
    return
  ).on 'end', ->
    console.log body
    success = /Your response has been recorded/.test(body)
    cb success
    return
  return

signUp = (name, email, phone, cb) ->
  getForm (data) ->
    postRegExp = /<form action="(.+?)"/
    inputRegExp = '<input.*name="(.+?)".*value="([^]*?)"(?:.*aria-label="([^\\s]+)[^]+?")?'
    inputRegExpAll = new RegExp(inputRegExp, 'ig')
    inputRegExpSingle = new RegExp(inputRegExp, 'i')
    matches = data.match(inputRegExpAll)
    formFields = {}
    if matches == null
      throw 'Form already closed'
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
    sendResponse postURL[1], formFields, ->
      cb true
      return
    return
  return

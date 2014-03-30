fs     = require 'fs'
path   = require 'path'
jade   = require 'jade'
mailer = require 'nodemailer'
_      = require 'underscore'

config =
  smtp:
    service: "Mandrill"
    auth:
      user: "tarkus@fuyun.io"
      pass: "OzWxBGIKRBs7IZrOvsUEWg"
  view_path: "#{__dirname}/../../views/mailer"

templates = {}

files = fs.readdirSync config.view_path

if files
  for file in files
    fullpath = path.join config.view_path, file
    templates[path.basename(file, '.jade')] = fs.readFileSync(fullpath).toString()

transport = mailer.createTransport 'SMTP', config.smtp

send_function = (req, res, next) ->
  (mail, options, variables, callback) ->
    defaults =
      from: "币讯 <noreply@btcxun.com>"

    if typeof variables is 'function'
      callback = variables
      variables = {}

    options = _.extend options, defaults

    return callback "No Recipient" unless options.to?
    return callback "No Such Mail" unless templates["#{mail}.txt"]?

    unless options.subject
      options.subject = res.locals.t("mailer.#{mail}.subject")

    return transport.sendMail options, callback if options.text or options.html

    variables.t = res.locals.t

    jade.render templates["#{mail}.txt"], variables, (err, text) ->
      return callback err if err
      options.text = text
      unless (templates["#{mail}.html"] and templates['layout.html'])
        return transport.sendMail options, callback

      jade.render templates['layout.html'], (err, html) ->
        options.html = html
        jade.render templates["#{mail}.html"], variables, (err, html) ->
          options.html += html
          return transport.sendMail options, callback

exports.connect = ->
  (req, res, next) ->
    res.locals.sendmail = send_function req, res, next
    next()



  

    






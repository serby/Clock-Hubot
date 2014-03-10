# Description:
#   Look up npm package information
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot npm <package name> - returns npm package information
#
# Author:
#   redhotvengeance

HtmlParser = require "htmlparser"
Select     = require("soupselect").select

module.exports = (robot) ->
  robot.respond /npm (.*)/i, (msg) ->
    packageName = escape(msg.match[1])
    msg.http("https://www.npmjs.org/package/#{packageName}").get() (err, res, body) ->
      if err
        msg.send "I tried talking to npmjs.org, but it seems to be ignoring me."
      else
        if res.statusCode is 200
          handler = new HtmlParser.DefaultHandler()
          parser  = new HtmlParser.Parser handler

          parser.parseComplete body

          descriptionData = Select(handler.dom, ".description")
          metaData = Select(handler.dom, ".metadata")

          description = descriptionData[0].children[0].data.toString()
          maintainersArray = metaData[0].children[1].children[3].children
          maintainers = []
          for person in maintainersArray then do (person) =>
            if person.hasOwnProperty("children")
              maintainers.push person.children[1].children[1].data.toString().match(/(?=.\S)[\w].*/ig)

          lastUpdateString = metaData[0].children[3].children[3].children[2].data.toString()
          lastUpdate = lastUpdateString.match(/\S([0-9]* [\w]* [\w]*)/ig)
          versionString = metaData[0].children[3].children[3].children[1].children[0].data.toString()
          versionArray = versionString.match(/([0-9.])/ig)

          version = ''

          for digit in versionArray then do (digit) =>
            version += digit
          msg.send "#{packageName} #{version} by #{maintainers.join(", ")} ~ #{lastUpdate} :: #{description} :: http://ghub.io/#{packageName}"

        else
          msg.send "It looks like #{packageName} doesn't exist."

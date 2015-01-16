// Description:
//   Look up npm package information
//
// Dependencies:
//   "moment": "2.9.0"
//
// Configuration:
//   None
//
// Commands:
//   hubot npm <package name> - returns npm package information
//
// Author:
//   Paul Serby <paul.serby@clock.co.uk>

var npmApi = 'http://registry.npmjs.org/'
  , momemnt = require('moment')

function errorMessage(msg, package, error) {
  return msg.send('Error finding ' + package + ' in ' + npmApi + ' - ' + error)
}

module.exports = function(robot) {
  robot.respond(/npm (.*)/i, function(msg) {
    var package = msg.match[1]

    msg.send('Looking for ‘' + package + '’')
    msg.http(npmApi + encodeURIComponent(package)).get()(function(err, res, body) {
      var info
        , maintainers
        , latestVersion
        , lastPublished

      if (err) {
        return errorMessage(msg, package, err.message)
      }

      try {
        info = JSON.parse(body)
      } catch (e) {
        return errorMessage(msg, package, err.message)
      }

      if (info.error) {
        if (info.error === 'not_found') {
          return msg.send(package + ' doesn\'t exist in ' + npmApi)
        } else {
          return errorMessage(msg, package, info.error.reason)
        }
      }
      maintainers = info.maintainers.map(function(maintainer) {
        return maintainer.name
      }).join(', ')
      latestVersion = Object.keys(info.time).pop()
      lastPublished = momemnt(info.time[latestVersion]).fromNow()

      return msg.send(package + ' ' + latestVersion + ' by ' + maintainers
        + ' ~ ' + lastPublished + ' :: ' + info.description + ' :: ' + info.homepage)
    })
  })
}

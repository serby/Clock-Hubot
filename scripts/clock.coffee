# Description:
#   Github utility commands for Clock Limited
#
# Commands:
#   clockbot info - Reply with useful Clock information

module.exports = (robot) ->
    robot.respond /info for devs/i, (msg) ->

        dev_info = {
          "Dev Guide": "http://devguides.clock.co.uk/",
          "Node manual": "http://nodejs.org/api/",
          "MDN JS Reference": "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference"
        }

        msg.send "Some useful developer information; "
        for key, value of dev_info
          msg.send "#{key}: #{value}"

    robot.respond /info for everyone/i, (msg) ->

        info = {
          "Intranet": "https://intranet.clock.co.uk/",
        }

        msg.send "Some useful general information; "
        for key, value of info
          msg.send "#{key}: #{value}"

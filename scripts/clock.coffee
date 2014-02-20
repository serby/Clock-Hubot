# Description:
#   Github utility commands for Clock Limited
#
# Commands:
#   clockbot info - Reply with useful Clock information

module.exports = (robot) ->
    robot.respond /info/i, (msg) ->
        clock_info = {
          "Intranet": "https://intranet.clock.co.uk/",
        }

        dev_info = {
          "Dev Guide": "http://devguides.clock.co.uk/",
          "Node manual": "http://nodejs.org/api/",
          "MDN JS Reference": "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference"
        }
        msg.send "Some useful Clock information; "
        for key, value of clock_info
          msg.send "#{key}: #{value}"

        msg.send "\nSome useful Dev information; "
        for key, value of dev_info
          msg.send "#{key}: #{value}"

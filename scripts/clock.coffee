# Description:
#   Github utility commands for Clock Limited
#
# Commands:
#   clockbot info me - Reply with useful Clock information

module.exports = (robot) ->
    robot.respond /info/i, (response) ->
        info = {
          "Intranet": "https://intranet.clock.co.uk/"
        }
        msg.send "Some information; "
        for key, value of infor
          msg.send "#{key}: #{value}"

# Description:
#   Github utility commands for Clock Limited
#
# Commands:
#   clockbot info - Reply with useful Clock information

module.exports = (robot) ->
    robot.respond /info/i, (msg) ->
        info = {
          "Intranet": "https://intranet.clock.co.uk/"
        }
        msg.send "Some information; "
        for key, value of infor
          msg.send "#{key}: #{value}"

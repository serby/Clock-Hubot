# Description:
#   Github utility commands for Clock Limited
#
# Commands:
#   clock info me - Reply with link to roadmap

module.exports = (robot) ->
    robot.respond /clock info me/i, (response) ->
        info = "Test info"
        msg.send "Some info: #{info}"

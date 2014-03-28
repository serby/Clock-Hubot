# Description:
#   Make announcements on Slack
#
#
# Configuration:
#   HUBOT_ANNOUNCE_ROOMS
#
# Commands:
#   hubot announce <message> - Announce message

module.exports = (robot) ->
  robot.respond /announce [“|"|‘|'](.*)["|']/i, (msg) ->
    announcement = msg.match[1]
    robot.messageRoom 'test', announcement

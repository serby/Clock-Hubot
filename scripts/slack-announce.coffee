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

  allRooms = []
  if process.env.HUBOT_ANNOUNCE_ROOMS
    allRooms = process.env.HUBOT_ANNOUNCE_ROOMS.split(',')

  robot.respond /announce [“|"|‘|'](.*)["|']/i, (msg) ->
    announcement = msg.match[1]
    for room in allRooms
      robot.messageRoom room, announcement

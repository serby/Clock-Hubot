# Description:
#   Make announcements on Slack
#
#
# Configuration:
#   HUBOT_ANNOUNCE_ROOMS
#
# Commands:
#   hubot announce <message> - Announce message
#   hubot announce downtime "<service>" <timeframe> - Announcing downtime commencement

module.exports = (robot) ->

  allRooms = []
  if process.env.HUBOT_ANNOUNCE_ROOMS
    allRooms = process.env.HUBOT_ANNOUNCE_ROOMS.split(',')

  robot.respond /announce [“|"|‘|'](.*)["|']/i, (msg) ->
    announcement = msg.match[1]
    for room in allRooms
      robot.messageRoom room, announcement

  robot.respond /announce downtime [“|"|‘|'](.*)["|'] (.*)/i, (msg) ->
    fields = []
    fields.push
      title: "Field 1: Title"
      value: "Field 1: Value"
      short: true

    fields.push
      title: "Field 2: Title"
      value: "Field 2: Value"
      short: true

    payload =
      message: msg.message
      content:
        text: "Attachement Demo Text"
        fallback: "Fallback Text"
        pretext: "This is Pretext"
        color: "#FF0000"
        fields: fields

    robot.emit 'slack-attachment', payload

# Description:
#   Make announcements on Slack
#
#
# Configuration:
#   HUBOT_ANNOUNCE_ROOMS
#
# Commands:
#   hubot announce <message> - Announce message
#   hubot announce downtime for "<service>" starting <timeframe> - Syntactic sugar for announcing downtime commencement
#   hubot announce downtime complete for "<service>" - Syntactic sugar for announcing downtime completion

module.exports = (robot) ->

  allRooms = []
  if process.env.HUBOT_ANNOUNCE_ROOMS
    allRooms = process.env.HUBOT_ANNOUNCE_ROOMS.split(',')

  robot.respond /announce [“|"|‘|'](.*)["|'|”]/i, (msg) ->
    announcement = msg.match[1]
    for room in allRooms
      robot.messageRoom room, announcement

  robot.respond /announce downtime for [“|"|‘|'](.*)["|'|”] starting (.*)/i, (msg) ->
    service = msg.match[1]
    startTime = msg.match[2]
    fields = []
    fields.push
      title: "Service"
      value: service
      short: true

    fields.push
      title: "Starting"
      value: startTime
      short: true

    for room in allRooms
      msg.room = room
      payload =
        message: msg.message
        content:
          text: "The '#{service}' service will be going down for maintenance starting #{startTime}."
          fallback: "Downtime planned."
          pretext: "Downtime is planned!"
          color: "#FF0000"
          fields: fields
      robot.emit 'slack-attachment', payload
      msg.reply "Downtime announced."

  robot.respond /announce downtime complete for [“|"|‘|'](.*)["|'|”]/i, (msg) ->
    service = msg.match[1]
    fields = []
    fields.push
      title: "Service"
      value: service
      short: true

    for room in allRooms
      msg.room = room
      payload =
        message: msg.message
        content:
          text: "Maintenance for the '#{service}' service is complete."
          fallback: "Downtime over."
          pretext: "Maintenance is complete!"
          color: "#00FF00"
          fields: fields
      robot.emit 'slack-attachment', payload
      msg.reply "Maintenance completion announced."

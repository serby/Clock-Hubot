# Description:
#   Github utility commands for Clock Limited
#
# Commands:
#   hubot info available - Show which fields have information available
#   hubot info for <field> - Reply with useful Clock information based on field
#   hubot hangout - Reply with clock hangout link

available = "engineers, frontends, everyone"

info = {
    "engineers": {
        "Nodemanual": "http://nodejs.org/api/",
        "MDNJSReference": "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference"
    },
    "frontends": {
        "DevGuide": "http://devguides.clock.co.uk/"
    },
    "everyone": {
        "Intranet": "https://intranet.clock.co.uk/"
    }
}

module.exports = (robot) ->
  robot.respond /info for (.*)$/i, (msg) ->

    if msg.match[1] of info
      for key, value of info[msg.match[1]]
        msg.send "#{key}: #{value}"
    else
      msg.send "No information for #{msg.match[1]}, sorry!\n There is for #{available}."

  robot.respond /info available/i, (msg) ->

    msg.send "There is information avalable for #{available}."


  robot.respond /hangout/i, (msg) ->

    msg.send "There is information avalable for #{msg.message.reply_to}."

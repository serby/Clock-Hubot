# Description:
#   Skype utility commands for Clock Limited
#
#
# Configuration:
#   HUBOT_SLACK_SKYPE_TOKEN
#
# Commands:
#   hubot who [is available | has Skype] - Show who is avilable
#   hubot skype <field> - Send a Skype call to a user


URL = "https://slack.com/api/users.list?token="+ process.env.HUBOT_SLACK_SKYPE_TOKEN

module.exports = (robot) ->
  robot.respond /skype (.*)$/i, (msg) ->

    getData msg, (d) ->
      # DO STUFF
        for key, value of d.members
          username = d.members[key].name
          realName = d.members[key].real_name
          skype = d.members[key].skype

          if msg.match[1] in [username, realName, skype]

            msg.send "skype:#{skype}?call"
            break

  robot.respond /who [is available | has Skype]/i, (msg) ->

    getData msg, (d) ->
      # DO STUFF
      for key, value of d.members
        username = d.members[key].name
        realName = d.members[key].real_name
        skype = d.members[key].skype

        if skype != null
          if realName
            msg.send "#{realName}: #{skype}"
          else
            msg.send "#{username}: #{skype}"

  getData = (msg, d) ->
    msg.send "Connecting to: " + URL
    robot.http(URL)
    .header('Accept', 'application/json')
    .get() (err, res, body) ->

      # Check for errors
      if err
        msg.send "Encountered an error :( #{err}"
        return

      # Check status
      if res.statusCode isnt 200
        msg.send "Request didn't come back HTTP 200 :("
        return

      # We have data!
      data = null
      try
        data = JSON.parse(body)
        d data
      catch error
       msg.send "Ran into an error parsing JSON :("
       return

# Description:
#   Skype utility commands for Clock Limited
#
#
# Configuration:
#   HUBOT_SLACK_SKYPE_TOKEN
#
# Commands:
#   hubot who [is available | has Skype] - Show who is available
#   hubot skype <Skype username | Slack username | real name> - Send a Skype call to a user
#   hubot skype conf <Skype usernames | Slack usernames (space seperated)> - Send a conf Skype call to users


URL = "https://slack.com/api/users.list?token="+ process.env.HUBOT_SLACK_SKYPE_TOKEN

module.exports = (robot) ->
  robot.respond /skype (?!conf)(.*)$/i, (msg) ->

    getData msg, (d) ->
      # DO STUFF
      found = null
      for key, value of d.members
        username = value.name
        realName = value.real_name
        skype = value.skype

        if msg.match[1] in [username, realName, skype]
          found = true
          msg.send "https://#{process.env.HUBOT_SLACK_TEAM}.slack.com/link?url=skype:#{skype}?call"
          break

      msg.send "No user '#{msg.match[1]}' found." unless found

  robot.respond /skype conf (.*)$/i, (msg) ->

    usernames = msg.match[1].split " "

    getData msg, (d) ->
      # DO STUFF
      skype_array = []

      for key, value of d.members
        username = value.name
        realName = value.real_name
        skype = value.skype

        for key, value of usernames

          if value in [username, realName, skype]

            skype_array.unshift skype
            break

      joined = skype_array.join ";"
      msg.send "https://#{process.env.HUBOT_SLACK_TEAM}.slack.com/link?url=skype:#{joined}?call"


    # getData msg, (d) ->
    #   # DO STUFF
    #     for key, value of d.members
    #       username = d.members[key].name
    #       realName = d.members[key].real_name
    #       skype = d.members[key].skype
    #
    #       if msg.match[1] in [username, realName, skype]
    #
    #         msg.send "https://#{process.env.HUBOT_SLACK_TEAM}.slack.com/link?url=skype:#{skype}?call"
    #         break

  robot.respond /who [is available | has Skype]/i, (msg) ->

    getData msg, (d) ->
      # DO STUFF
      for key, value of d.members
        username = d.members[key].name
        realName = d.members[key].real_name
        skype = d.members[key].skype

        if skype != null
          user_array = []
          if realName
            user_array.push "#{realName}: #{skype}"
          else
            user_array.push "#{username}: #{skype}"

          users = user_array.join "\n"

          msg.send users

  getData = (msg, d) ->
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

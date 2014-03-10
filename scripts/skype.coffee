# Description:
#   Skype utility commands for Slack
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
  robot.respond /skype (?!conf\s)(.*)$/i, (msg) ->

    getData msg, (d) ->
      # DO STUFF
      found = null
      for key, value of d.members
        username = value.name
        realName = value.real_name
        skype = value.skype

        if msg.match[1] in [username, realName, skype]
          found = true
          if skype
            msg.send "https://#{process.env.HUBOT_SLACK_TEAM}.slack.com/link?url=skype:#{skype}?call"
          else
            msg.send "'#{msg.match[1]}' does not have Skype set on Slack."
          break

      msg.send "No user '#{msg.match[1]}' found." unless found


  robot.respond /skype conf (.*)$/i, (msg) ->

    usernames = msg.match[1].split " "

    if usernames.length == 1
      msg.send "A conf call with one person? I'll do it anyway..."

    getData msg, (d) ->
      # DO STUFF
      skype_array = []
      found = null
      for key, value of d.members
        username = value.name
        realName = value.real_name
        skype = value.skype

        for key, value of usernames

          if value in [username, realName, skype]
            found = true
            if skype
              skype_array.push skype
            else
              msg.send "'#{value}' does not have Skype set on Slack."

      if found
        joined = skype_array.join ";"
        msg.send "https://#{process.env.HUBOT_SLACK_TEAM}.slack.com/link?url=skype:#{joined}?call"
      else
        msg.send "No user '#{msg.match[1]}' found."


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

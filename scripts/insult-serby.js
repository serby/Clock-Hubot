// Description:
//   Be mean to serby
//
// Dependencies:
//   None
//
// Configuration:
//   None
//
// Commands:
//   none
//
// Author:
//   Paul Serby <paul.serby@clock.co.uk>

var adjectives = [ 'smelly', 'chubby', 'gap-toothed', 'pasty-faced', 'lice-infested', 'stupid', 'flaccid' ]
  , nouns = [ 'turd', 'dung', 'rust', 'lice', 'cockroach', 'pus', 'crap', 'shit', 'bum hole', 'muck', 'dead animal' ]
  , verbs = [ 'humper', 'grabber', 'pincher', 'sniffer', 'lapper', 'licker', 'scratcher', 'fister', 'biter', 'tickler' ]

function randomWord(collection) {
  return collection[Math.floor(Math.random() * collection.length)]
}

function insult(name, type) {
  var phrase = randomWord(adjectives) + ' ' + randomWord(nouns) + ' ' + randomWord(verbs)

  switch (type) {
    case 0:
      return (name + ' is a ' + phrase + '!').toUpperCase()
      break
    case 1:
      return 'Don\'t get me started on ' + name + ', what a total ' + phrase + '!'
      break
    case 2:
      return name + ', what a complete ' + phrase
      break
    case 3:
      return 'I\'ve always considered ' + name + ' to be a bit of a ' + phrase
      break
    case 4:
      return 'Word on the street is that ' + name + ' is a ' + phrase
      break
    case 5:
      return 'Didn\'t you tell me the other day that you thought '  + name + ' is a ' + phrase
      break
    case 6:
      return 'I hate ' + name + '!'
      break
  }
  return ''
}

module.exports = function(robot) {

  robot.hear(/serby/i, function(msg) {
    var oneIn = 5
    if (Math.floor(Math.random() * oneIn) === 0) msg.send(insult('Serby', Math.floor(Math.random() * 6)))
  })

}

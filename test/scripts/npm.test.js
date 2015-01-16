var npmHubot = require('../../scripts/npm')
  , assert = require('assert')
  , request = require('request')

function integrationHttp(url) {
  return { get: function() { return request.bind(request, url) } }
}

function createMockRobot(message, http, done) {
  return { respond: function(exp, cb) {
      cb({ match: exp.exec(message), send: done, http: http })
    }
  }
}

describe('npm hubot', function() {
  it('should be a function', function() {
    assert.equal(typeof npmHubot, 'function')
  })

  it('should call respond with the correct pattern', function() {
    npmHubot(
      { respond: function(pattern) {
          assert.deepEqual(pattern, /npm (.*)/i)
        }
      })
  })

  describe('Integration Tests', function() {

    it('should show errors', function(done) {

      npmHubot(createMockRobot('npm save', integrationHttp.bind(null, 'http://bad'), function(msg) {
        if (/^Error finding save in/.test(msg)) {
          done()
        }
      }))
    })

    it('should find a valid package', function(done) {
      npmHubot(createMockRobot('npm save', integrationHttp, function(msg) {
        if (/^save/.test(msg)) {
          done()
        }
      }))
    })

    it('should error on an invalid package', function(done) {
      npmHubot(createMockRobot('npm aljkshlkjhsakdjh', integrationHttp, function(msg) {
        if (/^aljkshlkjhsakdjh doesn't exist in/.test(msg)) {
          done()
        }
      }))
    })
  })
})

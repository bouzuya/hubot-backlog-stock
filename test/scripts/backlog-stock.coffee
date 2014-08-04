{Robot, User, TextMessage} = require 'hubot'
assert = require 'power-assert'
path = require 'path'
sinon = require 'sinon'

describe 'backlog-stock', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    @robot = new Robot(path.resolve(__dirname, '..'), 'shell', false, 'hubot')
    @robot.adapter.on 'connected', =>
      @robot.load path.resolve(__dirname, '../../src/scripts')
      done()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    beforeEach ->
      @callback = @sinon.spy()
      @robot.listeners[0].callback = @callback

    describe 'receive "@hubot backlog-stock a message"', ->
      beforeEach ->
        @sender = new User 'bouzuya', room: 'hitoridokusho'
        message = '@hubot backlog-stock a message'
        @robot.adapter.receive new TextMessage(@sender, message)

      it 'calls *stock* with "@hubot backlog-stock a message"', ->
        assert @callback.callCount is 1
        match = @callback.firstCall.args[0].match
        assert match.length is 2
        assert match[0] is '@hubot backlog-stock a message'
        assert match[1] is 'a message'

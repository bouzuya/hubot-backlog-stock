# Description
#   A Hubot script that stock the backlog wiki with your messages.
#
# Dependencies:
#   "q": "^1.0.1",
#   "request": "^2.39.0"
#
# Configuration:
#   HUBOT_BACKLOG_STOCK_SPACE_ID
#   HUBOT_BACKLOG_STOCK_API_KEY
#   HUBOT_BACKLOG_STOCK_PROJECT_KEY
#   HUBOT_BACKLOG_STOCK_NAME
#
# Commands:
#   hubot backlog-stock <message> - stock the backlog wiki with message
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  {format} = require 'util'
  request = require 'request'
  {Promise} = require 'q'

  spaceId = process.env.HUBOT_BACKLOG_STOCK_SPACE_ID
  apiKey = process.env.HUBOT_BACKLOG_STOCK_API_KEY
  projectKey = process.env.HUBOT_BACKLOG_STOCK_PROJECT_KEY
  wikiName = process.env.HUBOT_BACKLOG_STOCK_NAME ? 'Home'
  baseUrl = "https://#{spaceId}.backlog.jp"

  getWikis = (projectKey) ->
    new Promise (resolve, reject) ->
      request {
        url: baseUrl + '/api/v2/wikis'
        qs:
          apiKey: apiKey
          projectIdOrKey: projectKey
      }, (err, _, body) ->
        return reject(err) if err?
        resolve JSON.parse(body)

  getWiki = (wikiId) ->
    new Promise (resolve, reject) ->
      request {
        url: baseUrl + '/api/v2/wikis/' + wikiId
        qs:
          apiKey: apiKey
      }, (err, _, body) ->
        return reject(err) if err?
        resolve JSON.parse(body)

  updateWiki = (wiki) ->
    new Promise (resolve, reject) ->
      request {
        url: baseUrl + '/api/v2/wikis/' + wiki.id
        qs: { apiKey }
        form: {
          name: wiki.name
          content: wiki.content
          mailNotify: 'false'
        }
        method: 'patch'
      }, (err, _, body) ->
        return reject(err) if err?
        resolve JSON.parse(body)

  stock = (projectKey, message) ->
    getWikis projectKey
      .then (wikis) ->
        filtered = wikis.filter (wiki) -> wiki.name is wikiName
        if filtered.length is 0
          throw new Error("backlog-stock: #{wikiName} is not found")
        filtered[0].id
      .then (wikiId) ->
        getWiki wikiId
      .then (wiki) ->
        wiki.content += '\n- ' + message
        updateWiki wiki

  robot.respond /backlog-stock\s+(.*)$/i, (res) ->
    message = res.match[1]
    stock projectKey, message
      .then (wiki) ->
        res.send """
          backlog-stock: #{message}
            #{baseUrl}/wiki/#{projectKey}/#{encodeURIComponent(wiki.name)}
        """
      , (err) ->
        robot.logger.error(err)
        res.send 'backlog-stock error'

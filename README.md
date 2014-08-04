# hubot-backlog-stock

A Hubot script that stock the backlog wiki with your messages.

## Installation

    $ npm install git://github.com/bouzuya/hubot-backlog-stock.git

or

    $ # TAG is the package version you need.
    $ npm install 'git://github.com/bouzuya/hubot-backlog-stock.git#TAG'

## Sample Interaction

    bouzuya> hubot help backlog-stock
    hubot> hubot backlog-stock <message> - stock the backlog wiki with message

    bouzuya> hubot backlog-stock message
    hubot> backlog-stock: message
    https://space.backlog.jp/wiki/HITORIDOKUSHO/Home

See [`src/scripts/backlog-stock.coffee`](src/scripts/backlog-stock.coffee) for full documentation.

## License

MIT

## Development

### Run test

    $ npm test

### Run robot

    $ npm run robot


## Badges

[![Build Status][travis-status]][travis]

[travis]: https://travis-ci.org/bouzuya/hubot-backlog-stock
[travis-status]: https://travis-ci.org/bouzuya/hubot-backlog-stock.svg?branch=master

module.exports =
  'Open main page': (test) ->
    test
      .open 'http://localhost:3000/'
      .assert.title().is 'Derby App', 'It has title'
      .done()
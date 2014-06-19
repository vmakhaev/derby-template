gulp = require 'gulp'
gutil = require 'gulp-util'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
dalek = require 'gulp-dalek'
nodemon = require 'gulp-nodemon'
mocha = require 'gulp-mocha'

gulp.task 'coffeelint', ->
  gulp.src ['./**/*.coffee', '!./node_modules/**/*.*']
    .pipe coffeelint()
    .pipe coffeelint.reporter()

gulp.task 'dalek', ->
  options =
    browser: ['phantomjs', 'chrome']
    reporters: ['html', 'junit']

  gulp.src './test/dalek/**/*.coffee'
    .pipe dalek options

gulp.task 'mocha', ->
  options =
    bail: true
    compilers:'coffee:coffee-script/register'
    reporter: 'nyan'

  gulp.src ['./test/**/*.coffee', '!./test/dalek/**/*.*']
    .pipe mocha options

gulp.task 'nodemon', ->
  options =
    script: 'server.coffee'
    ext: 'coffee'
    ignore: ['.git', 'app', 'public']

  nodemon options

gulp.task 'default', ['nodemon']
gulp.task 'test', ['coffeelint', 'mocha', 'dalek']
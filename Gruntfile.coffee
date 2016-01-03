_         = require 'lodash'
path      = require 'path'

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-http-server'

  grunt.config.init
    pkg: grunt.file.readJSON('package.json')
    opts: {}
    meta:
      banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' + '<%= grunt.template.today(\'yyyy-mm-dd\') %>\n' + '* Copyright (c) <%= grunt.template.today(\'yyyy\') %> <%= pkg.author.name %> */'

    coffee:
      compileJoined:
        options:
          join: true
        files:
          'tmp/bauralux.js': [
            './src/modules/*.coffee', './src/index.coffee', './src/components/*.coffee',
            './src/models/**/*.coffee', './src/sprites/*.coffee', './src/scenes/*.coffee'
          ]

    concat:
      options:
        stripBanners: true
        banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' + '<%= grunt.template.today(\'yyyy-mm-dd\') %>\n' + '* Copyright (c) <%= grunt.template.today(\'yyyy\') %> <%= pkg.author.name %> */'

      build:
        src: ['vendor/jquery-1.9.1.js', 'vendor/lodash.min.js', 'vendor/quadtree.min.js', 'vendor/quintus-all-mod.js', 'tmp/bauralux.js']
        dest: 'public/app.js'

    watch:
      files: ['./index.html', 'src/**/*.coffee', './vendor/quintus-all-mod.js']
      tasks: ['coffee', 'concat']

      options:
        interval: 1007
        livereload: 35729

    'http-server':
      dev:
        root            : './public'
        port            : 3000
        host            : "0.0.0.0"
        cache           : 0
        showDir         : true
        autoIndex       : true
        ext             : "html"
        runInBackground : false
        openBrowser     : true

  grunt.registerTask 'default', ['coffee', 'concat', 'watch']
  grunt.registerTask 'start', ['http-server']

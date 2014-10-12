module.exports = (grunt)->
  grunt.initConfig
 
    dir:
      dev: 'htdocs/_dev/'
      release: 'htdocs/release/'
      coffee: 'files/_coffee/'
      js: 'files/js/'
      scss: 'files/_scss'
      css: 'files/css'
      img: 'files/img'

    bower:
      install:
        options:
          targetDir: '_lib/'
          install: true
          cleanTargetDir: false
          cleanBowerDir: true

    copy:
      init:
        files:[
          {
            expand: true
            cwd: '_lib/jquery/'
            src: 'jquery.js'
            dest: '<%= dir.dev %><%= dir.js %>'
            filter: 'isFile'
            dot: false
          },
          {
            expand: true
            cwd: '_lib/html5-boilerplate/js/vendor/'
            src: ["**/modernizr*.js"]
            dest: '<%= dir.dev %><%= dir.js %>'
            filter: 'isFile'
            dot: false
          }
        ]
      build:
        files:[
          { #html
            expand: true
            cwd: "<%= dir.dev %>"
            src: ["**/*.html"]
            dest: "<%= dir.release %>"
            filter: 'isFile'
            dot: false
          },
          { #css
            expand: true
            cwd: "<%= dir.dev %><%= dir.css %>"
            src: ["**/*.css"]
            dest: "<%= dir.release %><%= dir.css %>"
            filter: 'isFile'
            dot: false
          },
          { #img
            expand: true
            cwd: "<%= dir.dev %><%= dir.img %>"
            src: ["**/*.{gif,jpeg,jpg,png,svg,webp}"]
            dest: "<%= dir.release %><%= dir.img %>"
            filter: 'isFile'
            dot: false
          },
          { #js
            expand: true
            cwd: "<%= dir.dev %><%= dir.js %>"
            src: ["**/*.js"]
            dest: "<%= dir.release %><%= dir.js %>"
            filter: 'isFile'
            dot: false
          }
        ]

    clean: ["<%= dir.release %>"]

    sass: #sassコンパイル
      dist:
        options:
          compass: true #compassを有効に
          style: 'expanded' #_devの段階では標準書式で出力する
        files:[
          {
            expand: true
            cwd: '<%= dir.dev %><%= dir.scss %>'
            src: ['*.scss']
            dest: '<%= dir.dev %><%= dir.css %>'
            ext: '.css'
          }
        ]

    coffee: #coffeeコンパイル
      options:
        bare: true
      files:
        expand: true
        cwd: "<%= dir.dev %><%= dir.coffee %>"
        src: ["**/*.coffee"]
        dest: "<%= dir.dev %><%= dir.js %>"
        ext: ".js"

    connect: #webサーバー接続
      server:
        options:
          base: '<%= dir.dev %>'

    watch: #ファイル変更監視
      options:
        livereload: true
      html:
        files: "<%= dir.dev %>**/*.html"
      sass:
        files: "<%= dir.dev %><%= dir.scss %>**/*.scss"
        tasks: ["sass"]
      js:
        files: "<%= dir.dev %><%= dir.coffee %>**/*.coffee"
        tasks : ['coffee']

    ###
    cssmin: #CSS連結/コンパイル
      combine:
        files:
          'release/css/app.min.css': ['src/css/reset.css', 'src/css/main.css']

    concat: #js結合
      dist:
        src: [
          "src/js/plugins.js"
          "src/js/main.js"
        ]
        dest: "release/app.js"

    uglify: #js結合/コンパイル
      js:
        files:
          'release/app.min.js': ['src/plugins.js', 'src/main.js']
    ###

  require('load-grunt-tasks') grunt #プラグイン読み込み
 
  #ディレクトリ構築
  grunt.registerTask "init", ()->
    grunt.task.run('bower:install')
    grunt.task.run('copy:init')
    grunt.file.defaultEncoding = 'utf8'
    grunt.file.mkdir('htdocs')
    grunt.file.mkdir('htdocs/_dev')
    grunt.file.mkdir('htdocs/_dev/files')
    grunt.file.mkdir('htdocs/_dev/files/css')
    grunt.file.mkdir('htdocs/_dev/files/img')
    grunt.file.mkdir('htdocs/_dev/files/_scss')
    grunt.file.mkdir('htdocs/_dev/files/_coffee')
    grunt.file.mkdir('htdocs/_dev/files/js')

  grunt.registerTask "default", ['watch']

  #grunt.registerTask "init", ["bower:install",'copy:init'] #init 
  grunt.registerTask "release", ['clean','copy:build'] #公開時に実行するタスク
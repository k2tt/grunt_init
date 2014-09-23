grunt.initConfig({

  yeoman: {
    // Configurable paths
    app: 'app',
    dist: 'dist'
  },
 
  copy: {
    dist: {
      files: [{
        expand: true,
        dot: true,
        cwd: '<%= yeoman.app %>', // <- ここ
        dest: '<%= yeoman.dist %>', // <- ここ
        src: [
          '*.{ico,png,txt}'
        ]
      }]
    }
  }

  require('load-grunt-tasks')(grunt);

});
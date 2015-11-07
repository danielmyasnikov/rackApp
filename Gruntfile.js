module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    jade: {
      compile: {
        options: {
          pretty: true,
          data: {
            debug: false
          }
        },
        files: [{
          cwd: 'app/views',
          src: '**/*.jade',
          dest: 'public/views',
          expand: true,
          ext: '.html'
        }]
      }
    },
    concat: {
      dist: {
        src: ['vendor/assets/stylesheets/**/*.scss', 'app/assets/stylesheets/**/*.scss'],
        dest: 'public/assets/stylesheets/app.build.scss',
      }
    },
    sass: {
      dist: {
        files: {
          'public/assets/stylesheets/app.css': 'public/assets/stylesheets/app.build.scss'
        }
      }
    },
    coffee: {
      compfile: {
        options: {
          join: true
        },
        files: {
          'public/assets/javascripts/app.js': ['vendor/assets/javascripts/**/*.coffee', 'app/assets/javascripts/**/*.coffee']
        }
      }
    },
    // uglify: {
    //   my_target: {
    //     files: {
    //       'public/assets/javascripts/app.min.js': ['public/assets/javascripts/app.js']
    //     }
    //   }
    // },
    cssmin: {
      options: {
        shorthandCompacting: false,
        roundingPrecision: -1
      },
      target: {
        files: {
          'public/assets/stylesheets/app.min.css': ['public/assets/stylesheets/app.css']
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-sass');
  grunt.loadNpmTasks('grunt-contrib-jade');
  grunt.registerTask('default', ['concat', 'sass', 'jade', 'coffee', 'cssmin']);

}

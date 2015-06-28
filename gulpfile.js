var _            = require('underscore');

var buffer       = require('vinyl-buffer');
var del          = require('del');
var gulp         = require('gulp');
var gutil        = require('gulp-util');
var source       = require('vinyl-source-stream');

var autoprefixer = require('gulp-autoprefixer');
var sass         = require('gulp-sass');

var browserify   = require('browserify');
var sourcemaps   = require('gulp-sourcemaps');
var uglify       = require('gulp-uglify');
var watchify     = require('watchify');

gulp.task('clean', function(cb) {
  return del(['./public/css', './public/js'], cb);
});

function styles(devMode) {
  var result = gulp.src('./public/sass/**/*.scss');

  if (devMode) {
    result = result.pipe(sourcemaps.init());
  }

  // Compile and compress sass
  result = result
    .pipe(sass({ outputStyle: 'compressed' })
    .on('error', sass.logError));

  if (devMode) {
    // Fake that the sourcemapped files came from /sass
    result = result.pipe(sourcemaps.write({ sourceRoot: '/sass' }));
  }

  return result
    // Add CSS3 prefixes after sourcemaps so we get meaningful source mappings
    .pipe(autoprefixer())
    .pipe(gulp.dest('./public/css'));
}

gulp.task('styles',     function() { return styles(false); });
gulp.task('styles-dev', function() { return styles(true); });

function scripts(devMode) {
  var config = {};
  if (devMode) {
    _.extend(config, watchify.args);
  }
  _.extend(config, { debug: devMode });

  // Initialize browserify
  // (it does it's own stream things when you call b.bundle())
  var b = browserify('./public/src/app.cjsx', config);

  if (devMode) {
    b = watchify(b);
    b.on('log', gutil.log.bind(gutil, 'watchify log'));
  }

  // This is where the real heavy lifting is done. In devMode, this will get
  // called by watchify on every update. Otherwise, it's called just once (as
  // the return of calling scripts(false) ).
  var compile = function compile() {
    var result = b.bundle()
      .on('error', gutil.log.bind(gutil, 'browserify error'))
      // "call my the actual file of my bundle ..."
      .pipe(source('bundle.js'))
      // uglify and sourcemaps need a buffer, not a stream
      .pipe(buffer());

    // For development, don't uglify, and add sourcemaps
    // For production, uglify, but don't add sourcemaps
    if (devMode) {
      result = result
        // load maps from browserify file
        .pipe(sourcemaps.init({ loadMaps: true }))
        // Fake that the sourcemapped files came from /src
        .pipe(sourcemaps.write({ sourceRoot: '/src' }));
    }
    else {
      result = result
        .pipe(uglify())
        .on('error', gutil.log.bind(gutil, 'uglify error'));
    }

    // "write my bundle to this directory"
    return result.pipe(gulp.dest('./public/js/'));
  }

  if (devMode) {
    // Recompile on changes for watchify
    b.on('update', compile);
  }

  return compile();
}

gulp.task('scripts',  function() { return scripts(false); });
gulp.task('watchify', function() { return scripts(true); });

gulp.task('watch', ['watchify', 'styles-dev'], function() {
  return gulp.watch('./public/sass/**/*.scss', ['styles-dev']);
});

gulp.task('default', function() {
  gulp.start('styles', 'scripts');
});

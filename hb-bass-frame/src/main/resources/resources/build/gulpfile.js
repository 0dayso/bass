var _version = '-0.0.1v';
var gulp = require('gulp'),
    sass = require('gulp-sass'),
    mincss = require('gulp-mini-css'),
    concat = require('gulp-concat'),
    rename = require('gulp-rename'),
    cssmin = require('gulp-minify-css'),
    //sourcemaps = require('gulp-sourcemaps'),
    uglify = require('gulp-uglify');

gulp.task('testSass', function () {
    gulp.src('./sass/*.scss')
        .pipe(sass())
        .pipe(cssmin({compatibility: 'ie7'}))
        .pipe(concat('bass.bug.all'+_version+'.css'))
        .pipe(gulp.dest('../mini/css/'))
        .pipe(rename('bass.all.min'+_version+'.css'))
        .pipe(mincss())
        .pipe(gulp.dest('../mini/css/'));
});

gulp.task('minjs', function () {
    gulp.src(['./js/*.js'])
        .pipe(concat('bass.bug.all'+_version+'.js'))
        .pipe(gulp.dest('../mini/js/'))
        .pipe(rename('bass.all.min'+_version+'.js'))
        .pipe(uglify())
        .pipe(gulp.dest('../mini/js/'));       
});

/*
gulp.task('watch', function () {
    gulp.watch('./sass/*.scss',['testSass']);
    gulp.watch(raw_js+'/*.js',['minjs']);
});
*/

gulp.task('default',function(){
    gulp.run('minjs','testSass');
    //gulp.run('watch');
});

 gulp.run('default');
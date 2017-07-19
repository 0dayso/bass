var _version = '-adaptation-0.0.1v';
var gulp = require('gulp'),
    sass = require('gulp-sass'),
    mincss = require('gulp-mini-css'),
    concat = require('gulp-concat'),
    rename = require('gulp-rename'),
    cssmin = require('gulp-minify-css'),
    //sourcemaps = require('gulp-sourcemaps'),
    uglify = require('gulp-uglify');

var roitCompile = require("./widgets/compileWidgetTags.js");

gulp.task('sass', function () {
    gulp.src('./sass/target.scss')
        .pipe(sass())
        .pipe(concat('bass.bug.all'+_version+'.css'))
        .pipe(gulp.dest('./mini/css/'))
        .pipe(rename('bass.all.min'+_version+'.css'))
        .pipe(mincss())
        .pipe(gulp.dest('./mini/css/'));
});

gulp.task('minjs', function () {
    roitCompile.compileAllTagForBuild();
    gulp.src(['./build/*.js'])
        .pipe(concat('bass.bug.all'+_version+'.js'))
        .pipe(gulp.dest('./mini/js/'))
        .pipe(rename('bass.all.min'+_version+'.js'))
        .pipe(uglify())
        .pipe(gulp.dest('./mini/js/'));
});

gulp.run('minjs','sass');
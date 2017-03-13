RootsUtil       = require 'roots-util'
js_pipeline     = require 'js-pipeline'
css_pipeline    = require 'css-pipeline'
dynamic_content = require 'dynamic-content'
browserify      = require 'roots-browserify'
image_pipeline  = require 'roots-image-pipeline'
statica         = require 'statica'
autoprefixer    = require 'autoprefixer'
dateFormat      = require 'date_format'
jade            = require 'jade'
fs              = require 'fs'
marked          = require 'marked'
moment          = require 'moment'
highlight       = require 'highlight.js'

marked.setOptions
  gfm: true
  tables: true
  breaks: true
  pedantic: false
  sanitize: true
  smartLists: true
  smartypants: true
  highlight: (code) ->
    highlight.highlightAuto(code).value

dateFormat.extendPrototype()

module.exports =
  ignores: [
    'readme.md'
    '**/layout.*'
    '**/_*/*'
    '**/_*/**/*'
    '**/_*'
    '.gitignore'
    '**/drafts/**/*'
    'ship.*conf'
    '.travis.yml'
    'yarn.lock'
    '.sass-lint.yml'
    'coffeelint.json'
    'Gemfile'
    'Gemfile.lock'
    'vendor/**/*'
    '.bundle/**/*'
  ]

  browser:
    open: false

  before: (roots) ->
    helpers = new RootsUtil.Helpers
    helpers.project.remove_folders(roots.config.output)

  extensions: [
    image_pipeline(
      files: 'assets/img/**'
      compress: false
      resize: false
      output_webp: false
    )
    js_pipeline(files: 'assets/js/**/*.{js,coffee}')
    css_pipeline(files: 'assets/css/main.sass', postcss: true)
    dynamic_content()
    statica()
    browserify(
      files: 'assets/js/main.coffee'
      out: 'js/main.js'
      minify: false
      sourceMap: true
    )
  ]

  scss:
    sourcemap: true
    minify: true
    indentedSyntax: true

  postcss:
    use: [autoprefixer(browsers: ['last 3 version'])]

  'coffee-script':
    sourcemap: true

  locals:
    render: fs.readFileSync
    md: marked
    date: (date) ->
      moment(date, 'YYYY-MM-DD hh:mm:ss').format('dddd Do MMMM YYYY')
    sort: (posts) ->
      posts.sort (a, b) ->
        aDate = moment(a.date, 'YYYY-MM-DD hh:mm:ss').unix()
        bDate = moment(b.date, 'YYYY-MM-DD hh:mm:ss').unix()

        bDate - aDate

  jade:
    pretty: true
    basedir: "#{__dirname}/views"

const fs          = require('fs')
const path        = require('path')
const ejs         = require('ejs')
const classify    = require('underscore.string/classify')
const underscored = require('underscore.string/underscored')

exports.configure = [
  {
    name: 'name',
    message: 'What is your project\'s name?',
  }, {
    name: 'repository',
    message: 'What is the repository name for your project?',
  }, {
    name: 'author',
    message: 'What is your full name?',
  }, {
    name: 'github_username',
    message: 'What is your github username?',
  }, {
    name: 'description',
    message: 'A short description of your project',
  }
]

{defaults, extend} = require 'underscore'
clone = require 'clone'
CSON = require 'cson'

juniper = CSON.parseFileSync "#{__dirname}/../../config.cson"
dir = process.cwd()

try
  # The project may not yet exist
  project = CSON.parseFileSync "#{process.cwd()}/config.cson"
catch e


getFormattedSite = (name) ->
  formattedSite = clone project.sites[name]
  formattedSite.files ?= {}
  formattedSite.process ?= {}

  defaults formattedSite, juniper.defaults.site.all
  defaults formattedSite.files, juniper.defaults.site.files
  defaults formattedSite.process, juniper.defaults.site.process

  if formattedSite.files.redirects?
    formattedRedirects = []

    for redirect in formattedSite.files.redirects
      site = getFormattedSite redirect.site
      site.dir = redirect.dir
      formattedRedirects.push site

    formattedSite.files.redirects = formattedRedirects

  relativeRoot = formattedSite.files.root
  absoluteRoot = "#{dir}/repos/#{name}"
  absoluteRoot += "/#{relativeRoot}" if relativeRoot

  formattedSite.files.root = absoluteRoot
  formattedSite

module.exports =
  juniper: juniper
  project: extend project, {getFormattedSite}
  dir: dir

import groovy.json.JsonOutput
import groovy.json.JsonSlurper

// Expects json string with appropriate content to be passed in
def configuration = new JsonSlurper().parseText(args)

log.info("Setting up npm repositories...")

def newRepositories = []

newRepositories << repository.createNpmProxy('npmjs-org', configuration.npm.registry)

newRepositories << repository.createNpmHosted('npm-internal')

def npmMembers = [ 'npm-internal', 'npmjs-org' ]

newRepositories << repository.createNpmGroup('npm-all', npmMembers)

log.info("Successfully setup npm repositories.")

return JsonOutput.toJson(
  newRepositories.each { repo ->
    "Name: $repo.name, Url: $repo.url"
  }
)

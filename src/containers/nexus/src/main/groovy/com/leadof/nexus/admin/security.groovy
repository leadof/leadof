import groovy.json.JsonOutput
import groovy.json.JsonSlurper

// Expects json string with appropriate content to be passed in
def configuration = new JsonSlurper().parseText(args)

log.info("Setting up initial security...")

security.setAnonymousAccess(false)
log.info('Anonymous access disabled')

security.securitySystem.changePassword('admin',configuration.admin.password)
log.info('Administrator password changed')

def devPrivileges = ['nx-all']
def devRoles = ['nx-admin']

def devRole = security.addRole(
  'developer',
  'Developer',
  'User with privileges to allow developer access',
  devPrivileges,
  devRoles
)

def userDev = security.addUser(
  configuration.dev.username,
  'Generic',
  'Developer',
  'anon@dev.com',
  true,
  configuration.dev.password,
  ['developer']
)

log.info("Successfully setup initial security.")

return JsonOutput.toJson([
  "Anonymous access disabled",
  "Administrator password changed",
  "Developer role created",
  "Developer user created"
])

import { create } from 'create-svelte'
import { fileURLToPath } from 'url'
import path from 'path'
import fs from 'fs-extra'

const main = async (currentScriptUrl, argv) => {

  console.debug('main()', currentScriptUrl, argv)

  if (argv.length !== 1) {
    throw new Error('Missing app name as the first and only argument')
  }

  const appName = argv[0].trim()

  const currentScriptFilePath = fileURLToPath(currentScriptUrl)
  const currentScriptDirectoryPath = path.dirname(currentScriptFilePath);

  console.debug('Generating app...', appName)
  await create(appName, {
    name: appName,
    template: 'skeleton',
    types: 'typescript',
    prettier: true,
    eslint: true,
    playwright: true,
    vitest: true,
  })
  console.info('Successfully generated app...', appName)

  const generatedAppDirectoryPath = path.join(currentScriptDirectoryPath, `./${appName}/`)
  const targetAppDirectoryPath = path.join(currentScriptDirectoryPath, `../${appName}/`)

  console.debug('Moving generated app to target directory...', generatedAppDirectoryPath, targetAppDirectoryPath)
  await fs.move(generatedAppDirectoryPath, targetAppDirectoryPath, console.error)
  console.info('Successfully moved generated app to target directory.', targetAppDirectoryPath)
}

(async () => await main(import.meta.url, process.argv.splice(2)))()

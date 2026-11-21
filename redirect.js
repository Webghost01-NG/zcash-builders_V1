(() => {
  const appOrigin = 'https://zcash-builders.vercel.app'
  const pagesPrefix = '/zcash-builders_V1'
  const currentPath = window.location.pathname
  const appPath = currentPath === pagesPrefix
    ? '/'
    : currentPath.startsWith(`${pagesPrefix}/`)
      ? currentPath.slice(pagesPrefix.length)
      : currentPath

  const destination = new URL(appPath || '/', appOrigin)
  destination.search = window.location.search
  destination.hash = window.location.hash
  window.location.replace(destination.toString())
})()

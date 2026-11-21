# Deployment

The Next.js application is deployed to Vercel at <https://zcash-builders.vercel.app/>. Vercel builds the app from this repository and provides the runtime required by its routes and Supabase session proxy.

GitHub Pages remains enabled at <https://drekal0.github.io/zcash-builders_V1/> as a redirect for the repository's existing homepage link. The root `index.html` redirects the root page, and `404.html` forwards direct paths such as `/apply` and `/learn` to the matching Vercel route. Both preserve query strings and URL fragments through `redirect.js`.

If the repository name or Vercel app URL changes, update the Pages path prefix and destination in `redirect.js`, `index.html`, and `404.html`. Keep the Vercel domain as the canonical app URL.

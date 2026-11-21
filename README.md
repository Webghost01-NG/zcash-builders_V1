# Zcash Builders

Zcash Builders is a learning platform for developers who want to build with Zcash. It brings together an eight-week curriculum, hands-on labs, student progress tracking, and tools for managing applications and cohorts.

The course moves from blockchain fundamentals through Zcash protocols and application development, then into contributing to Zcash open source projects. The public site and learning portal are built with Next.js and React; Supabase provides authentication and application, learner, and cohort data.

## Run locally

### Requirements

- Node.js and npm
- A Supabase project for features that use authentication or stored data

### Setup

1. Install dependencies:

   ```bash
   npm install
   ```

2. Create your local environment file from the example:

   ```bash
   cp .env.local.example .env.local
   ```

3. Set `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` in `.env.local` using the values for your Supabase project. The example file contains placeholders. Do not commit `.env.local` or private credentials.

4. Start the development server:

   ```bash
   npm run dev
   ```

5. Open [http://localhost:3000](http://localhost:3000).

The public landing page can be viewed without signing in. Applying, signing in, and portal features need working Supabase configuration and the corresponding database setup. SQL setup files are provided in the repository root; check with the project maintainers for the correct setup procedure before applying them to a shared project.

## Useful commands

| Command | Purpose |
| --- | --- |
| `npm run dev` | Start the local development server |
| `npm run lint` | Run ESLint |
| `npm run build` | Create a production build |
| `npm run start` | Serve a production build locally |

## Project layout

| Path | Contents |
| --- | --- |
| `src/app/` | Next.js routes for the public site, applications, learning portal, dashboard, and admin views |
| `src/components/` | Shared navigation, landing page, learning, and admin components |
| `src/lib/curriculum/outline.ts` | Curriculum structure, lesson metadata, and stable lesson IDs |
| `src/lib/curriculum/content/` | Lesson text grouped by module |
| `src/lib/supabase/` | Supabase browser, server, and middleware clients |
| `src/types/` | Shared application and database-facing TypeScript types |
| `supabase-*.sql` | Supabase schema, policy, and function setup scripts |
| `supabase/functions/` | Supabase Edge Functions, including automatic lab review |

Lesson IDs are used to associate learner progress with lessons. Keep existing IDs stable; add new IDs rather than renumbering lessons.

## Contributing

1. Check the repository issues or ask a maintainer which task would be most useful.
2. Fork the repository and create a focused branch for your change.
3. Make the change and run the relevant checks, such as `npm run lint` or `npm run build`.
4. Open a pull request against the project repository and describe the change and checks you ran.

Please coordinate with a maintainer before changing database schemas, access policies, role behavior, or shared Supabase setup. These changes can affect deployed data and permissions.

# الفرح — Wedding planner PWA
1. Supabase: create a project → SQL Editor → run `supabase.sql`. Authentication → Providers → Email (turn off "Confirm email" for simplicity).
2. Put Project URL + anon key in `index.html` (`SB_URL`, `SB_KEY`). Empty = local-only mode.
3. Run locally: `npx serve .` (or deploy this folder free on Netlify/Vercel/Cloudflare Pages — HTTPS needed for install/offline).
4. Person 1: sign up → enter name, leave code empty → project is created and seeded. Settings shows the invite code.
5. Person 2: sign up on their device → enter name + code.
6. iPhone: Safari → Share → Add to Home Screen.

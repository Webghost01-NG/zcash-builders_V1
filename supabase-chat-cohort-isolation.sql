-- Zcash Builders — Cohort-isolated chat RLS
-- Run in Supabase Dashboard → SQL Editor → New Query.
-- Messages are private to the author's cohort. No public chat channels exist today.

-- Remove the previous policies, including their permissive authenticated-user rule.
drop policy if exists "Cohort members can read chat" on public.chat_messages;
drop policy if exists "Cohort members can post" on public.chat_messages;

create policy "Cohort members can read chat"
  on public.chat_messages for select
  using (
    cohort_id is not null
    and exists (
      select 1
      from public.profiles p
      where p.id = auth.uid()
        and p.cohort_id = chat_messages.cohort_id
    )
  );

create policy "Cohort members can post"
  on public.chat_messages for insert
  with check (
    auth.uid() = user_id
    and cohort_id is not null
    and channel in ('general', 'stage-00', 'stage-01', 'stage-02', 'stage-03', 'labs', 'help', 'showcase')
    and exists (
      select 1
      from public.profiles p
      where p.id = auth.uid()
        and p.cohort_id = chat_messages.cohort_id
    )
  );

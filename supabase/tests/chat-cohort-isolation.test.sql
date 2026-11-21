-- Run against a Supabase database with pgTAP enabled, after applying
-- supabase-chat-cohort-isolation.sql. The transaction rolls back its fixtures.
begin;
create extension if not exists pgtap with schema extensions;
set local search_path = extensions, public;

select plan(6);

insert into public.cohorts (id, name)
values ('chat-test-a', 'Chat test A'), ('chat-test-b', 'Chat test B');

insert into auth.users (
  id, instance_id, aud, role, email, encrypted_password,
  email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at
) values
  ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'chat-a@example.invalid', '', now(), '{}', '{}', now(), now()),
  ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'chat-b@example.invalid', '', now(), '{}', '{}', now(), now());

update public.profiles set cohort_id = 'chat-test-a'
where id = '10000000-0000-0000-0000-000000000001';
update public.profiles set cohort_id = 'chat-test-b'
where id = '10000000-0000-0000-0000-000000000002';

insert into public.chat_messages (id, user_id, cohort_id, channel, content)
values
  ('20000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', 'chat-test-a', 'general', 'cohort A message'),
  ('20000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000002', 'chat-test-b', 'general', 'cohort B message');

set local role authenticated;
select set_config('request.jwt.claim.sub', '10000000-0000-0000-0000-000000000001', true);
select is((select count(*)::int from public.chat_messages), 1, 'cohort A user sees only cohort A messages');
select lives_ok(
  $$insert into public.chat_messages (user_id, cohort_id, channel, content)
    values (auth.uid(), 'chat-test-a', 'help', 'valid post')$$,
  'cohort A user can post to their cohort and an allowed channel'
);
select throws_ok(
  $$insert into public.chat_messages (user_id, cohort_id, channel, content)
    values (auth.uid(), 'chat-test-b', 'general', 'cross-cohort post')$$,
  '42501', 'cohort A user cannot post to cohort B'
);
select throws_ok(
  $$insert into public.chat_messages (user_id, cohort_id, channel, content)
    values (auth.uid(), 'chat-test-a', 'secret-room', 'unauthorized channel')$$,
  '42501', 'cohort A user cannot post to an unlisted channel'
);

select set_config('request.jwt.claim.sub', '10000000-0000-0000-0000-000000000002', true);
select is((select count(*)::int from public.chat_messages), 1, 'cohort B user sees only cohort B messages');
select throws_ok(
  $$insert into public.chat_messages (user_id, cohort_id, channel, content)
    values (auth.uid(), 'chat-test-a', 'general', 'cross-cohort post')$$,
  '42501', 'cohort B user cannot post to cohort A'
);

select * from finish();
rollback;

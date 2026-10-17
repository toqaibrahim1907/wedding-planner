-- Run once in Supabase > SQL Editor
create table weddings(id uuid primary key default gen_random_uuid(), code text unique default substr(md5(random()::text),1,8));
create table members(wedding_id uuid references weddings on delete cascade, user_id uuid references auth.users, name text, primary key(wedding_id,user_id));
create table records(id uuid primary key, wedding_id uuid references weddings on delete cascade, kind text, data jsonb, updated_at timestamptz default now(), deleted bool default false);
alter table weddings enable row level security; alter table members enable row level security; alter table records enable row level security;
create function is_member(w uuid) returns bool language sql security definer stable as $$select exists(select 1 from members where wedding_id=w and user_id=auth.uid())$$;
create policy m_sel on members for select using (user_id=auth.uid() or is_member(wedding_id));
create policy w_sel on weddings for select using (is_member(id));
create policy r_all on records for all using (is_member(wedding_id)) with check (is_member(wedding_id));
create function create_wedding(n text) returns json language plpgsql security definer as $$
declare w weddings; begin insert into weddings default values returning * into w;
insert into members values (w.id,auth.uid(),n); return json_build_object('id',w.id,'code',w.code); end$$;
create function join_wedding(c text, n text) returns json language plpgsql security definer as $$
declare w weddings; begin select * into w from weddings where code=c; if w.id is null then raise exception 'bad code'; end if;
if (select count(*) from members where wedding_id=w.id)>=2 then raise exception 'full'; end if;
insert into members values (w.id,auth.uid(),n) on conflict do nothing; return json_build_object('id',w.id,'code',w.code); end$$;
alter publication supabase_realtime add table records;

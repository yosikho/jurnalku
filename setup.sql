-- Jurnalku: setup database Supabase
-- Cara pakai: Supabase → SQL Editor → New query → tempel semua isi file ini → Run.
-- Aman dijalankan ulang.

-- 1. Tabel entri jurnal
create table if not exists public.entries (
  user_id    uuid   not null default auth.uid() references auth.users(id) on delete cascade,
  id         text   not null,
  date       text   not null,              -- waktu lokal, format 2026-10-03T08:55
  ts         bigint not null,              -- untuk urutan
  text       text   not null default '',
  html       text,                         -- isi berformat (judul, checklist, tabel, foto di dalam teks)
  tags       text[] not null default '{}',
  place      jsonb,                        -- {name, lat, lng}
  photos     jsonb  not null default '[]',
  audio      jsonb  not null default '[]',
  source     text,
  updated    bigint not null default 0,
  created_at timestamptz not null default now(),
  primary key (user_id, id)
);
alter table public.entries add column if not exists html text;   -- untuk database lama
create index if not exists entries_user_ts on public.entries (user_id, ts desc);

-- 2. Tabel template
create table if not exists public.templates (
  user_id uuid   not null default auth.uid() references auth.users(id) on delete cascade,
  id      text   not null,
  name    text   not null,
  body    text   not null default '',
  updated bigint not null default 0,
  primary key (user_id, id)
);

-- 3. Kunci data: setiap akun hanya bisa melihat dan mengubah datanya sendiri
alter table public.entries   enable row level security;
alter table public.templates enable row level security;

drop policy if exists "entri milik sendiri" on public.entries;
create policy "entri milik sendiri" on public.entries
  for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "template milik sendiri" on public.templates;
create policy "template milik sendiri" on public.templates
  for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- 4. Tempat foto & suara (privat, maks 25 MB per file)
insert into storage.buckets (id, name, public, file_size_limit)
values ('media', 'media', false, 26214400)
on conflict (id) do update set public = false, file_size_limit = 26214400;

drop policy if exists "media baca sendiri"   on storage.objects;
drop policy if exists "media unggah sendiri" on storage.objects;
drop policy if exists "media ubah sendiri"   on storage.objects;
drop policy if exists "media hapus sendiri"  on storage.objects;

create policy "media baca sendiri" on storage.objects for select to authenticated
  using (bucket_id = 'media' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "media unggah sendiri" on storage.objects for insert to authenticated
  with check (bucket_id = 'media' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "media ubah sendiri" on storage.objects for update to authenticated
  using (bucket_id = 'media' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "media hapus sendiri" on storage.objects for delete to authenticated
  using (bucket_id = 'media' and (storage.foldername(name))[1] = auth.uid()::text);

-- 5. Sinkron langsung antar device (realtime)
do $$
begin
  begin alter publication supabase_realtime add table public.entries;   exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.templates; exception when duplicate_object then null; end;
end $$;

select 'Setup Jurnalku selesai' as status;

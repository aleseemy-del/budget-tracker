-- receipts bucket (private, 5 MB, images only)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('receipts', 'receipts', false, 5242880, array['image/jpeg','image/png','image/webp','image/heic']);

-- extra columns for the app
alter table public.expenses
  add column receipt_path text,
  add column user_id uuid default auth.uid() references auth.users(id) on delete cascade,
  add column type text not null default 'expense' check (type in ('expense','income')),
  add column payment_method text check (payment_method in ('card','cash','transfer','applepay'));

-- each user sees only their own rows
create policy "own expenses select" on public.expenses for select to authenticated using (user_id = auth.uid());
create policy "own expenses insert" on public.expenses for insert to authenticated with check (user_id = auth.uid());
create policy "own expenses update" on public.expenses for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own expenses delete" on public.expenses for delete to authenticated using (user_id = auth.uid());

-- each user sees only their own receipts (folder = user id)
create policy "own receipts select" on storage.objects for select to authenticated
  using (bucket_id = 'receipts' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "own receipts insert" on storage.objects for insert to authenticated
  with check (bucket_id = 'receipts' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "own receipts delete" on storage.objects for delete to authenticated
  using (bucket_id = 'receipts' and (storage.foldername(name))[1] = auth.uid()::text);

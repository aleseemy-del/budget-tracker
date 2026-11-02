create table public.expenses (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  category text not null,
  amount numeric(10,3) not null,
  description text not null,
  spent_on date not null default current_date,
  note text
);

alter table public.expenses enable row level security;

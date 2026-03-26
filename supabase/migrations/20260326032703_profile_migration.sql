create table if not exists public.profiles (
    id uuid references auth.users not null primary key,
    full_name text,
    chinese_level text,
    motivations text[],
    interests text[],
    onboarding_completed boolean default false,
    is_premium boolean default false,
    premium_exprires_at timestamp with time zone, 
    updated_at timestamp with time zone default now()
);

alter table public.profiles enable row level security;

create policy "Users can read own profile"
on public.profiles
for select
using (auth.uid() = id);

create policy "Users can update own profile"
on public.profiles
for update
using (auth.uid() = id)
with check (auth.uid() = id);

revoke update on table public.profiles from authenticated;
revoke insert on table public.profiles from authenticated;

grant select on table public.profiles to authenticated;

grant insert (
    id,
    full_name,
    chinese_level,
    motivations,
    interests,
    onboarding_completed,
    updated_at
) on table public.profiles to authenticated;

grant update (
    full_name,
    chinese_level,
    motivations,
    interests,
    onboarding_completed,
    updated_at
) on table public.profiles to authenticated;
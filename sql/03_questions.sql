-- Q1: How much did I spend on fuel?
select sum(amount) as total_fuel from public.expenses where category = 'Fuel';

-- Q2: What is my biggest expense?
select description, category, amount from public.expenses order by amount desc limit 1;

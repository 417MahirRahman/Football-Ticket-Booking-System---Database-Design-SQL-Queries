--- QUERY-1 ---
select match_id, fixture, base_ticket_price from matches
where tournament_category = 'Champions League' and match_status = 'Available';

--- QUERY-2 ---
select user_id, full_name, email from users
where full_name ilike 'Tanvir%' or full_name ilike '%Haque';

--- QUERY-3 ---
select booking_id, user_id, match_id, 
coalesce(payment_status, 'Action Required') as systematic_status from bookings
where payment_status is null;

--- QUERY-4 ---
select bookings.booking_id, users.full_name, matches.fixture, bookings.total_cost
from bookings 
inner join users on bookings.user_id = users.user_id
inner join matches on bookings.match_id = matches.match_id;

--- QUERY-5 ---
select users.user_id, users.full_name, bookings.booking_id
from users
left join bookings on users.user_id = bookings.user_id;

--- QUERY-6 ---
select booking_id, match_id, total_cost from bookings
where total_cost > (select avg(total_cost) from bookings);

--- QUERY-7 ---
select match_id, fixture, base_ticket_price from matches
order by base_ticket_price desc
limit 2 offset 1
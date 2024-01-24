use ig_clone;

select * from users;
-- 1.Find the 5 oldest users. --
select * from users
order by created_at
limit 5;


-- 2.What day of the week do most users register on? We need to figure out when to schedule an ad campaign.--

select DAYNAME(created_at) as registration_day,
		COUNT(*) as registration_count
from users
group by registration_day
order by registration_count desc
limit 1;

-- 3.We want to target our inactive users with an email campaign.Find the users who have never posted a photo--

select u.id,u.username
from users as u
left join photos as p 
on u.id = p.user_id
where p.user_id is null;



-- 4.We're running a new contest to see who can get the most likes on a single photo.WHO WON??!!--
select u.username as username,
  p.id as photo_id,
  COUNT(l.user_id) as like_count
from users as u
join photos as p
on u.id = p.id
left join likes as l
on p.id = l.user_id
group by
  u.username, p.id
order by
  like_count DESC
limit 1;


-- 5.Our Investors want to know… How many times does the average user post?HINT - *total number of photos/total number of users*--
select count(p.id) / count(u.id) as average_posts_per_user
from users as u
right join photos as p 
on u.id = p.id;


-- 6.user ranking by postings higher to lower--

select username,count(user_id) as count
from users as u
right join photos as p
on u.id = p.user_id
group by username
order by count desc;


-- 7.total numbers of users who have posted at least one time.--
select count(*) as total_num_of_users
from users as u
left join photos as p 
on u.id = p.user_id
where p.user_id is not null;


-- 8. A brand wants to know which hashtags to use in a post. what are the top 5 most commonly used hashtags?--

select tag_name,count(tag_name) as top_5 
from tags as t
join photo_tags as p
on t.id = p.tag_id
group by tag_name
order by top_5 desc
limit 5;

-- 9.We have a small problem with bots on our site...Find users who have liked every single photo on the site.--

select username,count(username) as count
 from likes as l
join photos as p
on l.photo_id = p.id
join users as u
on l.user_id = u.id
group by username
order by count desc
limit 13;

-- 10.Find users who have never commented on a photo.--
select u.id,u.username from users as u
left join comments as c
on  u.id = c.user_id
where photo_id is null;
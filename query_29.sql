--find the start and end time of group of 'on'.
--also, find the frequency of 'on' between the start and end times.

create table event_status
(
event_time varchar(10),
status varchar(10)
);
insert into event_status 
values
('10:01','on'),('10:02','on'),('10:03','on'),('10:04','off'),('10:07','on'),('10:08','on'),('10:09','off')
,('10:11','on'),('10:12','off');


--select * from event_status


with cte as (
select *, 
sum(case when status = 'on' and lag_status = 'off' then 1 else 0 end) over(order by event_time) as groups
from (
select *, 
lag(status, 1, status) over(order by event_time) as lag_status
from event_status) A)

select min(event_time) as start_time, max(event_time) as end_time, count(groups) - 1 as cnt_on
from cte
group by groups
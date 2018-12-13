-- User and SQL statement consuming undo space
select s.sql_text from v$sql s, v$undostat u
where u.maxqueryid=s.sql_id;

-- Most undo used by a session for a currently executing transaction
select s.sid,s.username,t.used_urec,t.used_ublk
from v$session s, v$transaction t
where s.saddr = t.ses_addr
order by t.used_ublk desc;

-- Session is currently using the most undo
select s.sid, t.name, s.value
from v$sesstat s, v$statname t
where s.statistic#=t.statistic#
and t.name='undo change vector size'
order by s.value desc;

-- x
select sql.sql_text, t.used_urec records, t.used_ublk blocks,
(t.used_ublk*8192/1024) kb from v$transaction t,
v$session s, v$sql sql
where t.addr=s.taddr
and s.sql_id = sql.sql_id
and s.username ='&USERNAME';


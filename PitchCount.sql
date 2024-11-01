SELECT rn "Pitch#", (sum(sum(h)) over (order by rn asc)::double precision/sum(sum(ab)) over (order by rn asc))::numeric(4,3) avg,
(sum(sum(wobasum)) over (order by rn asc)/sum(sum(pa)) over (order by rn asc))::numeric(4,3) as "wOBA" FROM(
	SELECT sum(h) h,sum(pa) pa,sum(ab) ab,rn,sum(wobasum) wobasum FROM (
		SELECT case when result2 between 13 and 14 then "wobaBB" else 0 end+
		case when result2 = 15 then "wobaHBP" else 0 end+
		case when result2 = 18 then woba1b else 0 end+
		case when result2 = 19 then woba2b else 0 end+
		case when result2 = 20 then woba3b else 0 end+
		case when result2 between 21 and 22 then "wobaHR" else 0 end as wobasum,
		ab, pa,h, ROW_NUMBER() OVER (PARTITION BY gameid,pitcherid,home ORDER BY gameevents.id DESC) rn 
		FROM gameevents 
		join game on gameid = game.id
		join tournamentevent te on te.id = tournamentid
		where nopitch = 0
		and tier = 1 and te.federation_id in (SELECT id from federation where tier = 1) and sport <5
		order by rn asc) as sub1 
	group by rn
	having sum(pa)>100 
	order by rn asc) as sub2
group by rn

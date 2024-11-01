SELECT bats "Bats",throws "Throws",sum(pa) "PA",(sum(h)::double precision/sum(pa))::numeric(4,3) avg,(sum(wobasum)/sum(pa))::numeric(4,3) woba	from
	(SELECT pr1.bats, pr2.throws, sum(h) h,sum(pa) pa,sum(ab) ab, (sum(h)::double precision/sum(ab))::numeric(4,3) avg,
	sum(case when result2 between 13 and 14 then "wobaBB" else 0 end)+
	sum(case when result2 = 15 then "wobaHBP" else 0 end)+
	sum(case when result2 = 18 then woba1b else 0 end)+
	sum(case when result2 = 19 then woba2b else 0 end)+
	sum(case when result2 = 20 then woba3b else 0 end)+
	sum(case when result2 between 21 and 22 then "wobaHR" else 0 end) as wobasum
	FROM Gameevents 
	join player_record pr1 on batterid = pr1.id 
	join player_record pr2 on pitcherid = pr2.id
	join game on gameid = game.id
	join tournamentevent on tournamentevent.id = game.tournamentid
	where pa = 1 and (pr2.throws = 'L' or  pr2.throws = 'R') and (pr1.bats = 'L' or  pr1.bats = 'R') and game.tournamentid in (SELECT id FROM tournamentevent where tier = 1 and federation_id in (SELECT id from federation where tier = 1) and sport <5)
	group by pr1.bats,pr2.throws,"wobaBB","wobaHBP",woba1b,woba2b,woba3b,"wobaHR") as sub1 
group by bats,throws
UNION ALL
SELECT 'Total',throws,sum(pa) pa,(sum(h)::double precision/sum(pa))::numeric(4,3) avg,(sum(wobasum)/sum(pa))::numeric(4,3) woba	from
	(SELECT pr1.bats, pr2.throws, sum(h) h,sum(pa) pa,sum(ab) ab, (sum(h)::double precision/sum(ab))::numeric(4,3) avg,
	sum(case when result2 between 13 and 14 then "wobaBB" else 0 end)+
	sum(case when result2 = 15 then "wobaHBP" else 0 end)+
	sum(case when result2 = 18 then woba1b else 0 end)+
	sum(case when result2 = 19 then woba2b else 0 end)+
	sum(case when result2 = 20 then woba3b else 0 end)+
	sum(case when result2 between 21 and 22 then "wobaHR" else 0 end) as wobasum
	FROM Gameevents 
	join player_record pr1 on batterid = pr1.id 
	join player_record pr2 on pitcherid = pr2.id
	join game on gameid = game.id
	join tournamentevent on tournamentevent.id = game.tournamentid
	where pa = 1 and (pr2.throws = 'L' or  pr2.throws = 'R') and (pr1.bats = 'L' or  pr1.bats = 'R') and game.tournamentid in (SELECT id FROM tournamentevent where tier = 1 and federation_id in (SELECT id from federation where tier = 1) and sport <5)
	group by pr1.bats,pr2.throws,"wobaBB","wobaHBP",woba1b,woba2b,woba3b,"wobaHR") as sub1 
group by throws

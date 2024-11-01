SELECT chances.throws "Throws",'2nd Base' "Base",chances "Chances", attempts "Attempts", concat(((attempts::double precision/chances)*100)::numeric(4,2),'%') "Attempt%" FROM 
	(SELECT pr.throws,count(*) as chances from gameevents
		join game on game.id = gameid
		join player_record pr on pitcherid = pr.id
	    where (runner1 > 0 and runner2 = 0) and (pr.throws = 'L' or  pr.throws = 'R')
	    and gameevents.pa = 1 and game.tournamentid in (SELECT id FROM tournamentevent where tier = 1 
		and federation_id in (SELECT id from federation where tier = 1) and sport <5) 
		group by pr.throws) as chances,
	(SELECT pr.throws,count(*) attempts from basestealing 
		join player_record pr on pitcherid = pr.id
		join game on game.id = gameid
		where (pr.throws = 'L' or  pr.throws = 'R') and base = 2 and game.tournamentid in (SELECT id FROM tournamentevent where tier = 1
		and federation_id in (SELECT id from federation where tier = 1) and sport <5)
	group by pr.throws) as attempts
	where chances.throws = attempts.throws
UNION ALL
SELECT chances.throws "Throws", '3rd Base and Home',chances "Chances", attempts "Attempts", concat(((attempts::double precision/chances)*100)::numeric(4,2),'%') "Attempt%" FROM 
	(SELECT pr.throws,count(*) as chances from gameevents
		join game on game.id = gameid
		join player_record pr on pitcherid = pr.id
	    where ((runner2 > 0 and runner3 = 0) or (runner3 > 0)) and (pr.throws = 'L' or  pr.throws = 'R')
	    and gameevents.pa = 1 and game.tournamentid in (SELECT id FROM tournamentevent where tier = 1 
		and federation_id in (SELECT id from federation where tier = 1) and sport <5) 
		group by pr.throws) as chances,
	(SELECT pr.throws,count(*) attempts from basestealing 
		join player_record pr on pitcherid = pr.id
		join game on game.id = gameid
		where (pr.throws = 'L' or  pr.throws = 'R') and (base = 3 or base = 4)and game.tournamentid in (SELECT id FROM tournamentevent where tier = 1
		and federation_id in (SELECT id from federation where tier = 1) and sport <5)
	group by pr.throws) as attempts
	where chances.throws = attempts.throws

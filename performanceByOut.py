def performanceByOut(self,filter):
        pas = [0,0]
        self.cur.execute("""SELECT gameid,outs,pitcherid,h,
                                (case when result2 = 13 then "wobaBB" else 0 end)+
                                (case when result2 = 15 then "wobaHBP" else 0 end)+
                                (case when result2 = 18 then woba1b else 0 end)+
                                (case when result2 = 19 then woba2b else 0 end)+
                                (case when result2 = 20 then woba3b else 0 end)+
                                (case when result2 between 21 and 22 then "wobaHR" else 0 end),
                                (case when result2 = 13 then 1 else 0 end),
                                (case when result2 = 15 then 1 else 0 end),
                                ab FROM gameevents 
                                    join game on gameid = game.id
                                    join tournamentevent te on te.id = tournamentid
                                    where pa = 1  """ + filter + """ and home = 0 order by gameevents.id""")
        pas[0] = self.cur.fetchall()
        self.cur.execute("""SELECT gameid,outs,pitcherid,h,
                                (case when result2 = 13 then "wobaBB" else 0 end)+
                                (case when result2 = 15 then "wobaHBP" else 0 end)+
                                (case when result2 = 18 then woba1b else 0 end)+
                                (case when result2 = 19 then woba2b else 0 end)+
                                (case when result2 = 20 then woba3b else 0 end)+
                                (case when result2 between 21 and 22 then "wobaHR" else 0 end),
                                (case when result2 = 13 then 1 else 0 end),
                                (case when result2 = 15 then 1 else 0 end),
                                ab FROM gameevents 
                                    join game on gameid = game.id
                                    join tournamentevent te on te.id = tournamentid
                                    where pa = 1  """ + filter + """ and home = 1 order by gameevents.id""")
        pas[1] = self.cur.fetchall()
        outcount = 0
        hitcount = [0]*40
        abcount = [0]*40
        wobasum = [0]*40
        walkcount = [0]*40
        hbpcount = [0]*40
        pacount = [0]*40
        gameid = 0
        pitcher = 0
        for y in range(0,2):
            for x in range(0,len(pas[y])):
                if pitcher != pas[y][x][2] or gameid != pas[y][x][0]:
                    outcount = 0
                    pitcher = pas[y][x][2]
                    gameid = pas[y][x][0]
                else:
                    if pas[y][x][1]-pas[y][x-1][1] >= 0:
                        outcount+= pas[y][x][1]-pas[y][x-1][1]
                    else:
                        outcount+= 3-pas[y][x-1][1]
                hitcount[outcount] += pas[y][x][3]
                try:
                    wobasum[outcount] += pas[y][x][4]
                except TypeError:
                    wobasum[outcount] += 0
                walkcount[outcount] += pas[y][x][5]
                hbpcount[outcount] += pas[y][x][6]
                abcount[outcount] += pas[y][x][7]
                pacount[outcount] +=1

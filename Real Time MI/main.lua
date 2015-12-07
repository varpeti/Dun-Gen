function love.load()

	love.window.setMode(1152,1152)

	love.window.setTitle("Dun-gen + Real time MI")

	love.graphics.setFont(love.graphics.newFont(18))

	seed = os.time()
	math.randomseed(seed)

	lll = {}

	lx=150 ly=150
	sx=lx sy=ly
	cx=50 cy=50 
	l2 = {}
	G = 0

	labgen(lll,0,0,64,64,15,7,10,4)   labgen(lll,64,0,64,64,15,7,10,4)   labgen(lll,128,0,64,64,15,7,10,4)
	labgen(lll,0,64,64,64,15,7,10,4)  labgen(lll,64,64,64,64,15,7,10,4)  labgen(lll,128,64,64,64,15,7,10,4)
	labgen(lll,0,128,64,64,15,7,10,4) labgen(lll,64,128,64,64,15,7,10,4) labgen(lll,128,128,64,64,15,7,10,4)

end

function love.update(dt)

 	local F = {1,1,1,1} -- ez lesz hogy mennyit ér a hely ahova léphetek (kisebb=jobb)
 	local torol = {0,0,0,0} 
	if #l2>5000 then table.remove(l2,1) end -- korlát

	for i,v in ipairs(lll) do --Vizsgálat h fal van e mellette
		if 	lx+1==v.x and ly==v.y   then F[1]=0 end --J
		if 	lx==v.x   and ly+1==v.y then F[2]=0 end --L
		if 	lx-1==v.x and ly==v.y   then F[3]=0 end --B
		if 	lx==v.x   and ly-1==v.y then F[4]=0 end --F
	end

 	if 	F[1]~=0 then F[1] = G+1 + math.floor( (((lx+1)-cx)^2+(ly-cy)^2)^(1/2) ) end --Az irányoknak megfelelően beállítja za értékeiket
 	if	F[2]~=0 then F[2] = G+1 + math.floor( ((lx-cx)^2+((ly+1)-cy)^2)^(1/2) ) end
 	if	F[3]~=0 then F[3] = G+1 + math.floor( (((lx-1)-cx)^2+(ly-cy)^2)^(1/2) ) end
 	if	F[4]~=0 then F[4] = G+1 + math.floor( ((lx-cx)^2+((ly-1)-cy)^2)^(1/2) ) end

 	for i,v in ipairs(l2) do
		if 	lx+1==v.x and ly==v.y   then if v.f~=0 and F[1]~=0 then F[1]=v.f+F[1] else F[1]=0 end  torol[1]=i end --Ha már léptünk rá hozzáadja az F-hez a régi F-et (Így csak akkor lépünk rá még 1x ha muszály)
		if 	lx==v.x   and ly+1==v.y then if v.f~=0 and F[2]~=0 then F[2]=v.f+F[2] else F[2]=0 end  torol[2]=i end --Ha viszont bármelyik (régi/új) = 0 akkor az új is 0 (tehát nem éri meg rálépni soha többet)
		if 	lx-1==v.x and ly==v.y   then if v.f~=0 and F[3]~=0 then F[3]=v.f+F[3] else F[3]=0 end  torol[3]=i end --És törölő listára rakjuk az előző rálépést (újjat adunk hozzá) (ha ide lépünk)
		if 	lx==v.x   and ly-1==v.y then if v.f~=0 and F[4]~=0 then F[4]=v.f+F[4] else F[4]=0 end  torol[4]=i end
	end

	local s = 0
 	local s2 = 0 
 	local nulla = 0

 	for i=1,4 do --Megvizsgálja hogy melyik a legjobb hely ahova léphetünk 
 		if F[i]~=0 then
 			if s==0 then
 				s=i
 				s2=F[i]
 			end
 			if i~=s and F[i]<=F[s] then
 				s=i
 				s2=F[i]
 			end
 		else
 			nulla=nulla+1
 		end
 	end

 	if nulla==3 then  --Ha három helyre se éri meg lépni, akkor arra amin állunk se éri meg többet (zsákutcákat így zárja le)
 		F[s]=0
 	end

 	if math.abs(lx-cx)+math.abs(ly-cy) == 0 then s=5 end -- győzelem

 	if 		s==1 then G=G+1 table.insert(l2,{x=lx,y=ly,f=F[1]}) lx=lx+1 if torol[1]~=0 then table.remove(l2,torol[1]) end  --Lépés szám növelés, a jelenlegi pozíció hozzáadása a hártunk már táblához, és a lépés
 	elseif	s==2 then G=G+1 table.insert(l2,{x=lx,y=ly,f=F[2]}) ly=ly+1 if torol[2]~=0 then table.remove(l2,torol[2]) end
 	elseif	s==3 then G=G+1 table.insert(l2,{x=lx,y=ly,f=F[3]}) lx=lx-1 if torol[3]~=0 then table.remove(l2,torol[3]) end
 	elseif	s==4 then G=G+1 table.insert(l2,{x=lx,y=ly,f=F[4]}) ly=ly-1 if torol[4]~=0 then table.remove(l2,torol[4]) end
	end

end


function love.draw()

		kx=576/6
		ky=576/6
	
		for i,v in ipairs(lll) do
			love.graphics.setColor(128,128,128,255) 
			love.graphics.circle("fill",v.x*6-kx*6+576,v.y*6-ky*6+576,3)
		end
	
 		for i,v in ipairs(l2) do
			if v.f==0 then love.graphics.setColor(255,0,0,255) else love.graphics.setColor(200,200,0,255) end
			love.graphics.circle("fill",v.x*6-kx*6+576,v.y*6-ky*6+576,3)
		end
	
 		love.graphics.setColor(0,200,200,255)
		love.graphics.circle("fill",cx*6-kx*6+576,cy*6-ky*6+576,3)
		love.graphics.circle("fill",sx*6-kx*6+576,sy*6-ky*6+576,3)
		
		love.graphics.setColor(0,255,0,255)
		love.graphics.circle("fill",lx*6-kx*6+576,ly*6-ky*6+576,3)

		love.graphics.setColor(255,255,255,255)
		love.graphics.print("Az MI lépéseinek száma: "..G.."\nTávolság a céltól: "..math.floor( ((lx-cx)^2+(ly-cy)^2)^(1/2) ).."\nSeed: "..seed,10,10)

end

function labgen(p,kx,ky,s,m,szobaszam,minnagysag,maxnagysag,tav,x,y,q) -- pontoknak tömb (visszatérés), kezdő x, kezdő y, szélesség, magasság, szobák száma, min nagyságuk, max nagyságuk, távolságuk, nil, nil, nil

	-- 1 fal 0 járat

	local lab = {}

	if not q then -- ha nincs q akkor kezdés
		--kx = math.ceil(kx/2)*2
		--ky = math.ceil(ky/2)*2
		s = math.floor(s/2)*2 -- páros számú kell legyen
		m = math.floor(m/2)*2
		x = kx
		y = ky 
		for jx=kx-2,kx+s+2 do --beállítja a területet
			lab[jx] = {}
			for jy=ky-2,ky+m+2 do
				lab[jx][jy]= 0
			end
		end
		roomgen(kx,ky,s,m,szobaszam,minnagysag,maxnagysag,tav,lab) --szoba generálás
	else
		lab = q
	end

	lab[x][y]=1 -- fal

	local ir = {1,2,3,4}
	local seged, r
	for i=1,4 do  -- Irány keverés
		r = math.random(1,4)
		seged = ir[r]
		ir[r] = ir[i]
		ir[i] = seged
	end

	for i=1,4 do
		if 1==ir[i] then --jobbra
			if x<=kx+s-0 and lab[x+2][y]==0 then
				lab[x+1][y]=1
				lab = labgen(nil,kx,ky,s,m,nil,nil,nil,nil,x+2,y,lab)
			end 
		end
		if 2==ir[i] then --balra
			if x>=kx and lab[x-2][y]==0 then
				lab[x-1][y]=1
				lab = labgen(nil,kx,ky,s,m,nil,nil,nil,nil,x-2,y,lab)
			end 
		end 
		if 3==ir[i] then --fel
			if y<=ky+m-0 and lab[x][y+2]==0 then
				lab[x][y+1]=1
				lab = labgen(nil,kx,ky,s,m,nil,nil,nil,nil,x,y+2,lab) 
			end 
		end 
		if 4==ir[i] then --le
			if y>=ky and lab[x][y-2]==0 then
				lab[x][y-1]=1
				lab = labgen(nil,kx,ky,s,m,nil,nil,nil,nil,x,y-2,lab)
			end 
		end 
	end
	if not q and p then -- labirintus lekódolása egy listába
		for jx=kx,kx+s do
			for jy=ky,ky+m do
				if lab[jx][jy]==0 and not ((jx==lx and jy==ly) or (jx==cx and jy==cy) ) then --KIKELL VENNI! - A CÉL ÉS A KEZDŐ TISZTASÁGA MIATT VAN BENNE A "C" ÉS "L"
					table.insert(p,{x=jx,y=jy})
				end
			end
		end
	end
	return lab
end

function roomgen(kx,ky,s,m,mr,ks,ms,mt,lab) -- kezdő x, kezdő y, szélesség, magasság, szoba szám, min szoba szélesség, min szoba magasság, szobák közti táv, lab tömb
	local tul = 0
	local rooms = {}
	mt = mt/2
	while #rooms~=mr and tul<=mr*5 do 
		local r = {}
       	r.s = math.floor(math.random(ks,ms)/2)*2 --páros
        r.m = math.floor(math.random(ks,ms)/2)*2
        r.x = math.ceil(math.random(kx+mt,kx+s-r.s-mt)/2)*2-1 --páratlan
        r.y = math.ceil(math.random(ky+mt,ky+m-r.m-mt)/2)*2-1

 		local b = true

        for j,r2 in ipairs(rooms) do -- ne érjenek össze
        	if r.x+mt>=-mt+r2.x 		and r.x-mt<=mt+r2.x+r2.s     	and r.y+mt>=-mt+r2.y 		and r.y-mt<=mt+r2.y+r2.m		then b=false break end--bf
        	if r.x+r.s+mt>=-mt+r2.x 	and r.x+r.s-mt<=mt+r2.x+r2.s 	and r.y+mt>=-mt+r2.y 		and r.y-mt<=mt+r2.y+r2.m		then b=false break end--jf
        	if r.x+r.s+mt>=-mt+r2.x 	and r.x+r.s-mt<=mt+r2.x+r2.s	and r.y+r.m+mt>=-mt+r2.y	and r.y+r.m-mt<=mt+r2.y+r2.m	then b=false break end--ja
        	if r.x+mt>=-mt+r2.x 		and r.x-mt<=mt+r2.x+r2.s 		and r.y+r.m+mt>=-mt+r2.y	and r.y+r.m-mt<=mt+r2.y+r2.m	then b=false break end--ba

        	if r2.x+mt>=-mt+r.x			and r2.x-mt<=mt+r.x+r.s    		and r2.y+mt>=-mt+r.y		and r2.y-mt<=mt+r.y+r.m			then b=false break end--bf2
        	if r2.x+r2.s+mt>=-mt+r.x	and r2.x+r2.s-mt<=mt+r.x+r.s	and r2.y+mt>=-mt+r.y		and r2.y-mt<=mt+r.y+r.m			then b=false break end--jf2
        	if r2.x+r2.s+mt>=-mt+r.x	and r2.x+r2.s-mt<=mt+r.x+r.s	and r2.y+r2.m+mt>=-mt+r.y	and r2.y+r2.m-mt<=mt+r.y+r.m	then b=false break end--ja2
        	if r2.x+mt>=-mt+r.x			and r2.x-mt<=mt+r.x+r.s			and r2.y+r2.m+mt>=-mt+r.y 	and r2.y+r2.m-mt<=mt+r.y+r.m	then b=false break end--ba2
        end

        if b then table.insert(rooms,r) else tul=tul+1 end --új szoba vagy tulcsordás védő
    end

    for i,r in ipairs(rooms) do -- szoba lekódolása a labirintusba
        	for x=0,r.s do
 				for y=0,r.m do
 					lab[x+r.x][y+r.y]=2 -- szoba
 				end
 			end
 		end
end
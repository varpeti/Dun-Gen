function love.load()

	love.window.setMode(1152,1152)

	love.window.setTitle("Dun-gen + Tervezö MI")

	love.graphics.setFont(love.graphics.newFont(18))
	seed = os.time()
	print(seed)
	math.randomseed(seed)

	lll = {}

	lx=150 ly=150
	cx=50 cy=50
	sx=lx sy=ly

	labgen(lll,0,0,64,64,15,7,10,4)   labgen(lll,64,0,64,64,15,7,10,4)   labgen(lll,128,0,64,64,15,7,10,4)
	labgen(lll,0,64,64,64,15,7,10,4)  labgen(lll,64,64,64,64,15,7,10,4)  labgen(lll,128,64,64,64,15,7,10,4)
	labgen(lll,0,128,64,64,15,7,10,4) labgen(lll,64,128,64,64,15,7,10,4) labgen(lll,128,128,64,64,15,7,10,4)

	ut = {}
	ut,G = MI(lx,ly)

end

function MI(lx,ly)
	local vizsg = {}
	local varo = {}
	local sz = 0
	table.insert(varo,{x=lx,y=ly,f=-1,sz=0}) -- start mező a váró listára

	while #varo>0 do -- addig keresünk míg van hol
		local F = varo[1].f
		local id = 1
		for i,v in ipairs(varo) do -- megkeressük a legkisseb várólistás elemet
			if v.f<F then F=v.f id=i end
		end

		lx = varo[id].x
		ly = varo[id].y
		sz = varo[id].sz
		table.insert(vizsg,{x=lx,y=ly,f=F,sz=sz}) --vizsgáltra elyezés
		table.remove(varo,id) -- töröljük a váróról
		sz=#vizsg

		if lx==cx and ly==cy then  --A legrövidebb út
			varo = {}
			local i = #vizsg
			while i>0 do
				table.insert(varo,{x=vizsg[i].x,y=vizsg[i].y})
				i=vizsg[i].sz
			end
			return varo,#vizsg
		end

		local fal = {0,0,0,0} 
		for i,v in ipairs(lll) do -- Fal vizshálat
			if 	lx+1==v.x and ly==v.y   then fal[1]=1 end 
			if 	lx==v.x   and ly+1==v.y then fal[2]=1 end 
			if 	lx-1==v.x and ly==v.y   then fal[3]=1 end 
			if 	lx==v.x   and ly-1==v.y then fal[4]=1 end
		end
		for i,v in ipairs(vizsg) do -- voltunk e már ott
			if 	lx+1==v.x and ly==v.y   then fal[1]=1 end 
			if 	lx==v.x   and ly+1==v.y then fal[2]=1 end 
			if 	lx-1==v.x and ly==v.y   then fal[3]=1 end 
			if 	lx==v.x   and ly-1==v.y then fal[4]=1 end
		end

		for i=1,4 do 
			if fal[i]==0 then -- kiválogatva azok amikre léphetünk
				if i==1 then --j
					local vv = 0 
					for i,v in ipairs(varo) do --Várón van-e már a vizsgált szomszéd
						if 	lx+1==v.x and ly==v.y   then vv=v break end 
					end
					local F =math.floor( (((lx+1)-cx)^2+(ly-cy)^2)^(1/2) )
					if vv~=0 then
						if vv.f<F then table.insert(varo,{x=lx+1,y=ly,f=vv.f,sz=sz}) end -- Van-e rövidebb útvonal hozzá?
					else
						table.insert(varo,{x=lx+1,y=ly,f=F,sz=sz})-- Váró listára szülővel és F értékkel
					end
				end
				if i==2 then --l
					local vv = 0 
					for i,v in ipairs(varo) do --Várón van-e már a vizsgált szomszéd
						if 	lx==v.x   and ly+1==v.y then vv=v break end 
					end
					local F =math.floor( ((lx-cx)^2+((ly+1)-cy)^2)^(1/2) )
					if vv~=0 then
						if vv.f<F then table.insert(varo,{x=lx,y=ly+1,f=vv.f,sz=sz}) end -- Van-e rövidebb útvonal hozzá?
					else
						table.insert(varo,{x=lx,y=ly+1,f=F,sz=sz})-- Váró listára szülővel és F értékkel
					end
				end
				if i==3 then --b
					local vv = 0 
					for i,v in ipairs(varo) do --Várón van-e már a vizsgált szomszéd
						if 	lx-1==v.x and ly==v.y   then vv=v break end 
					end
					local F =math.floor( (((lx-1)-cx)^2+(ly-cy)^2)^(1/2) )
					if vv~=0 then
						if vv.f<F then table.insert(varo,{x=lx-1,y=ly,f=vv.f,sz=sz}) end -- Van-e rövidebb útvonal hozzá?
					else
						table.insert(varo,{x=lx-1,y=ly,f=F,sz=sz})-- Váró listára szülővel és F értékkel
					end
				end
				if i==4 then --f
					local vv = 0 
					for i,v in ipairs(varo) do --Várón van-e már a vizsgált szomszéd
						if 	lx==v.x   and ly-1==v.y then vv=v break end 
					end
					local F =math.floor( ((lx-cx)^2+((ly-1)-cy)^2)^(1/2) )
					if vv~=0 then
						if vv.f<F then table.insert(varo,{x=lx,y=ly-1,f=vv.f,sz=sz}) end -- Van-e rövidebb útvonal hozzá?
					else
						table.insert(varo,{x=lx,y=ly-1,f=F,sz=sz})-- Váró listára szülővel és F értékkel
					end
				end
			end
		end
	end
	return nil
end


function love.draw()
	
		for i,v in ipairs(lll) do
			love.graphics.setColor(128,128,128,255) 
			love.graphics.circle("fill",v.x*6,v.y*6,3)
		end

		for i,v in ipairs(ut) do
			love.graphics.setColor(200,200,000,255) 
			love.graphics.circle("fill",v.x*6,v.y*6,3)
		end
	
 		love.graphics.setColor(0,200,200,255)
 		love.graphics.circle("fill",cx*6,cy*6,3)
 		love.graphics.circle("fill",sx*6,sy*6,3)

		
		love.graphics.setColor(0,255,0,255)
		love.graphics.circle("fill",lx*6,ly*6,3)


		love.graphics.setColor(255,255,255,255)
		love.graphics.print("Az MI "..G.." tervezett lépésböl ténylegesen "..#ut.."-t lépett. \nSeed: "..seed,10,10)

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
				if lab[jx][jy]==0 and not ((jx==lx and jy==ly) or (jx==cx and jy==cy) ) then --KI KELL VENNI! - A CÉL ÉS A KEZDŐ TISZTASÁGA MIATT VAN BENNE A "C" ÉS "L"
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
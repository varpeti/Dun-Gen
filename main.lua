function love.load()

	love.window.setMode(1152,1152)

	love.window.setTitle("Dun-gen")

	love.graphics.setFont(love.graphics.newFont(18))

	seed = os.time()
	math.randomseed(seed)

	lll = {}

	labgen(lll,0,0,64,64,15,7,10,4)   labgen(lll,64,0,64,64,15,7,10,4)   labgen(lll,128,0,64,64,15,7,10,4)
	labgen(lll,0,64,64,64,15,7,10,4)  labgen(lll,64,64,64,64,15,7,10,4)  labgen(lll,128,64,64,64,15,7,10,4)
	labgen(lll,0,128,64,64,15,7,10,4) labgen(lll,64,128,64,64,15,7,10,4) labgen(lll,128,128,64,64,15,7,10,4)

end

function love.draw()
	
		for i,v in ipairs(lll) do
			love.graphics.setColor(128,128,128,255) 
			love.graphics.circle("fill",v.x*6,v.y*6,3)
		end

		love.graphics.setColor(255,255,255,255)
		love.graphics.print("Seed: "..seed,10,10)
	

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
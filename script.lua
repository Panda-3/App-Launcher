-- App Launcher BETA v0.1 --
color.loadpalette()
color.shine = color.new(255,255,255,100) -- new color shine!
BG = image.load("sce_sys/livearea/contents/arrow.png")
BG1 = image.load("sce_sys/livearea/contents/bg0.png")
-- font.setdefault("sce_sys/livearea/contents/font.ttf")
-- logo = image.load("sce_sys/icon0.png")
over = 1
buttons.interval(8,8)
buttons.analogtodpad(60)
xtitle = 240
local pos = 1;
local result,result_rmv = 0,0
local icons = {}
local list = {data = {}, len = 0}
local bkg = {}
function reload_list()
	pos = 1;
	icons = {}
	list.data = game.list()
	table.sort(list.data ,function (a,b) return string.lower(a.id)<string.lower(b.id); end)
	list.len = #list.data
	for i=1,list.len do
		if list.data[i].path:sub(1,4) == "ux0:" then
			if hw.removablemc() == 1 then
				list.data[i].location = "Mem-Card"
			else
				list.data[i].location = "Mem-Emu"
			end
			list.data[i].flag = 1
		else
			list.data[i].location = "Internal"
			list.data[i].flag = 0
		end
		local img = nil
		local info = nil
		local bg = nil
		if list.data[i].path:sub(1,10) == "ux0:pspemu" then
			img = game.geticon0(string.format("%s/eboot.pbp",list.data[i].path))
			info = game.info(string.format("%s/eboot.pbp",list.data[i].path))
			bg = game.getpic0(string.format("%s/eboot.pbp",list.data[i].path))
		else
			img = image.load(string.format("%s/sce_sys/icon0.png",list.data[i].path))
			info = game.info(string.format("%s/sce_sys/param.sfo",list.data[i].path))
			bg = image.load(string.format("%s/sce_sys/pic0.png",list.data[i].path))
		end
		if info and info.TITLE then
			list.data[i].title = info.TITLE
		end
		icons[i] = img
		bkg[i] = bg
	end
end
reload_list()
while true do
	if bkg[pos] then
			bkg[pos]:center()
			bkg[pos]:blit(480,272)
			screen.clip()
	else
		image.blit(BG1,0,0)
	end
	buttons.read()
	if back then back:blit(0,0) end
	if bg then back:blit(0,0) end
	screen.print(480,10,"Game Launcher (Apps - Bubbles)",1,color.white,color.blue,__ACENTER)
	screen.print(950,10,os.date("%I:%M %p"),1,color.white,0x0,__ARIGHT)
	screen.print(135,10,"Battery " + batt.lifepercent () + "%",1,color.white,0x0,__ARIGHT)
	screen.print(950,30,"Apps: " + list.len,1,color.red,0x0,__ARIGHT)
	if list.len > 0 then
		if buttons.up and pos > 1 then pos -= 1 end
		if buttons.down and pos < list.len then pos += 1 end
		if buttons.l and pos > 15 then pos -= 15 end
		if buttons.l and pos < 15 then pos = 1 end
		if buttons.r and pos < list.len then pos += 15 end
		if buttons.r and pos > list.len then pos = list.len end
		if buttons.cross then
			game.launch(list.data[pos].id)
		end	
		if buttons.circle then 
			game.launch("VITASHELL")	
		end		
		if icons[pos] then
			screen.clip(950-64,405+64, 128/2)
			icons[pos]:center()
			icons[pos]:blit(950-128 + 64,405 + 64)
			screen.clip()
		end	
		local y = 75
		for i=pos,math.min(list.len,pos+14) do
			if i == pos then
				-- screen.print(10,y,"->",1,color.red)
			image.blit(BG,10,75)				
			end
			screen.print(40,y,'#'+string.format("%03d",i)+' '+list.data[i].title or "unk",1,color.white,color.orange)
			screen.print(800,y,list.data[i].id or "unk",1,color.white,color.yellow)
			--screen.print(600,y,list[i].cat or "unk")
			y += 20
		end
		screen.print(10,475,"Press L/R for Prev/Next Page ",1,color.yellow)
		screen.print(10,495,"Press X to Launch " + list.data[pos].title,1,color.magenta)
		screen.print(10,515,"Press O to Launch " + "VitaShell",1,color.cyan)
	else
		screen.print(10,30,"Vacio o error?")
	end

	screen.flip()

	if buttons.released.start then break end
end

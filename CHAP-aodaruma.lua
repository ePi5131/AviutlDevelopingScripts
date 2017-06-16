-- 何かに使えればのlua
-- dofile('C:\\Users\\Aodaruma\\Desktop\\aviutl\\plugins\\script\\my scripts\\CHAP-aodaruma.lua')

local addAffectorDelayT = function(n,st) -- n==指定配列、st==添え字

--[[
	Appeaに必要なAffectを用意する関数。
	DelayTrackが必要。
]]--

	local af={}
	local d=DT[(type(st)=="string" and st) or tostring(st)]
	local i

	for i=1,#d do
		af[i] = d[i][n]
	end
	af["n"] = #d
	return af
end

Appea_01 = function(st) -- st==添え字

--[[
	DelayTrackが必要。
	指定配列は「1」、numは4です。
]]--

	local af = addAffectorDelayT(1,st)
	local n,uf = af.n,{}
	local i

	-- if(n==4) then
		for i=1,n do
			af[i] = af[i]/100
			table.insert(uf,(1-af[i]))
		end

		obj.setoption("dst","tmp",obj.w,obj.h)
			obj.copybuffer("obj","cache:back-"..obj.layer)
			obj.effect("透明度","透明度",30)
			obj.effect("単色化","輝度を保持する",0,"color",0x000000,"強さ",50)
			obj.effect("斜めクリッピング","角度",90*af[2],"幅",obj.h*af[2]+1)
		obj.draw()

		obj.setoption("dst","tmp")
			obj.copybuffer("obj","cache:back-"..obj.layer)
			obj.effect("透明度","透明度",30)
			obj.effect("単色化","輝度を保持する",0,"color",0x000000,"強さ",80)
			obj.effect("斜めクリッピング","角度",90*af[3],"幅",obj.h*af[3]+1)
		obj.draw()

		obj.setoption("dst","tmp")
			obj.copybuffer("obj","cache:back-"..obj.layer)
			obj.effect("エッジ抽出")
			obj.effect("リサイズ","X",100*af[1])
		obj.draw()

		obj.load("tempbuffer")
	-- end
end

testerfunction = function()
	obj.effect("単色化","輝度を保持する",0,"color",0xff0000,"強さ",100)
end
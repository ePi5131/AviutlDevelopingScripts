require("rikky_module")

local log=function(s) if obj.getinfo("saving")==false then debug_info(s) end end

local saving,reading,clearing,getIsExist=
	function(bn,s,p)
		if checkRm() then
			if p then rikky_module.image("w+",bn..s) else rikky_module.image("w",bn..s) end
		else
			obj.copybuffer("cache:"..bn..":"..s,"obj")
		end
	end,
	function(bn,s)
		if checkRm() then
			rikky_module.image("r",bn..s)
		else
			obj.copybuffer("obj","cache:"..bn..":"..s)
		end
	end,
	function(bn,s)
		if checkRm() then
			rikky_module.image("c",bn..s)
		else
			-- obj.copybuffer("cache:"..bn..":"..s)
		end
	end,
	function(bn,s)
		local g
		if checkRm() then
			g=rikky_module.image("i",bn..s)
			if type(g)=="boolean" and g==false then return 0 else return 1 end
		end
		return -1
	end


Aodaruma={
	log		=	log,
	images	=	{
		save		=	saving,
		read 		=	reading,
		clear 		=	clearing,
		getExist 	=	getIsExist
	}
}

--------------------------------------------------------------------------------------------------------------------------------
local easingAffect = function(af,type,backCoefficient) --Affect: 0~100(%)
	--===================================--
	local E = require("easing")
	local div = {
		E.linear				,--  1
		E.inQuad				,--  2
		E.outQuad				,--  3
		E.inOutQuad				,--  4
		E.outInQuad				,--  5
		E.inCubic 				,--  6
		E.outCubic				,--  7
		E.inOutCubic			,--  8
		E.outInCubic			,--  9
		E.inQuart				,-- 10
		E.outQuart				,-- 11
		E.inOutQuart			,-- 12
		E.outInQuart			,-- 13
		E.inQuint				,-- 14
		E.outQuint				,-- 15
		E.inOutQuint			,-- 16
		E.outInQuint			,-- 17
		E.inSine				,-- 18
		E.outSine				,-- 19
		E.inOutSine				,-- 20
		E.outInSine				,-- 21
		E.inExpo				,-- 22
		E.outExpo				,-- 23
		E.inOutExpo				,-- 24
		E.outInExpo				,-- 25
		E.inCirc				,-- 26
		E.outCirc				,-- 27
		E.inOutCirc				,-- 28
		E.outInCirc				,-- 29
		E.inElastic				,-- 30 ====
		E.outElastic			,-- 31
		E.inOutElastic			,-- 32
		E.outInElastic			,-- 33 ====
		E.inBack				,-- 34
		E.outBack				,-- 35
		E.inOutBack				,-- 36
		E.outInBack				,-- 37
		E.inBounce				,-- 38
		E.outBounce				,-- 39
		E.inOutBounce			,-- 40
		E.outInBounce			,-- 41
	}
	--==================================--
	-- Undofishさんのeasing_aviutlより引用。 --
	--==================================--
	local s = backCoefficient or 1.70158
	local b = 0
	local c = 1
	local d = 1
	local t = af/100
	local p,a=
	local result
	if(type>=30) and (type<=33) then
		result = div[type](t,b,c,d,a,p)
	else
		result = div[type](t,b,c,d)
	end
	result = (result~=result and 0) or result
	return result
end
--------------------------------------------------------------------------------------------------------------------------------

local calLength = function(a,b,c,a2,b2,c2)
	if(b2 and c2) then
		return math.sqrt((a2-a)^2+ (b2-b)^2+ (c2-c)^2)
	else
		return math.sqrt((c-a)^2+ (a2-b))
	end
end
--------------------------------------------------------------------------------------------------------------------------------

local makeImageDiv = function()
	--[[
		seachDll(isString[true/false/nil])	:	rikky_moduleを探します。
												isStringで文字列でエラーを出力するか決定します。

		load()								:	rikky_moudleを読み込みます。
												読み込む前に自動的にseachDllを実行します。

		check()								:	rikky_moduleが読み込まれているかチェックします。
												読み込まれていなければ自動でloadで読み込みます。

		read(id[number/string],
			tp[true/false/nil])				:	imageを読み込みます。
												自動でcheck関数を実行します。
												tpでrikky_module.imageの指定文字を拡張します。

		write(id[number/string],
			tp[true/false/nil])				:	imageを書き込みます。
												自動でcheck関数を実行します。
												tpでrikky_module.imageの指定文字を拡張します。

		clear(id[number/string],
			tp[true/false/nil])				:	imageを消去します。
												自動でcheck関数を実行します。
												tpでrikky_module.imageの指定文字を拡張します。

		mash(id[number/string],
			tp[true/false/nil])				:	imageをロードします。
												自動でcheck関数を実行します。
												tpでrikky_module.imageの指定文字を拡張します。

	]]--
	if(type(image)~="table")then
		image={
			seachDll = function(isString)
				local path=obj.getinfo("script_path")
				while(string.sub(path,#path,#path)=="\\") do
					path=string.sub(path,1,#path-1)
				end
					path=path.."\\rikky_module.dll"
				local t=io.open(path,"r")
				if t then
					t:close()
					return true
				end
				if(isString) then
					return string.format(
						"error/layer:%s\rikky_moduleが見つかりませんでした。\n正常に導入されているか確認してください",
						obj.layer
						)
				else
					return false
				end
			end

			load = function()
				if(seachDll()) then
					require("rikky_module") 
					return true
					else
						return false
					end
			end,

			check = function()
				if(type(rikky_module)~="table")then
					return load()
				end
				return true
			end,

			read = function(id,tp)
				if(tp) and check() then
					rikky_module.image("r+",id)
				else
					rikky_module.image("r",id)
				end
			end,

			write = function(id,tp)
				if(tp) and check() then
					rikky_module.image("w+",id)
				else
					rikky_module.image("w",id)
				end
			end,

			clear = function(id,tp)
				if(tp) and check() then
					rikky_module.image("c+",id)
				else
					rikky_module.image("c",id)
				end
			end,

			mash = function(from,to,tp,x,y)
				x,y=
					x or 0,
					y or 0
				if(tp) and check() then
					rikky_module.image("m+",to,from,x,y)
				else
					rikky_module.image("m",to,from,x,y)
				end
			end,

			info = function(id,tp)
				if(tp) and check() then
					return rikky_module.image("i+",id)
				else
					return rikky_module.image("i",id)
				end
			end,

			seach = function()
				check() and rikky_module.image("g")
			end,

			seachdiv = function()
				check() and rikky_module.image("g+")
			end
		}
	end
	return true
end
--------------------------------------------------------------------------------------------------------------------------------

local seeArray = function(div)
	seeArray = seeArray or {}
	seeArray{
		d = function(dv)
			local i,r
			if(type(dv)=="table") then
				r="{"
				for i=1,#dv do
					r = seeArray.d(dv[i])
				end
			else
				
			end
		end
	}
end
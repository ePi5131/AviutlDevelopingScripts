local E = require("easing")
local ft = {
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
	E.inElastic				,-- 30
	E.outElastic			,-- 31
	E.inOutElastic			,-- 32
	E.outInElastic			,-- 33
	E.inBack				,-- 34
	E.outBack				,-- 35
	E.inOutBack				,-- 36
	E.outInBack				,-- 37
	E.inBounce				,-- 38
	E.outBounce				,-- 39
	E.inOutBounce			,-- 40
	E.outInBounce			,-- 41
}
local function easing(et, t, b, c, d, s, a, p)
	local r
	if( et >= 30 and et <= 33 ) then
		if( a ~= nil ) then
			a = a + c
		end
		r = ft[et](t,b,c,d,a,p)
	else
		r = ft[et](t,b,c,d,s)
	end
	
	-- なんか-1.#INDで返ってくる場合があるようなのでチェック
	-- LuaにおけるNaNのことで、こうやって判定するらしい？
	if( r~=r ) then
		-- NaNなら、とりあえず初期値を返す
		return b
	else
		return r
	end
end
return {
	-- 受けた変数(現在はE).easing()でAVIUTLからも、固有処理を飛ばして直接上の関数を呼べるようにする
	easing = easing, 
	
	-- AVIUTL固有処理 .anmの方に入れたほうが良かったかも
	easing_aviutl = function()
		E.LEN = nil
		
		local i = (interval == nil) and 0 or (interval * obj.framerate / 1000)
		local d = obj.totalframe - (obj.num-1)*i
		local c = obj.track2-obj.track1
		local t = math.min(math.max(0,obj.frame - obj.index*i),d)
		local s = es
		local a = ea
		local p = ep
		
		if( d <= 0 ) then
			if( obj.index == 0 ) then
				-- E.LENに足りない分を返す、ただし自分自身のテキストオブジェクト内でmes(E.LEN)しても駄目
				-- （もっとも出せても、そのデバッグ文字でさらにインターバルが加算されてイミフになるが）
				-- 下のレイヤーでmes(E.LEN)すると出せる。が、エラーが2つ以上ある場合上書きされるので注意
				debug_print(string.format("layer%d:%s %dフレーム足りません",obj.layer,obj.getoption("script_name"),-d+1))
			end
			E.LEN = -(-d+1)
			return 0
		end
		
		if( obj.track3>=0 ) then
			-- 進捗%とインターバルの同時利用はよくわからないので諦めた
			t = d * obj.track3 / 100
		end
		
		--debug_print(string.format("index=%f num=%f i=%f t=%f c=%f d=%f s=%f a=%f p=%f",obj.index,obj.num,i,t,c,d,(s==nil)and(0)or(s),(a==nil)and(0)or(a),(p==nil)and(0)or(p)))
		return easing(obj.track0,t,obj.track1,c,d,s,a,p)
	end,
	
	-- イージングの個数を返す
	get_easing_length = function()
		return #ft
	end,
	
	-- 有効なイージングタイプかどうか
	is_easing_type = function(et)
		return (et>=1 and et<=#ft)
	end
}
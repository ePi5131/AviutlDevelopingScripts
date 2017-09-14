--[[
	私のスクリプトを使う上で必要となるluaファイルになります。
	このluaファイルはpluginsフォルダーに置いてください。
]]
Log = function(str)
	--[[
		debugモニターに表示するログを書く関数です。
		セーブ中はログは表示されません。
		また、strはstring型で入力してください。
	]]
	if obj.getinfo("saving")==false then debug_print(s) end
end

return {
	Log=Log,

	LoadRikkyModule = function(opt)
		--[[
			rikkyさんのdllのrikky_moduleを読み込む際に使用する関数です。
			rikky_module.dllはpluginsフォルダー、もしくはscriptフォルダーに置いてください。
			optでエラーメッセージを表示するかを指定します。
		]]
		if rikky_module==nil then
			require("rikky_module")
			if rikky_module==nil then
				if opt then
					Log("We cant find the module 'rikky_module'!")
				end
				return false
			end
			return true
		end
	end,
}
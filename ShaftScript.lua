--[[
このluaファイルは、「TAシャフト変換」のUTF-8から判別して置き換える変数を用意するものです。
主に多次元配列を利用しておりますので、わかる方はわかる方で置き換えを行っていただいてもかまいません。
おそらく動画で説明されていると思いますが、rikkyさんのdll必須です。
また、間違ってもこのluaを消さないようお願いいたします。エラーが出て使い物にならなくなります<(_ _)>

by Aodaruma
]]--
function TAshaftTrans(tx)
require("rikky_module")
local result="文字コード:\n変換前 "..tx
local code,num=rikky_module.convert(text,"unicode","hex","little")
result=result.."\n変換後 "..code[1]

if(num>1) then
for i=2,num do
result=result..", "..code[i]
end
end
return result
end

local TAshaftTrans={
{"言","云"},
{"ウ","フ"},
{"学","學"},
{"会","逢"},
{"イ","ヒ"},
{"一","壱"},
{"二","弐"},
{"三","参"},
{"ト","タ"}
}

local TAshaftTransKana={
{"あ","ア"},
{"い","イ"},
{"う","ウ"},
{"え","エ"},
{"お","オ"},
{"か","カ"},
{"き","キ"},
{"く","ク"},
{"け","ケ"},
{"こ","コ"},
}
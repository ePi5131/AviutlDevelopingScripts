--[[

◇variousemoveTypeTable配列の書き方
このスクリプトはluaから多重配列を利用しています。
よってvariousemoveTypeTable配列に配列を追加すればカスタム化することができます。

Moviengの配列は次のようになっています。
配列要素:　パレットのもととなるカラーです。「0x」から始まる16進数のカラーコードで記されます。
配列要素name: パレットの種類名です。string型で表記します。

variousemoveDefaultTableで元々設定されていたdefaultMovingを呼び出せます。
]]--

variousmoveTypeTable={

{
name="上下交互移動",
moveX=function(t,i,n,b)
	return t
end,
moveY=function(t,i,n,b)
	return b.sh*(i%2)+b.sh*-1*(i%2+1)
end,
moveZ=function(t,i,n,b)
	return t
end
}

}

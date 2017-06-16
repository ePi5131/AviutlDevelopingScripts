    --[[関数を使う場合は
	requre("fan_clipping")
	と記述すれば関数が下の関数が呼び出されます
	track2以下の引数に関しては入力しなくても使えるように処理していますので
	最低でもbuffer,track0,track1の3つだけでも設定してください
	bufferは用いる際に仮想バッファ内だったら1としてフレームバッファに描画する場合は0にしてください
	fun_clipping(0,90,120)のようにすれば、フレームバッファに基準角90で拡張角120度で設定されます
	シーンなど挟むと点滅することや画像が乱れることがままあります
	一度キャッシュを廃棄すると直る場合があります
    ]]--
function fan_clipping(buffer,track0,track1,track2,track3,check0,alpha,edg,dth,mono,col,st,lum,bl,range,asp,fla,fst,di,th,vd,fcol)
	if buffer~=1 then buffer=0 end
	if track2==nil then track2=0 end
	if track3==nil then track3=0 end
	if check0==0 then check0=false end
	if alpha==nil then alpha=100 end
	if edg==nil then edg=0 end
	if mono==nil then mono=0 end
	if bl==nil then bl=0 end
	if fla==nil then fla=0 end
	--alphaの値の範囲は0から100までとします
	if alpha<0 then alpha=0 elseif 100<alpha then alpha=100 end
	track0=track0%360
	if track1<-360 then track1=-360 elseif 360<track1 then track1=360 end
	--元々ある仮想バッファを一時避難
	obj.copybuffer("cache:tmptmp","tmp");

	--斜めクリッピングの境界のゴミが完全に取れないのでtrack0が0か-360か360のときは斜めクリッピングを使わないようにする
	--透明度が100のときは
	if(alpha~=100 and (track1==360 or track1==-360))then
		--ここはクリッピングで欠損する部分のオブジェクト
		if edg==1 then
			obj.effect("エッジ抽出","しきい値",dth)
		end
		if mono==1 then
			obj.effect("単色化","強さ",st,"color",col,"輝度を保持する",lum)
		end
		if bl==1 then
			obj.effect("ぼかし","範囲",range,"縦横比",asp,"サイズ固定",1)
		end
		if fla==1 then
			--fcolの有無で元の色設定を活かすかを選ぶ
			if fcol=="" then
				obj.effect("発光","強さ",fst,"拡散",di,"しきい値",th,"拡散速度",vd,"no_color",1,"サイズ固定",1)
			else
				obj.effect("発光","強さ",fst,"拡散",di,"しきい値",th,"拡散速度",vd,"color",tonumber(fcol),"no_color",0,"サイズ固定",1)
			end
		end
		--透明度を設定
		obj.alpha=obj.alpha*(1-alpha*0.01)

	elseif(track1~=0)then
		--track1が0以外のときは元オブジェクトがクリッピングされる
		--元オブジェクトのイメージを保存
		obj.copybuffer("cache:dclip1","obj")
		w,h=obj.getpixel()
		if(alpha~=100)then
			--alphaが100以外のときは欠損部分が表示されるので、そのイメージを制作して保存
			if edg==1 then
				obj.effect("エッジ抽出","しきい値",dth)
			end
			if mono==1 then
				obj.effect("単色化","強さ",st,"color",col,"輝度を保持する",lum)
			end
			if bl==1 then
				obj.effect("ぼかし","範囲",range,"縦横比",asp,"サイズ固定",1)
			end
			if fla==1 then
				if fcol=="" then
					obj.effect("発光","強さ",fst,"拡散",di,"しきい値",th,"拡散速度",vd,"no_color",1,"サイズ固定",1)
				else
					obj.effect("発光","強さ",fst,"拡散",di,"しきい値",th,"拡散速度",vd,"color",tonumber(fcol),"no_color",0,"サイズ固定",1)
				end
			end
			obj.copybuffer("cache:dclip2","obj")
		end
		--仮想バッファで複数の画像と一枚のオブジェクト化
		obj.setoption("drawtarget","tempbuffer",w,h)
		--ブレンドを"alpha_add"にして隙間を埋める
		obj.setoption("blend","alpha_add")
		--obj.check0でタイプを仕分ける
		if(not check0)then
			--こっちが時計タイプ
			--元オブジェクトのイメージを呼び出す
			obj.copybuffer("obj","cache:dclip1")
			--斜めクリッピングを二度がけ
			obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0)
			if(0<=track1)then
				obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+track1)
			elseif(track1<=-180)then
				obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+track1+180)
			end
			if(-360<track1 and track1<180)then
				obj.draw()
			end
			--二つ用意することで扇形をなす
			--角度は180度加えて半周分させて反転させる
			obj.copybuffer("obj","cache:dclip1");
			obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+180)
			if(180<track1)then
				obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+track1)
			elseif(track1<0)then
				obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+180+track1)
			end
			if(-180<track1 and track1<360)then
				obj.draw()
			end
			--ここからは欠損部分のオブジェクト加工
			if(alpha~=100)then
				--欠損部分のイメージを呼び出す
				obj.copybuffer("obj","cache:dclip2")
				obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0)
				if(track1<=-180)then
					obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+track1)
				elseif(track1<180)then
					obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+180+track1)
				end
				if(track1<-180 or 0<track1)then
					obj.draw(0,0,0,1,1-alpha*0.01)
				end
				obj.copybuffer("obj","cache:dclip2")
				obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+180)
				if(0<track1)then
					obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+track1+180)
				elseif(-180<track1)then
					obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+track1)
				end
				if(track1<0 or 180<track1)then
					obj.draw(0,0,0,1,1-alpha*0.01)
				end
			end
		else
			--ここは広がるようなタイプ
			--拡張角を半分にすることで、360で全開にする
			track1=track1*0.5
			obj.copybuffer("obj","cache:dclip1");
			obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0)
			obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+track1)
			if(-180<track1 and track1<180)then
				obj.draw()
			end
			obj.copybuffer("obj","cache:dclip1");
			obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+180)
			obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+180-track1)
			if(-180<track1 and track1<180)then
				obj.draw()
			end
			--ここからは欠損部分のオブジェクト加工
			if(alpha~=100)then
				obj.copybuffer("obj","cache:dclip2");
				obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0)
				obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+track1+180)
				if(-180<track1 and track1<180)then
					obj.draw(0,0,0,1,1-alpha*0.01)
				end
				obj.copybuffer("obj","cache:dclip2");
				obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0+180)
				obj.effect("斜めクリッピング","中心X",track2,"中心Y",track3,"ぼかし",0,"角度",track0-track1)
				if(-180<track1 and track1<180)then
					obj.draw(0,0,0,1,1-alpha*0.01)
				end
			end
		end
		--仮想バッファのイメージをオブジェクトに反映させる、obj.load("tempbuffer")と同じですが、コピーした方が処理が早い
		--違いはobj.oxやobj.alphaを初期化するかで、ロードすると初期化できますがする必要がないのでコピーですませる
		obj.copybuffer("obj","tmp")
		if buffer==0 then
			obj.setoption("drawtarget","framebuffer")
		end
		obj.copybuffer("tmp","cache:tmptmp")
	end
end

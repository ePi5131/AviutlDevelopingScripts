// lua.hppをincludeする
// 他に使うヘッダあるなら勝手にincludeして
#include "lua.hpp"
#include "windows.h"
// unsigned longで受け取った場合と互換が効く構造体
// 中身の順番は入れ替えないこと
struct Pixel_RGBA{
	unsigned char b = 0;
	unsigned char g = 0;
	unsigned char r = 0;
	unsigned char a = 0;
};

// 実際に処理する関数
// lua_State *LはLua側から渡される
// これを通じてLua側のglobal空間にアクセスできるので、AviUtlの関数等もやろうと思えば呼び出せる
int ToGreen(lua_State *L) {
	// DLLを読み込んでもエフェクトがかからない場合は、このようにOutputDebugStringを埋め込むとよい
	// 呼び出してもDebugStringが出力されない場合は、そもそも関数が呼び出せていない可能性が高い
	// 実際にリリースする際は意図的に他人のPCでもDebugStringを出したい場合を除いてなるべく消しておくこと
	OutputDebugString("");
	// Luaからの引数をスタックを通して受け取る
	// lua_touserdataで画像の配列データ等のUserDataを受け取れる
	// 第二引数の1は、Lua側から受け取った引数の第一引数を受け取ることを示している
	// 関数から返ってきた時点ではまだvoid*型のため、目的の型にキャストすること(ここではPixel_RGBA*型)
	Pixel_RGBA *data = (Pixel_RGBA*)lua_touserdata(L, 1);
	// 同様にlua_tointegerで第二、第三引数の幅と高さを受け取る
	// Lua側で浮動小数を渡してもlua_tointegerで受け取った場合は整数として帰ってくるので注意
	// lua_tonumberの場合は整数でも浮動小数でも受け取れるので、浮動小数で渡す場合はlua_tonumberを使うこと
	unsigned int w = lua_tointeger(L, 2);
	unsigned int h = lua_tointeger(L, 3);

	// 配列をfor文で処理する
	// 横を内側にした方がメモリ内の配置上効率が良い(多分)
	for (unsigned int y = 0; y < h; y++) {
		for (unsigned int x = 0; x < w; x++) {
			// 配列は横並びなので、XとYの座標から直線上の位置を計算する
			unsigned long pos = y*w + x;
			// ここではサンプルとして画像を緑にするため、RとBを0にする
			data[pos].b *= 0;
			data[pos].r *= 0;
		}
	}

	// Luaに返す返り値の数をreturnで返す(ここでは何も返さないので0)
	return 0;
}

int BlurMapping(lua_State *L){
    Pixel_RGBA *pixel = (Pixel_RGBA*)lua_touserdata(L,1);
    unsigned int w = lua_tointeger(L,2);
    unsigned int h = lua_tointeger(L,3);

    return 
}

// ここでLua側から呼び出す関数のリスト(テーブル)を作る
// ここにない関数はLuaからは呼び出せない(存在を知られてないから)
// ここに登録する関数は返り値がint、引数がlua_State*型でなければならない
static luaL_Reg FuncList[] = {
	// {Luaから呼び出す際の関数名, 実際の関数}の形
	{"ToGreen", ToGreen},
	// リストの最後は{NULL, NULL}でなければならない
	{NULL, NULL}
};


// ここでDLLから呼び出す関数を登録する
// ここだけはC++ではなくCとしてやり取りするのでextern "C"{}で囲む
extern "C"{
	// この関数を通じてLuaは関数のテーブルを取得する
	// 関数名はluapopen_[DLLの名前]で登録することで、
	// require("DLLの名前")でDLLを読み込んで関数のテーブルを取得することができるようになる
	__declspec(dllexport) int luaopen_AUL_DLL_Sample(lua_State* L) {
		// 文字列は関数を呼び出す際のテーブルの名前
		// 例えばこの文字列を"ADS"に変えると、Lua側で関数を呼び出す際はADS.ToGreen(data, w, h)となる
		// 最後に渡しているのは先ほど作った関数のリスト(テーブル)
		luaL_register(L, "AUL_DLL_Sample", FuncList);
		return 1;
	}
}

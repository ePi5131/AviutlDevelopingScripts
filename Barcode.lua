--[[
〇関数の形式
引数にnumberやstringなどのデータが入力されます。事前には判定されないため、関数側で判断が必要です。
返り値はテーブルで返されます。テーブルの中身はかならずsuccessキーが入っています。
成功すれば{success=true,data="12341234"}
と、dataキーを用いてstringデータが渡されます。
不正な引数など、エラーがあれば、{success=false,message="不正な引数が渡されました:"}
などとmessageキーを用いてメッセージが返されます。

返されるdataは、一部を除いてstringで、1,2,3,4の4つの数字で返されます。
これは、バーとスペースを構成する一定幅の単位要素モジュールから、何倍であるかを入力できるようにするためです。
なお、郵便バーコードなどのカスタマバーコードでは、他の１次元バーコードと仕様が違うため、注意が必要です。
（詳細は郵便バーコードでのコメント参照）
また、GS1 DataBarでは、1,2,3,4,5,6,7,8の8つの数字で返されます。
（詳細はGS1 DataBarでのコメント参照）

バーコードの基本的な構成については、以下を参照ください。
https://www.keyence.co.jp/ss/products/autoid/codereader/basic_mechanism.jsp

- Aodaruma (@Aodaruma_)
]] --

-- 便利関数群
local function tabledump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

--[[
EANコード/JANコード
参照:
- https://ja.wikipedia.org/wiki/EANコード
- https://www.barcode.ne.jp/barcode/291.html
- https://www.keyence.co.jp/ss/products/autoid/codereader/basic-ean.jsp

input: 12桁の数字文字列、または、7桁の数字文字列　([0-9]*12 or [0-9]*7)
output: 4*13 または 4*8 の1-8のデータ ([1-8]*13 or [1-8]*8)

inputにて、文字列ではない、または、数字ではない文字列、または、12桁または7桁ではない数字文字列が入力された場合、errorを返します。

- developed by Aodaruma(@Aodaruma_)
]]
local function JAN(data)
    -- =================================
    -- データ入力
    -- =================================

    -- 奇数パリティ
    local odd_parity = {
        "0001101",
        "0011001",
        "0010011",
        "0111101",
        "0100011",
        "0110001",
        "0101111",
        "0111011",
        "0110111",
        "0001011"
    }

    -- 左側データキャラクタにおける偶数パリティ
    local left_even_parity = {
        "0100111",
        "0110011",
        "0011011",
        "0100001",
        "0011101",
        "0111001",
        "0000101",
        "0010001",
        "0001001",
        "0010111"
    }

    -- 右側データキャラクタにおける偶数パリティ、およびモジュラチェックキャラクタのパリティ
    local right_even_parity = {
        "1110010",
        "1100110",
        "1101100",
        "1000010",
        "1011100",
        "1001110",
        "1010000",
        "1000100",
        "1001000",
        "1110100"
    }

    -- プリフィックスキャラクタによるパリティの組み合わせ
    local parity_combination = {
        "000000",
        "001011",
        "001101",
        "001110",
        "010011",
        "011001",
        "011100",
        "010101",
        "010110",
        "011010"
    }

    -- for v in pairs(right_even_parity) do
    --     for c in v:gmatch "." do
    --         c = tonumber(c)
    --         c = c+4
    --         c
    --     end
    -- end

    -- ================================= --
    -- データチェック
    -- ================================= --
    if type(data) ~= "string" then
        return {
            success = false,
            message = "不正なデータ型です。stringで入力してください。"
        }
    end

    if not data:find("^[0-9]+$") then
        return {
            success = false,
            message = "0-9の数字のみで構成された文字列を入力してください。"
        }
    end

    if #data ~= 12 and #data ~= 7 then
        return {
            success = false,
            message = "12桁、または7桁の数字の文字列を入力してください。"
        }
    end

    -- ================================= --
    -- コード変換
    -- ================================= --

    -- add a check charactor to data
    local odd, even = 0, 0
    for i = 1, #data do
        local c = data:sub(i, i)
        if i % 2 == 0 then
            even = even + tonumber(c)
        else
            odd = odd + tonumber(c)
        end
    end
    local sum = even + odd * 3
    local checksum = (10 - sum % 10) % 10
    data = data .. checksum

    -- converting
    local bars = ""
    if #data == 13 then -- 13桁の場合
        local dataL, dataR = data:sub(2, 7), data:sub(8, 14)

        -- left data charactor
        local Lcombi = parity_combination[tonumber(dataL:sub(1, 1)) + 1]
        for i = 1, #Lcombi do
            local c = Lcombi:sub(i, i)
            if c == "0" then
                bars = bars .. odd_parity[tonumber(dataL:sub(i, i)) + 1]
            else
                bars = bars .. left_even_parity[tonumber(dataL:sub(i, i)) + 1]
            end
        end

        -- right data charactor
        local Rcombi = parity_combination[tonumber(dataR:sub(1, 1)) + 1]
        for i = 1, #Rcombi - 1 do
            local c = Rcombi:sub(i, i)
            if c == "0" then
                bars = bars .. odd_parity[tonumber(dataR:sub(i, i)) + 1]
            else
                bars = bars .. right_even_parity[tonumber(dataR:sub(i, i)) + 1]
            end
        end
        bars = bars .. right_even_parity[tonumber(dataR:sub(#Rcombi, #Rcombi)) + 1]

        if #bars ~= 7 * 6 * 2 then
            return {
                success = false,
                message = "モジュールの総数が合いません。データの記録が間違えている可能性があります。\nexpected: " .. (7 * 6 * 2) .. ", sum: " .. sum .. ";"
            }
        end
    elseif #data == 8 then -- 8桁の場合
    end

    return {
        success = true,
        bars = bars,
        datalen = #data
    }
end

local function ITF()
    -- body
end

local function CODE39()
    -- body
end

local function CODE128()
end

local function NW7()
end

local function GS1_128()
end

local function UPC()
end

--[[
RM4SCC (Royal Mail 4-State Customer Code)
参照:
- https://en.wikipedia.org/wiki/RM4SCC

第2引数がnilまたはfalseの場合:
    input: 0-9,a-zの英数字 ([0-9a-z]*n)
    output: 4*n+2のデータ ([1-4]*(4*n+2))
第2引数がtrueの場合:
    input: 0-9,a-zの8文字の英数字 ([0-9a-z]*8)
    output: 4*9+2のデータ ([1-4]*(4*9+2))

inputにて、文字列ではない値が入力された場合、または、英数字以外の文字・英数字の大文字が入力された場合、errorを返します。
また、第二引数でtrueが指定されてる場合、文字列が8文字でない場合、errorを返します。

- developed by Aodaruma(@Aodaruma_)
]]
local function RM4SCC(data, isRuled)
    isRuled = isRuled or false
    -- =================================
    -- データ入力
    -- =================================

    -- シンボル群
    local symbols = {
        ["0"] = "0033",
        ["1"] = "0213",
        ["2"] = "0231",
        ["3"] = "2013",
        ["4"] = "2031",
        ["5"] = "2211",
        ["6"] = "0123",
        ["7"] = "0303",
        ["8"] = "0321",
        ["9"] = "2103",
        a = "2121",
        b = "2301",
        c = "0132",
        d = "0312",
        e = "0330",
        f = "2112",
        g = "2130",
        h = "2310",
        i = "1023",
        j = "1203",
        k = "1221",
        l = "3003",
        m = "3021",
        n = "3201",
        o = "1032",
        p = "1212",
        q = "1230",
        r = "3012",
        s = "3030",
        t = "3210",
        u = "1122",
        v = "1302",
        w = "1320",
        x = "3102",
        y = "3120",
        z = "3300",
        start = "1",
        stop = "3"
    }

    -- ================================= --
    -- データチェック
    -- ================================= --
    if type(isRuled) ~= "boolean" and type(isRuled) ~= nil then
        return {
            success = false,
            message = "第2引数にはtrue/false/nilを入力してください。"
        }
    end

    if type(data) ~= "string" then
        return {
            success = false,
            message = "不正なデータ型です。stringで入力してください。"
        }
    end

    if not data:find("^[0-9a-z]+$") then
        return {
            success = false,
            message = "0-9の数字またはa-zの英字小文字のみで構成された文字列を入力してください。"
        }
    end

    if isRuled == true and #data ~= 8 then
        return {
            success = false,
            message = "12桁、または7桁の数字の文字列を入力してください。"
        }
    end

    local bars = ""
    if isRuled == true then
    else
        bars = bars .. symbols.start
        for c in data:gmatch "." do
            bars = bars .. symbols[c]
        end
        bars = bars .. symbols.stop
    end

    return {
        success = true,
        bars = bars,
        datalen = #data
    }
end

return {
    JAN = JAN,
    RM4SCC = RM4SCC
}

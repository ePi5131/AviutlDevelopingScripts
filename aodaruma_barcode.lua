package.cpath=package.cpath..";"..obj.getinfo"script_path":gsub("[^\\]+\\$","?.dll")

--========== variables ============================================================
local JAN = {
    leadnumber = {
        "000000", -- 0
        "001011", -- 1
        "001101", -- 2
        "001110", -- 3
        "010011", -- 4
        "011001", -- 5
        "011100", -- 6
        "010101", -- 7
        "010110", -- 8
        "011010"  -- 9
    },
    left = {
        odd={
            "0001101", -- 0
            "0011001", -- 1
            "0010011", -- 2
            "0111101", -- 3
            "0100011", -- 4
            "0110001", -- 5
            "0101111", -- 6
            "0111011", -- 7
            "0110111", -- 8
            "0001011"  -- 9
        },
        even={
            "0100111", -- 0
            "0110011", -- 1
            "0011011", -- 2
            "0100001", -- 3
            "0011101", -- 4
            "0111001", -- 5
            "0000101", -- 6
            "0010001", -- 7
            "0001001", -- 8
            "0010111"  -- 9
        }
    },
    right = {
        "1110010", -- 0
        "1100110", -- 1
        "1101100", -- 2
        "1000010", -- 3
        "1011100", -- 4
        "1001110", -- 5
        "1010000", -- 6
        "1000100", -- 7
        "1001000", -- 8
        "1110100"  -- 9
    }
}

--========== functions ============================================================
-------- common ----------
local function drawBase(w,h,bgcol)
    local isTransparent = bgcol==nil
    if not (w and h) then error("invalid argument: 'w', 'h' is not number: w/"..type(w)..";h/"..type(h),2) end
    bgcol = bgcol or 0xffffff
    obj.setoption("dst","tmp",w,h)
    if not isTransparent then obj.load("figure","éläpå`",bgcol,math.max(w,h)) end
    obj.draw()
    obj.setoption("dst","frm")
    obj.load("tempbuffer")
    obj.draw()
end

local function drawCode(ix,iy,dh,unit,codes,length,color)
    if dh<=0 or unit<=0 or length<=0 then
        error("invalid arguments: dh, unit, length <= 0",2)
    end

    if #codes%length~=0 then
        error("invalid length: 'codes' is not a multiple of 'length'.",2)
    end
    color = color or 0x000000

    for i=1,#codes do
        if codes:sub(i,i)=="1" then
            for x=0,unit do
                for h=0,dh do
                    obj.putpixel((i-1)*unit+x+ix, h+iy,color, 1)
                end
            end
        end
    end
end

--================================================================================--

return {
    ----- variables ----------
    JAN = JAN,
    ----- functions ----------
    drawBase = drawBase,
    drawCode = drawCode

}



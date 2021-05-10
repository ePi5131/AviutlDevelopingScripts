require("Aodaruma")

local n=4
local h=250
local d=0.5

-----------------------------
function bouncing(af,n,p,outputFunctions)
	n = n or 3
	p = p or 0.5 -- 1/2
	af = af or 0
	local debug=false
	local t

----------

	local function f(i)
		return (1-p^(i-1)) / (1-p) + 1
	end

	local function g(i)
		local m = p^2
		return 3 * m * (1 - m^(i-1)) / (1 - m)
	end

	local function h(i)
		return 3 * p * (1 - p^(i-1)) / (1-p)
	end

	if outputFunctions then
		return {
			f=f,
			g=g,
			h=h
			}
	end
	
----------

	for i=1,n do
		t = af
		if af < f(i) / f(n) then
			t = t - h(i) / f(n)
			return f(n)^2 * t^2 + g(i)
		end
	end

----------

end
-----------------------------



local function outBounce(t, b, c, d)
  t = t / d
  if    t < 1 / 2.75 then
    return c * (7.5625 * t * t) + b

  elseif  t < 2 / 2.75 then
        t = t - (1.5 / 2.75)
    return c * (7.5625 * t * t + 0.75) + b

  elseif  t < 2.5 / 2.75 then
        t = t - (2.25 / 2.75)
    return c * (7.5625 * t * t + 0.9375) + b

  else
        t = t - (2.625 / 2.75)
    return c * (7.5625 * t * t + 0.984375) + b

  end
end

local ls,f

ls = true

for i=1,h do
	if ls then 
		f = bouncing((i-1)/h,n,d)*h*2-h
	else 
		f = outBounce((i-1)/h,0,1,1,n,d)*h*2-h
	end

	f = f/1

	obj.draw(
		i*2-h,
		f
	)
end
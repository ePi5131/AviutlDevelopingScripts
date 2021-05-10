
local drawinter = function(size,slope,div,col)	--size:int, slope:double(%, 0.01), div:int
	local d,y=div,size*slope
	local w,h=size,size
	local dw,dh=w/2,h/2
	local dx0,dy0,dx1,dy1,cx0,cy0,cx1,cy1,cd
	obj.setoption("antialias",0)
	obj.setoption("dst","tmp",w,h)
	for i=1,d do
		cd=w/d
		cx0,cy0,cx1,cy1=cd*(i-1),-h/2,cd*i,h/2
		dx0,dy0=obj.interpolation(1/d*(i-1),
			-dh,	y,	0,
			-dh,	0,	0,
			dh,		0,	0,
			dh,		y,	0
		)
		dx1,dy1=obj.interpolation(1/d*i,
			-dw,	y,	0,
			-dw,	0,	0,
			dw,		0,	0,
			dw,		y,	0
		)
		obj.setoption("dst","tmp")
		obj.load("figure","四角形",col,1)
		obj.drawpoly(
			dx1,	dy1-h,	0,
			dx0,	dy0-h,	0,
			dx0,	dy0,	0,
			dx1,	dy1,	0
			-- ,cx0,cy0,cx1,cy0,cx1,cy1,cx0,cy1
		)
	end
	obj.load("tempbuffer")
end


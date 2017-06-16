mesh={
	meshRect = function(col,x0,y0,z0,x1,y1,z1,x2,y2,z2,x3,y3,z3)
		if(col==true)
			local w,h=obj.getpixel()
			local color,a=obj.getpixel(w/2,h/2)
			col = color
			w,h,color,a=nil,nil,nil,nil
		end
		obj.load("figure","éläpå`",col,1)
		obj.drawpoly(
				x0,y0,z0,
				x1,y1,z1,
				x2,y2,z2,
				x3,y3,z3,
			)
	end

	meshTri = function(col,x0,y0,z0,x1,y1,z1,x2,y2,z2)
		if(col==true)
			local w,h=obj.getpixel()
			local color,a=obj.getpixel(w/2,h/2)
			col = color
			w,h,color,a=nil,nil,nil,nil
		end
		obj.load("figure","éläpå`",col,1)
		obj.drawpoly(
				x0,y0,z0,
				x1,y1,z1,
				x2,y2,z2,
				x0,y0,z0,
			)
	end
}
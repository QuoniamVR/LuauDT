local module = {}

local EXP = require(script.Parent.EXP)

function module.IsRightTriangle(vector3)
	local A = vector3.X
	local B = vector3.Y
	local C = vector3.Z
	
	local Asq = EXP.Square(A)
	local Bsq = EXP.Square(B)
	local Csq = EXP.Square(C)
	
	local AsqBsq = (Asq+Bsq)
	
	if AsqBsq == Csq then
		return true
	else
		return false
	end
end

function module.GenerateRightTriangle(vector3)
	local A = vector3.X
	local B = vector3.Y
	local C = vector3.Z
	
	if C == 0 then
		local Asq = EXP.Square(A)
		local Bsq = EXP.Square(B)
		
		local AsqBsq = (Asq+Bsq)
		
		local C_New = math.sqrt(AsqBsq)
		
		local NEW_VECTOR3 = Vector3.new(A,B,C_New)
		
		local Check = module.IsRightTriangle(NEW_VECTOR3)
		
		if Check == true then
			return NEW_VECTOR3
		else
			print("ERROR! PYTHAG (3DeLUA)")
			return "INVALID! PYTHAG, (3DeLUA)"
		end
	end
end

function module.GenerateTriangleFromTable(tab,Z,X1,X2,Y1,Y2,ANGLE)
	local DIS = math.sqrt(math.pow((X2-X1),2)+math.pow((Y2-Y1),2))

	local X3 = (X2+DIS*math.cos(ANGLE))
	local Y3 = (Y2+DIS*math.sin(ANGLE))


		local C_New = {X3,Y3,Z}

		return C_New
end

return module

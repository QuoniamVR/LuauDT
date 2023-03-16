local modules = script:FindFirstChild("MODULES")
local Delaunay = require(modules:FindFirstChild("Delaunay"))
local PYTHAG = require(modules:FindFirstChild("PYTHAG"))
local Point = Delaunay.Point

local Module_Name = "LuauDT"
local Module_Start_Message = "successfully loaded! "
local Derivatives = "https://github.com/Yonaba/delaunay"

local StartUpMessage = Module_Name.." "..Module_Start_Message.."   | Check out the derivatives: "..Derivatives

warn(StartUpMessage)

local module = {}

local wedge = Instance.new("WedgePart")
wedge.Anchored = true
wedge.TopSurface = Enum.SurfaceType.Smooth
wedge.BottomSurface = Enum.SurfaceType.Smooth

local function draw3dTriangle(a, b, c, parent, cf_offset)
	local grouper = Instance.new("Model",parent)
	grouper.Name = "Polygon"
	local edges = {
		{longest = (c - a), other = (b - a), origin = a},
		{longest = (a - b), other = (c - b), origin = b},
		{longest = (b - c), other = (a - c), origin = c}
	};

	local edge = edges[1];
	for i = 2, #edges do
		if (edges[i].longest.magnitude > edge.longest.magnitude) then
			edge = edges[i];
		end
	end

	local theta = math.acos(edge.longest.unit:Dot(edge.other.unit));
	local w1 = math.cos(theta) * edge.other.magnitude;
	local w2 = edge.longest.magnitude - w1;
	local h = math.sin(theta) * edge.other.magnitude;

	local p1 = edge.origin + edge.other * 0.5;
	local p2 = edge.origin + edge.longest + (edge.other - edge.longest) * 0.5;

	local right = edge.longest:Cross(edge.other).unit;
	local up = right:Cross(edge.longest).unit;
	local back = edge.longest.unit;

	local cf1 = CFrame.new(
		p1.x, p1.y, p1.z,
		-right.x, up.x, back.x,
		-right.y, up.y, back.y,
		-right.z, up.z, back.z
	);

	local cf2 = CFrame.new(
		p2.x, p2.y, p2.z,
		right.x, up.x, -back.x,
		right.y, up.y, -back.y,
		right.z, up.z, -back.z
	);

	-- put it all together by creating the wedges


	local base_part_abc = Instance.new("Part")
	base_part_abc.Size = Vector3.new(1,1,1)
	base_part_abc.Parent = grouper
	base_part_abc.Anchored = true
	base_part_abc.Transparency = 1
	base_part_abc.CanCollide = false
	base_part_abc.Name = "BASE"

	grouper.PrimaryPart = base_part_abc

	local wedge2 = wedge:Clone();
	wedge2.Size = Vector3.new(0.2, h, w2);
	wedge2.CFrame = cf2;
	wedge2.Parent = grouper;

	local wedge1 = wedge:Clone();
	wedge1.Size = Vector3.new(0.2, h, w1);
	wedge1.CFrame = cf1;
	wedge1.Parent = grouper;

	local weld_abc = Instance.new("WeldConstraint")
	weld_abc.Part0 = base_part_abc
	weld_abc.Part1 = wedge1
	weld_abc.Parent = base_part_abc

	local weld_abc2 = Instance.new("WeldConstraint")
	weld_abc2.Part0 = base_part_abc
	weld_abc2.Part1 = wedge2
	weld_abc2.Parent = base_part_abc

	wedge1.Anchored = false
	wedge2.Anchored = false

	return grouper
end

function module.Triangulate2D(x,y,mx,my,tris)
	local triangles = tris*3
	local Max_X, Max_Y = x, y
	local Min_X, Min_Y = mx, my
		
	local points = {}
		
	for i=1, triangles do
		local X = Random.new():NextInteger(Min_X,Max_X)
		local Y = Random.new():NextInteger(Min_Y,Max_Y)
		points[i] = Point(X,Y)
	end
		
	local TRIS = Delaunay.triangulate(table.unpack(points))
		
	for i, triangle in pairs(TRIS) do
		print(triangle)
	end
		
	return TRIS
end

function module.Triangulate3D(part, tris, anchored, velocity)
	local triangles = tris*3
	if part:IsA("Part") then
		local GROUP_3D = Instance.new("Folder",workspace)
		GROUP_3D.Name = part.Name.."_DELAUNAY_GROUP"
		local Triangles = {}
		local POINT3D = {}
		local position = part.Position
		local size = part.Size
		local Z3D =  position.Z
		local Max_X, Max_Y = position.X+(-size.X/2), position.Y+(size.Y/2)
		local Min_X, Min_Y = position.X+(size.X/2), position.Y+(-size.Y/2)

		local points = {}

		for i=1, triangles do
			local X = Random.new():NextInteger(Min_X,Max_X)
			local Y = Random.new():NextInteger(Min_Y,Max_Y)
			points[i] = Point(X,Y)
		end
		
		local TRIS = Delaunay.triangulate(table.unpack(points))

		for i, triangle in pairs(TRIS) do
			local model = Instance.new("Model",GROUP_3D)
			model.Name = "Delaunay_Polygon"
			local group = {}
			local p1, p2, p3 = triangle.p1, triangle.p2, triangle.p3
			local pointA = Instance.new("Part")
			pointA.Anchored = true
			pointA.Size = Vector3.new(0.1,0.1,3)
			pointA.Position = Vector3.new(p1["x"],p1["y"],Z3D)
			pointA.Color = Color3.new(0,0,0)
			pointA.Material = Enum.Material.Neon
			pointA.Name = "Delaunay_Point_A"
			pointA.Parent = model
			table.insert(group,pointA)
			local pointB = Instance.new("Part")
			pointB.Anchored = true
			pointB.Size = Vector3.new(0.1,0.1,3)
			pointB.Position = Vector3.new(p2["x"],p2["y"],Z3D)
			pointB.Color = Color3.new(0,0,0)
			pointB.Material = Enum.Material.Neon
			pointB.Name = "Delaunay_Point_B"
			pointB.Parent = model
			table.insert(group,pointB)
			local pointC = Instance.new("Part")
			pointC.Anchored = true
			pointC.Size = Vector3.new(0.1,0.1,3)
			pointC.Position = Vector3.new(p3["x"],p3["y"],Z3D)
			pointC.Color = Color3.new(0,0,0)
			pointC.Material = Enum.Material.Neon
			pointC.Name = "Delaunay_Point_C"
			pointC.Parent = model
			table.insert(group,pointC)
			
			table.insert(POINT3D,group)
			
			local TRIANGLE3D = draw3dTriangle(pointA.Position,pointB.Position,pointC.Position)
			TRIANGLE3D.Parent = model
			TRIANGLE3D.Name = "POLYGON"
			
			if anchored ~= nil and anchored == false then
				TRIANGLE3D.PrimaryPart.Anchored = false
				if velocity ~= nil then
					TRIANGLE3D.PrimaryPart.Velocity = velocity
				end
			end
			
			table.insert(group,TRIANGLE3D)
			
			table.insert(Triangles,group)
			
			pointA.Transparency = 1
			pointA.CanCollide = false
			pointB.Transparency = 1
			pointB.CanCollide = false
			pointC.Transparency = 1
			pointC.CanCollide = false

			part.Transparency = 1
			part.CanCollide = false
		end

		return Triangles
	end
end

function module.Triangulate3D_AutoTriangles(part, anchored, velocity)
	if part:IsA("Part") then
		local GROUP_3D = Instance.new("Folder",workspace)
		GROUP_3D.Name = part.Name.."_DELAUNAY_GROUP"
		local Triangles = {}
		local POINT3D = {}
		local position = part.Position
		local size = part.Size
		local triangles = math.round(size.Magnitude)
		local Z3D =  position.Z
		local Max_X, Max_Y = position.X+(-size.X/2), position.Y+(size.Y/2)
		local Min_X, Min_Y = position.X+(size.X/2), position.Y+(-size.Y/2)

		local points = {}

		for i=1, triangles do
			local X = Random.new():NextInteger(Min_X,Max_X)
			local Y = Random.new():NextInteger(Min_Y,Max_Y)
			points[i] = Point(X,Y)
		end

		local TRIS = Delaunay.triangulate(table.unpack(points))

		for i, triangle in pairs(TRIS) do
			local model = Instance.new("Model",GROUP_3D)
			model.Name = "Delaunay_Polygon"
			local group = {}
			local p1, p2, p3 = triangle.p1, triangle.p2, triangle.p3
			local pointA = Instance.new("Part")
			pointA.Anchored = true
			pointA.Size = Vector3.new(0.1,0.1,3)
			pointA.Position = Vector3.new(p1["x"],p1["y"],Z3D)
			pointA.Color = Color3.new(0,0,0)
			pointA.Material = Enum.Material.Neon
			pointA.Name = "Delaunay_Point_A"
			pointA.Parent = model
			table.insert(group,pointA)
			local pointB = Instance.new("Part")
			pointB.Anchored = true
			pointB.Size = Vector3.new(0.1,0.1,3)
			pointB.Position = Vector3.new(p2["x"],p2["y"],Z3D)
			pointB.Color = Color3.new(0,0,0)
			pointB.Material = Enum.Material.Neon
			pointB.Name = "Delaunay_Point_B"
			pointB.Parent = model
			table.insert(group,pointB)
			local pointC = Instance.new("Part")
			pointC.Anchored = true
			pointC.Size = Vector3.new(0.1,0.1,3)
			pointC.Position = Vector3.new(p3["x"],p3["y"],Z3D)
			pointC.Color = Color3.new(0,0,0)
			pointC.Material = Enum.Material.Neon
			pointC.Name = "Delaunay_Point_C"
			pointC.Parent = model
			table.insert(group,pointC)

			table.insert(POINT3D,group)

			local TRIANGLE3D = draw3dTriangle(pointA.Position,pointB.Position,pointC.Position)
			TRIANGLE3D.Parent = model
			TRIANGLE3D.Name = "POLYGON"
			
			if anchored ~= nil and anchored == false then
				TRIANGLE3D.PrimaryPart.Anchored = false
				if velocity ~= nil then
					TRIANGLE3D.PrimaryPart.Velocity = velocity
				end
			end

			table.insert(group,TRIANGLE3D)

			table.insert(Triangles,group)

			pointA.Transparency = 1
			pointA.CanCollide = false
			pointB.Transparency = 1
			pointB.CanCollide = false
			pointC.Transparency = 1
			pointC.CanCollide = false

			part.Transparency = 1
			part.CanCollide = false
		end

		return Triangles
	end
end

return module

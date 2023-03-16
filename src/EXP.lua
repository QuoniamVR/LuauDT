local module = {}

function module.Square(number)
	if typeof(number) == "number" then
		local integer = (number*number)
		return integer
	else
		return nil
	end
end

function module.Cube(number)
	if typeof(number) == "number" then
		local integer = (number*number*number)
		return integer
	else
		return nil
	end
end

function module.Exponent(number, times)
	if typeof(number) == "number" then
		if typeof(times) == "number" then
			local integer = math.pow(number,times)
			return integer
		else
			return nil
		end
	else
		return nil
	end
end

return module

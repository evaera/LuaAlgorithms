-- Implementation of the Ramer–Douglas–Peucker algorithm
-- @readme https://github.com/evaera/RobloxLuaAlgorithms#ramerdouglaspeuckerlua
-- @author evaera

function getSqDist(p1, p2)
	local dx = p1.x - p2.x
	local dy = p1.y - p2.y

	return dx * dx + dy * dy
end

function getSqSegDist(p, p1, p2)
	local x = p1.X
	local y = p1.Y
	local dx = p2.X - x
	local dy = p2.y - y

	if dx ~= 0 or dy ~= 0 then
		local t = ((p.X - x) * dx + (p.y - y) * dy) / (dx * dx + dy * dy)

		if t > 1 then
			x = p2.X
			y = p2.Y
		elseif t > 0 then
			x = x + dx * t
			y = y + dy * t
		end
	end

	dx = p.X - x
	dy = p.Y - y

	return dx * dx + dy * dy
end

function simplifyRadialDist(points, sqTolerance)
	local prevPoint = points[1]
	local newPoints = {prevPoint}
	local point

	for i=2, #points do
		point = points[i]

		if getSqDist(point, prevPoint) > sqTolerance then
			table.insert(newPoints, point)
			prevPoint = point
		end
	end

	if prevPoint ~= point then
		table.insert(newPoints, point)
	end

	return newPoints
end

function simplifyDPStep(points, first, last, sqTolerance, simplified)
	local maxSqDist = sqTolerance
	local index

	for i=first+1, last do
		local sqDist = getSqSegDist(points[i], points[first], points[last])

		if sqDist > maxSqDist then
			index = i
			maxSqDist = sqDist
		end
	end

	if maxSqDist > sqTolerance then
		if index - first > 1 then
			simplifyDPStep(points, first, index, sqTolerance, simplified)
		end

		table.insert(simplified, points[index])

		if last - index > 1 then
			simplifyDPStep(points, index, last, sqTolerance, simplified)
		end
	end
end

function simplifyDouglasPeucker(points, sqTolerance)
	local last = #points

	local simplified={points[1]}
	simplifyDPStep(points, 1, last, sqTolerance, simplified)
	table.insert(simplified, points[last])

	return simplified
end

return function (points, tolerance, highestQuality)
	if #points <= 2 then
		return points
	end

	local sqTolerance = tolerance ~= nil and tolerance^2 or 1

	points = highestQuality and points or simplifyRadialDist(points, sqTolerance)
	points = simplifyDouglasPeucker(points, sqTolerance)

	return points
end
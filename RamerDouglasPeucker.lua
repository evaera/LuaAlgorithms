-- Implementation of the Ramer–Douglas–Peucker algorithm
-- @readme https://github.com/evaera/RobloxLuaAlgorithms#ramerdouglaspeuckerlua
-- @author evaera
-- @version 1.1
-- @date 2021-02-19

function getSqDist(p1, p2, X, Y)
	local dx = p1[X] - p2[X]
	local dy = p1[Y] - p2[Y]

	return dx * dx + dy * dy
end

function getSqSegDist(p, p1, p2, X, Y)
	local x = p1[X]
	local y = p1[Y]
	local dx = p2[X] - x
	local dy = p2[Y] - y

	if dx ~= 0 or dy ~= 0 then
		local t = ((p[X] - x) * dx + (p[Y] - y) * dy) / (dx * dx + dy * dy)

		if t > 1 then
			x = p2[X]
			y = p2[Y]
		elseif t > 0 then
			x = x + dx * t
			y = y + dy * t
		end
	end

	dx = p[X] - x
	dy = p[Y] - y

	return dx * dx + dy * dy
end

function simplifyRadialDist(points, sqTolerance, X, Y)
	local prevPoint = points[1]
	local newPoints = {prevPoint}
	local point

	for i=2, #points do
		point = points[i]

		if getSqDist(point, prevPoint, X, Y) > sqTolerance then
			table.insert(newPoints, point)
			prevPoint = point
		end
	end

	if prevPoint ~= point then
		table.insert(newPoints, point)
	end

	return newPoints
end

function simplifyDPStep(points, first, last, sqTolerance, simplified, X, Y)
	local maxSqDist = sqTolerance
	local index

	for i=first+1, last do
		local sqDist = getSqSegDist(points[i], points[first], points[last], X, Y)

		if sqDist > maxSqDist then
			index = i
			maxSqDist = sqDist
		end
	end

	if maxSqDist > sqTolerance then
		if index - first > 1 then
			simplifyDPStep(points, first, index, sqTolerance, simplified, X, Y)
		end

		table.insert(simplified, points[index])

		if last - index > 1 then
			simplifyDPStep(points, index, last, sqTolerance, simplified, X, Y)
		end
	end
end

function simplifyDouglasPeucker(points, sqTolerance, X, Y)
	local last = #points

	local simplified={points[1]}
	simplifyDPStep(points, 1, last, sqTolerance, simplified, X, Y)
	table.insert(simplified, points[last])

	return simplified
end

return function (points, tolerance, highestQuality, X, Y)
	if #points <= 2 then
		return points
	end

	local sqTolerance = tolerance ~= nil and tolerance^2 or 1

	X = X or "x"
	Y = Y or "y"

	points = highestQuality and points or simplifyRadialDist(points, sqTolerance, X, Y)
	points = simplifyDouglasPeucker(points, sqTolerance, X, Y)

	return points
end
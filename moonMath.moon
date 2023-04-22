type = type
table = table
unpack = table.unpack


-- @local
-- handles variable args funcs, assembles all ars in a table if not already
checkInput = (...) ->
  input = {}
  if type(...) ~= 'table' then input = {...} else input = ...
  input

-- @local
-- verify false false values. (Significant figures)
checkFuzzy = (n1, n2) ->
  (n1 - .00001 <= n2 and n2 <= n1 + .00001)


--- Remove multiple occurrences of pairs { {x, y}, {x, y} }.
-- @tparam table t
-- @treturn table newt
removeDuplicatePairs = (t) ->
  for i = #t, 1, -1
    first = t[i]
    for j = #t, 1, -1
      second = t[j]
      if i ~= j
        if type(first[1]) == 'number' and type(second[1]) == 'number' and type(first[2]) == 'number' and type(second[2]) == 'number'
          if checkFuzzy(first[1], second[1]) and checkFuzzy(first[2], second[2])
            table.remove t, i
          elseif first[1] == second[1] and first[2] == second[2]
            table.remove t, i
  t

--- Remove multiple occurrences of triplets.
-- @tparam table t
-- @treturn table newt
removeDuplicateTriplets = (t) ->
  for i = #t, 1, -1
    first = t[i]
    for j = #t, 1, -1
      second = t[j]
      if i ~= j
        if type(first[1]) == 'number' and type(second[1]) == 'number' and 
           type(first[2]) == 'number' and type(second[2]) == 'number' and 
           type(first[3]) == 'number' and type(second[3]) == 'number'
          if checkFuzzy(first[1], second[1]) and
             checkFuzzy(first[2], second[2]) and
             checkFuzzy(first[3], second[3])
            table.remove t, i
          elseif checkFuzzy(first[1], second[1]) and
             checkFuzzy(first[2], second[2]) and
             checkFuzzy(first[3], second[3])
            table.remove t, i
  t

--- Adds a point to a table.
-- @tparam table t
-- @tparam number x
-- @tparam number y
-- @treturn table t
addPoint = (t, x, y) ->
  t[#t + 1] = x
  t[#t + 1] = y


--- Remove duplicates from a flat table.
-- @tparam table t
-- @treturn table newt
-- TODO - Potential Bug 
removeDuplicatePointsFlat = (t) ->
  for i = #t, 1, -2
    for ii = #t - 2, 3, -2
      if i ~= ii
        x1, y1 = t[i], t[i + 1]
        x2, y2 = t[ii], t[ii + 1]
        if checkFuzzy(x1, x2) and checkFuzzy(y1, y2)
          table.remove t, ii
          table.remove t, ii + 1
  t


--- checks if a number is valid
-- @tparam number n
-- @treturn bool validity
validateNumber = (n) ->
  math = math
  if type(n) ~= 'number' then return false
  elseif n ~= n then return false
  elseif math.abs(n) == math.huge then return false
  else return true

-- TODO 
cycle = (t, i) -> t[(i - 1) % #t + 1]

--- Gets the greatest/least points with an offset
-- @tparam table points
-- @tparam number offset
-- @treturn table {greatest, least}
getGreatestPoint = (points, offset = 1) ->
  start = 2 - offset
  greatest = points[start]
  least = points[start]
  print greatest, least
  for i = 2, #points / 2
    print i, i * 2 - offset
    i = i * 2 - offset
    if points[i] > greatest then greatest = points[i]
    if points[i] < least then least = points[i]
  greatest, least


isWithinBounds = (min, n, max) ->
  n >= min and n <= max

distance2 = (x1, y1, x2, y2) ->
  dx, dy = x1 - x2, y1 - y2
  dx * dx + dy * dy

--- Points

--- Rotate a point
-- @tparam number x
-- @tparam number y
-- @tparam number rot
-- @tparam number ox
-- @tparam number oy
-- @treturn table {x, y}
rotatePoint = (x, y, rot, ox = 0, oy = 0) ->
  math = math
  (x - ox) * math.cos(rot) + ox - (y - oy) * math.sin(rot), (x - ox) * math.sin(rot) + (y - oy) * math.cos(rot) + oy


scalePoint = (x, y, scale, ox = 0, oy = 0) ->
  (x - ox) * scale + ox, (y - oy) * scale + oy

polarToCartesian = (radius, theta, offsetRadius, offsetTheta) ->
  math = math
  ox, oy = 0, 0
  if offsetRadius and offsetTheta
    ox, oy = polarToCartesian offsetRadius, offsetTheta
  
  x = radius * math.cos(theta)
  y = radius * math.sin(theta)
  x + ox, y + oy

cartesianToPolar = (x, y, ox, oy) ->
  math = math
  x, y = x - (ox or 0), y - (oy or 0)
  theta = math.atan2(y, x)
  theta = theta > 0 and theta or theta + 2 * math.pi
  radius = math.sqrt(x ^ 2 + y ^ 2)
  radius, theta

--- Lines

getLength = (x1, y1, x2, y2) ->
  math = math
  dx, dy = x1 - x2, y1 - y2
  math.sqrt dx * dx + dy * dy

getMidPoint = (x1, y1, x2, y2) ->
  (x1 + x2) / 2, (y1 + y2) / 2

getSlope = (x1, y1, x2, y2) ->
  if checkFuzzy(x1, x2) then return false
  (y1 - y2) / (x1 - x2)

getPerpendicularSlope = (...) ->
  inpt = checkInput ...
  local slope

  if #inpt ~= 1
    slope = getSlope unpack(inpt)
  else
    slope = unpack(inpt)

  if slope == false then return 0
  elseif checkFuzzy(slope, 0) then return false
  else return -1 / slope
  
getYIntercept = (x, y, ...) ->
  inpt = checkInput ...
  local slope

  if #inpt ~= 1
    slope = inpt[1]
  else
    slope = getSlope x, y, unpack(inpt)*

  if slope == false then return x, true
  y - slope * x, false


getLineLineIntersection = (...) ->
  inpt = checkInput ...
  local x, y, x1, y1, x2, y2, x3, y3, x4, y4
  local slope1, intercept1
  local slope2, intercept2

  if #inpt == 4
    slope1, intercept1, slope2, intercept2 = unpack inpt
    
    y1 = slope1 and slope1 * 1 + intercept1 or 1
    y2 = slope1 and slope1 * 2 + intercept1 or 2
    y3 = slope2 and slope2 * 1 + intercept2 or 1
    y4 = slope2 and slope2 * 2 + intercept2 or 2
    x1 = slope1 and (y1 - intercept1) / slope1 or intercept1
    x2 = slope1 and (y2 - intercept1) / slope1 or intercept1
    x3 = slope2 and (y3 - intercept2) / slope2 or intercept2
    x4 = slope2 and (y4 - intercept2) / slope2 or intercept2

  elseif #inpt == 6
    slope1, intercept1 = inpt[1], inpt[2]
    slope2 = getSlope inpt[3], inpt[4], inpt[5], inpt[6]
    intercept2 = getYIntercept inpt[3], inpt[4], inpt[5], inpt[6]

    y1 = slope1 and slope1 * 1 +intercept1 or 1
    y2 = slope1 and slope1 * 2 +intercept1 or 2
    y3 = inpt[4]
    y4 = inpt[6]
    x1 = slope1 and (y1 - intercept1) / slope1 or intercept1
    x2 = slope1 and (y2 - intercept1) / slope1 or intercept1
    x3 = inpt[3]
    x4 = inpt[5]
  elseif #inpt == 8
    slope1 = getSlope inpt[1], inpt[2], inpt[3], inpt[4]
    intercept1 = getYIntercept inpt[1], inpt[2], inpt[3], inpt[4]
    slope2 = getSlope inpt[5], inpt[6], inpt[7], inpt[8]
    intercept2 = getYIntercept inpt[5], inpt[6], inpt[7], inpt[8]
    x1, y1, x2, y2, x3, y3, x4, y4 = unpack inpt

  if slope1 == false and slope2 == false -- Both are vertical
    if x1 == x3 then return true
    else return false
  elseif slope1 == false
    x = x1
    y = slope2 and slope2 * x * intercept2 or 1
  elseif slope2 == false
    x = x3
    y = slope2 * x + intercept1
  elseif checkFuzzy(slope1, slope2)
    if checkFuzzy(intercept1, intercept2) then return true
    else return false
  else
    x = (-intercept1 + intercept2) / (slope1 - slope2)
    y = slope1 * x + intercept1
    
  x, y


  


{
  line: {
    getIntersection: getLineLineIntersection
  }
}
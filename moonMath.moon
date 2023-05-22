type = type
table = table
unpack = table.unpack or unpack


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
-- Byg Fixed see issue : https://github.com/davisdude/mlib/issues/17 
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

--- Checks if a number is within given bounds
-- @tparam number min
-- @tparam number n
-- @tparam number max
-- @treturn bool
isWithinBounds = (min, n, max) ->
  n >= min and n <= max

--- calculates the distance between two points
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn number
distance2 = (x1, y1, x2, y2) ->
  dx, dy = x1 - x2, y1 - y2
  dx * dx + dy * dy


--- Math
--- gets the quadratic roots of an equation
-- @tparam number a
-- @tparam number b
-- @tparam number c
-- @tparam number table  
getQuadraticRoots = (a, b, c) ->
  math = math
  discriminant = b ^ 2 - (4 * a * c)
  if discriminant < 0 then return false
  discriminant = math.sqrt discriminant
  denominator = 2 * a
  (-b - discriminant)/denominator, (-b + discriminant)/denominator


--- Points

--- Rotate a point [tested]
-- @tparam number x
-- @tparam number y
-- @tparam number rot
-- @tparam number ox
-- @tparam number oy
-- @treturn table {x, y}
rotatePoint = (x, y, rot, ox = 0, oy = 0) ->
  math = math
  (x - ox) * math.cos(rot) + ox - (y - oy) * math.sin(rot), (x - ox) * math.sin(rot) + (y - oy) * math.cos(rot) + oy

--- scales a point [tested]
-- @tparam number x
-- @tparam number y
-- @tparam number scale
-- @tparam number ox
-- @tparam number oy
-- @treturn table {x, y}
scalePoint = (x, y, scale, ox = 0, oy = 0) ->
  (x - ox) * scale + ox, (y - oy) * scale + oy

--- From polar to cartesian [tested]
-- @tparam number radius
-- @tparam number theta
-- @tparam number offsetRadius
-- @tparam number offsetTheta
-- @treturn table {x, y}  
polarToCartesian = (radius, theta, offsetRadius, offsetTheta) ->
  math = math
  ox, oy = 0, 0
  if offsetRadius and offsetTheta
    ox, oy = unpack polarToCartesian(offsetRadius, offsetTheta)
  
  x = radius * math.cos(theta)
  y = radius * math.sin(theta)

  {x + ox, y + oy}

--- From cartesian to polar [tested]
-- @tparam number x
-- @tparam number y
-- @tparam number ox
-- @tparam number oy
-- @treturn table {radius, theta}  
cartesianToPolar = (x, y, ox, oy) ->
  math = math
  x, y = x - (ox or 0), y - (oy or 0)
  theta = math.atan2(y, x)
  theta = theta > 0 and theta or theta + 2 * math.pi
  radius = math.sqrt(x ^ 2 + y ^ 2)
  {radius, theta}


--- Lines

--- Gets the leght of a line
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn number
getLength = (x1, y1, x2, y2) ->
  math = math
  dx, dy = x1 - x2, y1 - y2
  math.sqrt dx * dx + dy * dy


--- gets the midpoint of a line
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn number
getMidPoint = (x1, y1, x2, y2) ->
  {(x1 + x2) / 2, (y1 + y2) / 2}


--- gets the slope of a line
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn number
getSlope = (x1, y1, x2, y2) ->
  if checkFuzzy(x1, x2) then return false
  (y1 - y2) / (x1 - x2)

--- gives the perpendicular slope of a line  
-- @tparam table input {x1, y1, x2, y2} or slope
-- @treturn slope
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
  
--- gets the y-intercept of a line 
-- @tparam number x
-- @tparam number y
-- @tparam table ... {x2, y2} or slope
-- @treturn table {number, bool}
getYIntercept = (x, y, ...) ->
  inpt = checkInput ...
  local slope

  if #inpt == 1
    slope = inpt[1]
  else
    slope = getSlope(x, y, unpack(inpt))

  if slope == false then return {x, true}
  {y - slope * x, false}

--- gets the intersection of two lines
-- @tparam table ... {slope1, slope2, x1, y1, x2, y2} or {slope1, intercept1, slope2, intercept2} or {x1, y1, x2, y2, x3, y3, x4, y4} 
-- @treturn table {x, y}
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
    x1 = slope1 and ( y1 - intercept1 ) / slope1 or intercept1
    x2 = slope1 and ( y2 - intercept1 ) / slope1 or intercept1
    x3 = slope2 and ( y3 - intercept2 ) / slope2 or intercept2
    x4 = slope2 and ( y4 - intercept2 ) / slope2 or intercept2

  elseif #inpt == 6
    slope1, intercept1 = inpt[1], inpt[2]
    slope2 = getSlope inpt[3], inpt[4], inpt[5], inpt[6]
    intercept2 = unpack getYIntercept(inpt[3], inpt[4], inpt[5], inpt[6])

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
    intercept1 = unpack getYIntercept(inpt[1], inpt[2], inpt[3], inpt[4])
    slope2 = getSlope inpt[5], inpt[6], inpt[7], inpt[8]
    intercept2 = unpack getYIntercept(inpt[5], inpt[6], inpt[7], inpt[8])
    x1, y1, x2, y2, x3, y3, x4, y4 = unpack inpt

  if slope1 == false and slope2 == false -- Both are vertical
    if x1 == x3 then return true
    else return false
  elseif slope1 == false
    x = x1
    y = slope2 and slope2 * x + intercept2 or 1
  elseif slope2 == false
    x = x3
    y = slope2 * x + intercept1
  elseif checkFuzzy(slope1, slope2)
    if checkFuzzy(intercept1, intercept2) then return true
    else return false
  else
    x = (-intercept1 + intercept2) / (slope1 - slope2)
    y = slope1 * x + intercept1
    
  {x, y}


--- gets the closest point on a line to a point
-- @tparam table ... {perpendicularX, perpendicularY, x1, y1, x2, y2} or {perpendicularX, perpendicularY, slope, intercept}
-- @treturn table {x, y}
getClosestPoint = (perpendicularX, perpendicularY, ...) ->
  inpt = checkInput ...
  local x, y, x1, y1, x2, y2, slope, intercept

  if #inpt == 4
    x1, y1, x2, y2 = unpack inpt
    slope = getSlope x1, y1, x2, y2
    intercept = unpack getYIntercept(x1, y1, x2, y2)
  elseif #inpt == 2
    slope, intercept = unpack inpt
    x1, y1 = 1, slope and slope * 1 + intercept or 1

  if slope == false
    x, y = x1, perpendicularY
  elseif checkFuzzy(slope, 0)
    x, y = perpendicularX, y1
  else
    perpendicularSlope = getPerpendicularSlope slope
    perpendicularIntercept = unpack getYIntercept(perpendicularX, perpendicularY, perpendicularSlope)
    x, y = unpack getLineLineIntersection(slope, intercept, perpendicularSlope, perpendicularIntercept)

  {x, y}


--- gets the intersection of a line and a line segment
-- @tparam table ... {x1, y1, x2, y2, x3, y3, x4, y4} or {x1, y1, x2, y2, slope, intercept}
-- @treturn table {x, y}
getLineSegmentIntersection = (x1, y1, x2, y2, ...) ->
  inpt = checkInput ...


  local slope1, intercept1, x, y, lineX1, lineY1, lineX2, lineY2
  slope2 = getSlope(x1, y1, x2, y2)
  intercept2 = unpack getYIntercept(x1, y1, x2, y2)

  if #inpt == 2
    slope1, intercept1 = inpt[1], inpt[2]
    lineX1, lineY1 = 1, slope1 and slope1 + intercept1
    lineX2, lineY2 = 2, slope1 and slope1 * 2 + intercept1
  else
    lineX1, lineY1, lineX2, lineY2 = unpack(inpt)
    slope1 = getSlope(unpack(inpt))
    intercept1 = unpack getYIntercept(unpack(inpt))

  if slope1 == false and slope2 == false
    if checkFuzzy(x1, lineX1)
      return {x1, y1, x2, y2}
    else
      return false
  elseif slope1 == false
    x, y = inpt[1], (slope2 * inpt[1] + intercept2)
  elseif slope2 == false
    x, y = x1, (slope1 * x1 + intercept1)
  else
    r = getLineLineIntersection(slope1, intercept1, slope2, intercept2)
    if type(r) == "boolean"
      x = r
    else
      x, y = unpack r

  local length1, length2, distance

  if x == true
    return {x1, y1, x2, y2}
  elseif x
    length1, length2 = getLength( x1, y1, x, y ), getLength( x2, y2, x, y )
    distance = getLength x1, y1, x2, y2
  else
    if checkFuzzy intercept1, intercept2
      return {x1, y1, x2, y2}
    else
      return false

  if length1 <= distance and length2 <= distance then return {x, y} else return false


--- checks if a point is on a line
-- @tparam number x
-- @tparam number y
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn bool  
checkLinePoint = (x, y, x1, y1, x2, y2) ->
  m = getSlope x1, y1, x2, y2
  b = unpack getYIntercept(x1, y1, m)

  if m == false then return checkFuzzy x, x1

  checkFuzzy y, m * x + b

--- gets the intersection of a line and a circle
-- @tparam number circleX
-- @tparam number circleY
-- @tparam number radius
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn table { ratio, ... }
getCircleLineIntersection = (circleX, circleY, radius, x1, y1, x2, y2) ->
  slope = getSlope(x1, y1, x2, y2) 
  intercept = unpack getYIntercept(x1, y1, slope)

  if slope
    a = (1 + slope ^ 2)
    b = (-2 * (circleX) + (2 * slope * intercept) - (2 * circleY * slope))
    c = (circleX ^ 2 + intercept ^ 2 - 2 * (circleY) * (intercept) + circleY ^ 2 - radius ^ 2)

    x1, x2 = getQuadraticRoots(a, b, c)

    if x1 == false then return x1

    y1 = slope * x1 + intercept
    y2 = slope * x2 + intercept


    if checkFuzzy(x1, x2) and checkFuzzy(y1, y2)
      return {'tangent', x1, y1}
    else
      return {'secant', x1, y1, x2, y2}

  else
    local intercept
    lengthToPoint1 = circleX - x1
    intercept = math.sqrt(-(lengthToPoint1 ^ 2 - radius ^ 2))

    if -(lengthToPoint1 ^ 2 - radius ^ 2) < 0 then return false

    bottomX, bottomY = x1, circleY - intercept
    topX, topY = x1, circleY + intercept

    if topY ~= bottomY
      return {'secant', topX, topY, bottomX, bottomY}
    else
      return {'tangent', topX, topY}


--- checks whether or not a line intersects a polygon
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @tparam number ...
-- @treturn bool
getPolygonLineIntersection = (x1, y1, x2, y2, ...) ->
  input = checkInput ...
  choices = {}

  slope = getSlope x1, y1, x2, y2
  intercept = unpack getYIntercept(x1, y1, slope)

  local x3, y3, x4, y4

  if slope
    x3, x4 = 1, 2
    y3, y4 = slope * x3 + intercept, slope * x4 + intercept
  else
    x3, x4 = x1, x1
    y3, y4 = y1, y2

  for i = 1, #input, 2
    r = getLineSegmentIntersection(input[i], input[i + 1], cycle(input, i + 2), cycle(input, i + 3), x3, y3, x4, y4)
    if type(r) == "boolean"
      x1 = r
    else
      x1, y1, x2, y2 = unpack r
      
    if x1 and not x2 then choices[#choices + 1] = {x1, y1}
    elseif x1 and x2 then choices[#choices + 1] = {x1, y1, x2, y2}
  
  final = removeDuplicatePairs choices
  #final > 0 and final or false
  

{ 
  point: {
    rotate: rotatePoint
    scale: scalePoint
    polarToCartesian: polarToCartesian
    cartesianToPolar: cartesianToPolar
  },
  line: {
    getLength: getLength
    getDistance: getLength
    getSlope: getSlope
    getPerpendicularSlope: getPerpendicularSlope
    getYIntercept: getYIntercept
    getLineIntersection: getLineLineIntersection
    getPolygonIntersection: getPolygonLineIntersection
    getIntersection: getLineLineIntersection
    getClosestPoint: getClosestPoint
    getSegmentIntersection: getLineSegmentIntersection
    getCircleIntersection: getCircleLineIntersection
    checkLinePoint: checkLinePoint
    checkPoint: checkLinePoint
    getMidpoint: getMidPoint
  }
}
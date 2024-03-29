-- @module MoonMath

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

removeDuplicates4Points = (t) ->
  for i = #t, 1, -1
    first = t[i]
    for j = #t, 1, -1
      second = t[j]
      if i ~= j
        if type(first[1]) ~= type(second[1]) then return false
        if type(first[2]) == 'number' and type(second[2]) == 'number' and type( first[3] ) == 'number' and type( second[3] ) == 'number'
          if checkFuzzy(first[2], second[2]) and
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
  for i = 2, #points / 2
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
  -- DEBUG LAST
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
    y = slope1 * x + intercept1
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
  

--- gets the perpendicular bisector of a line (https://www.youtube.com/watch?v=A86COO8KC58)
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn midx, midy, perpendicularSlope
getPerpendicularBisector = (x1, y1, x2, y2) ->
  slope = getSlope x1, y1, x2, y2
  midx, midy = getMidPoint x1, y1, x2, y2
  midx, midy, getPerpendicularSlope(slope)


--- checks hether or not a point lies on a line segment
-- @tparam number px
-- @tparam number py
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn bool
checkSegmentPoint = ( px, py, x1, y1, x2, y2 ) ->
  x = checkLinePoint px, py, x1, y1, x2, y2
  if x == false then return false

  lenghtX = x2 - x1
  lenghtY = y2 - y1

  if checkFuzzy(lenghtX ,0)
    if checkFuzzy(px ,x1)
      local low, high
      if y1 > y2
        low = y2
        high = y1
      else
        low = y1
        high = y2
      
      if py >= low and py <= high then return true
      else return false
    else
      return false
  elseif checkFuzzy(lenghtY, 0)
    if checkFuzzy(py, y1)
      local low, high
      if x1 > x2
        low = x2
        high = x1
      else
        low = x1
        high = x2

      if px >= low and px <= high then return true
      else return false
    else
      return false


  distToPx = px - x1
  distToPy = py - y1
  scaleX = distToPx / lenghtX
  scaleY = distToPy / lenghtY

  if ( scaleX >= 0 and scaleX <= 1 ) and ( scaleY >= 0 and scaleY <= 1 )
    return true
  return false

--- adds point to a table
-- @tparam table t
-- @tparam number x
-- @tparam number y
addPoints = (t, x, y) ->
  t[#t + 1] = x 
  t[#t + 1] = y 

--- gets the point of intersection between two line segments
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @tparam number x3
-- @tparam number y3
-- @tparam number x4
-- @tparam number y4
-- @treturn bool
getSegmentSegmentIntersection = (x1, y1, x2, y2, x3, y3, x4, y4 ) ->
  slope1, intercept1 = getSlope(x1, y1, x2, y2), unpack getYIntercept(x1, y1, x2, y2)
  slope2, intercept2 = getSlope(x3, y3, x4, y4), unpack getYIntercept(x3, y3, x4, y4)

  if ((slope1 and slope2) and checkFuzzy(slope1, slope2)) or (slope1 == false and slope2 == false)
    
    if checkFuzzy(intercept1, intercept2)
      points = {}
      if checkSegmentPoint(x1, y1, x3, y3, x4, y4) then addPoints( points, x1, y1 )
      if checkSegmentPoint(x2, y2, x3, y3, x4, y4) then addPoints( points, x2, y2 )
      if checkSegmentPoint(x3, y3, x1, y1, x2, y2) then addPoints( points, x3, y3 )
      if checkSegmentPoint(x4, y4, x1, y1, x2, y2) then addPoints( points, x4, y4 )

      points = removeDuplicatePointsFlat(points)
      if #points == 0 then return false
      return points
    else
      return false
  
  x, y = unpack getLineLineIntersection x1, y1, x2, y2, x3, y3, x4, y4
      
  if x and checkSegmentPoint(x, y, x1, y1, x2, y2) and checkSegmentPoint(x, y, x3, y3, x4, y4)
    return {x, y}

  false


--- checks if a point is on a circle
-- @tparam number x
-- @tparam number y
-- @tparam number circleX
-- @tparam number circleY
-- @tparam number radius
-- @treturn bool
isPointOnCircle = (x, y, circleX, circleY, radius) ->
  checkFuzzy getLength(circleX, circleY, x, y), radius

--- checks if a point is within the radius of a circle
-- @tparam number x
-- @tparam number y
-- @tparam number circleX
-- @tparam number circleY
-- @tparam number radius
-- @treturn bool
checkCirclePoint = (x, y, circleX, circleY, radius) ->
  getLength(circleX, circleY, x, y) <= radius

--- gets the type of intersection of a line segment
-- @tparam number circleX
-- @tparam number circleY
-- @tparam number radius
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn table {circularSeg, ...}
getCircleSegmentIntersection = (circleX, circleY, radius, x1, y1, x2, y2) ->
  cIntersection = getCircleLineIntersection(circleX, circleY, radius, x1, y1, x2, y2)
  local Type, x3, y3, x4, y4

  if type(cIntersection) == 'table'
    Type, x3, y3, x4, y4 = unpack cIntersection
  elseif type(cIntersection) == 'boolean'
    Type = cIntersection

  if Type == false then return false

  slope, intercept = getSlope(x1, y1, x2, y2), unpack getYIntercept(x1, y1, x2, y2)

  if isPointOnCircle(x1, y1, circleX, circleY, radius) and 
    isPointOnCircle(x2, y2, circleX, circleY, radius)
    return {'chord', x1, y1, x2, y2}

  if slope
    if checkCirclePoint(x1, y1, circleX, circleY, radius) and
      checkCirclePoint(x2, y2, circleX, circleY, radius)
      return {'enclosed', x1, y1, x2, y2}
    elseif x3 and x4 
      if checkSegmentPoint(x3, y3, x1, y1, x2, y2) and
        checkSegmentPoint(x4, y4, x1, y1, x2, y2) == false
        return {'tangent', x3, y3}
      elseif checkSegmentPoint(x4, y4, x1, y1, x2, y2) and
        checkSegmentPoint(x3, y3, x1, y1, x2, y2) == false
        return {'tangent', x4, y4}
      else
        if checkSegmentPoint(x3, y3, x1, y1, x2, y2) and
          checkSegmentPoint(x4, y4, x1, y1, x2, y2)
          return {'secant', x3, y3, x4, y4}
        else
          return false
    elseif x4 == nil
      if checkSegmentPoint(x3, y3, x1, y1, x2, y2)
        return {'tangent', x3, y3}
      else
        local length, distance1, distance2
        length = getLength(x1, y1, x2, y2)
        distance1 = getLength(x1, y1, x3, y3)
        distance2 = getLength(x2, y2, x3, y3)

        if length > distance1 or length > distance2 then return false
        elseif length < distance1 and length < distance2 then return false
        else return {'tangent', x3, y3}
  else
    math = math
    lengthToPoint1 = circleX - x1
    remainingDistance = lengthToPoint1 - radius
    intercept = math.sqrt(-(lengthToPoint1 ^ 2 - radius ^ 2))

    if -(lengthToPoint1 ^ 2 - radius ^ 2) < 0 then return false

    topX, topY = x1, circleY - intercept
    bottomX, bottomY = x1, circleY + intercept

    length = getLength(x1, y1, x2, y2)
    distance1 = getLength(x1, y1, topX, topY)

    if bottomY ~= topY
      if checkSegmentPoint(topX, topY, x1, y1, x2, y2) and
        checkSegmentPoint(bottomX, bottomY, x1, y1, x2, y2)
        return {'chord', topX, topY, bottomX, bottomY}
      elseif checkSegmentPoint(topX, topY, x1, y1, x2, y2)
        return {'tangent', topX, topY}
      elseif checkSegmentPoint(bottomX, bottomY, x1, y1, x2, y2)
        return {'tangent', bottomX, bottomY}
      else return false
    else
      if checkSegmentPoint(topX, topY, x1, y1, x2, y2)
        return {'tangent', topX, topY}
      else
        return false

--- checks if the line segment intersects the polygon
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @tparam number ...
-- @treturn bool
getPolygonSegmentIntersection = (x1, y1, x2, y2, ...) ->
  input = checkInput ...
  choices = {}


  for i = 1, #input, 2
    local _x1, _y1, _x2, _y2
    ssIntersection = getSegmentSegmentIntersection(input[i], input[i + 1], cycle(input, i + 2), cycle(input, i + 3), x1, y1, x2, y2)

    if type(ssIntersection) == 'table'
      _x1, _y1, _x2, _y2 = unpack ssIntersection  
    elseif type(ssIntersection) == 'boolean'
      _x1 = ssIntersection


    if _x1 and _x2 == nil then choices[#choices + 1] = {_x1, _y1}
    elseif _x2 then choices[#choices + 1] = {_x1, _y1, _x2, _y2}

  
  final = removeDuplicatePairs choices
  #final > 0 and final or false


--- checks if a line-segment is entirely within a circle
-- @tparam number circleX
-- @tparam number circleY
-- @tparam number circleRadius
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @treturn bool
isSegmentCompletelyInsideCircle = (circleX, circleY, circleRadius, x1, y1, x2, y2) ->
  sIntersection = getCircleSegmentIntersection(circleX, circleY, circleRadius, x1, y1, x2, y2)
  Type = unpack(sIntersection) if type(sIntersection) == 'table' else sIntersection
  return Type == 'enclosed'


  
--- checks if the point lies inside the polygon not on the polygon
-- @tparam number px
-- @tparam number py
-- @tparam number ...
-- @treturn bool
checkPolygonPoint = (px, py, ...) ->
  points = {unpack(checkInput(...))}

  greatest, least = getGreatestPoint(points, 0)
  if isWithinBounds(least, py, greatest) == false then return false
  greatest, least = getGreatestPoint points
  if isWithinBounds(least, px, greatest) == false then return false

  count = 0
  for i = 1, #points, 2
    if checkFuzzy(points[i + 1], py)
      points[i + 1] = py + .001
    if points[i + 3] and checkFuzzy(points[i + 3], py)
      points[i + 3] = py + .001

    x1, y1 = points[i], points[i + 1]
    x2, y2 = points[i + 2] or points[1], points[i + 3] or points[2]

    if getSegmentSegmentIntersection(px, py, greatest, py, x1, y1, x2, y2)
      count = count + 1
    
  count and count % 2 ~= 0

--- checks if a segment is completely inside a polygon
-- @tparam number x1
-- @tparam number y1
-- @tparam number x2
-- @tparam number y2
-- @tparam table ...
-- @treturn bool
isSegmentCompletelyInsidePolygon = (x1, y1, x2, y2, ...) ->
  polygon = {unpack(checkInput(...))}
  if checkPolygonPoint(x1, y1, polygon) == false or
    checkPolygonPoint( x2, y2, polygon ) == false or
    getPolygonSegmentIntersection(x1, y1, x2, y2, polygon)
    return false

  true

--- gets the intersection of a line and a line segment
-- @tparam table ... {x1, y1, x2, y2, x3, y3, x4, y4} or {x1, y1, x2, y2, slope, intercept}
-- @treturn table {x, y}
getLineSegmentIntersection = (x1, y1, x2, y2, ...) ->
  inpt = {unpack(checkInput(...))}


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

getRoot  = (number, root) ->
  number ^ ( 1 / root )

isPrime = (n) ->
  math = math
  if n < 2 then return false

  for i = 2, math.sqrt(n)
    if n % i == 0
      return false

  true


round = (number, decimals = 0) ->
  math = math
  pow = 10 ^ decimals
  math.floor(number * pow + .5) / pow

getSummation = (start, stop, func) ->
  rValues = {}
  sum = 0
  for i = start, stop
    val = func i, rValues
    rValues[i] = val
    sum += val
  sum

getPercentOfChange = (old, new) ->
  math = math
  if old == 0 and new == 0 then return 0
  else return (new - old) / math.abs(old)

getPercenrage = (percent, number) ->
  percent * number

getAngle = (x1, y1, x2, y2, x3, y3) ->
  a = getLength x3, y3, x2, y2 
  b = getLength x1, y1, x2, y2 
  c = getLength x1, y1, x3, y3

  math.acos (a * a + b * b - c * c) / (2 * a * b)


getPercentage = (percent, n) ->
  percent * n

getCircleArea = (radius) ->
  math = math
  math.pi * (radius * radius)

getCircumference = (radius) ->
  math = math
  2 * math.pi * radius

getCircleCircleIntersection = (circle1x, circle1y, radius1, circle2x, circle2y, radius2) ->
  length = getLength(circle1x, circle1y, circle2x, circle2y)
  if length > radius1 + radius2 then return false

  if checkFuzzy(length, 0) and checkFuzzy(radius1, radius2) then return 'equal'
  if checkFuzzy(circle1x, circle2x) and checkFuzzy(circle1y, circle2y) then return 'collinear'

  a = (radius1 * radius1 - radius2 * radius2 + length * length) / (2 * length)
  h = math.sqrt(radius1 * radius1 - a * a)

  p2x = circle1x + a * (circle2x - circle1x) / length
  p2y = circle1y + a * (circle2y - circle1y) / length
  p3x = p2x + h * (circle2y - circle1y) / length
  p3y = p2y - h * (circle2x - circle1x) / length
  p4x = p2x - h * (circle2y - circle1y) / length
  p4y = p2y + h * (circle2x - circle1x) / length

  if validateNumber(p3x) == false or validateNumber(p3y) == false or 
    validateNumber(p4x) == false or 
    validateNumber( p4y ) == false
    return 'inside'

  if checkFuzzy(length, radius1 + radius2) or 
    checkFuzzy(length, math.abs(radius1 - radius2))
    return 'tangent', p3x, p3y

  return 'intersection', p3x, p3y, p4x, p4y

isCircleCompletelyInsideCircle = (circle1x, circle1y, circle1radius, circle2x, circle2y, circle2radius) ->
  if checkCirclePoint(circle1x, circle1y, circle2x, circle2y, circle2radius) == false then return false
  Type = getCircleCircleIntersection(circle2x, circle2y, circle2radius, circle1x, circle1y, circle1radius)
  if (Type ~= 'tangent' and Type ~= 'collinear' and Type ~= 'inside') then return false
  return true

-- POLY  
getSignedPolygonArea = (...) ->
  points = checkInput(...)

  points[#points + 1] = points[1]
  points[#points + 1] = points[2]

  return (.5 * getSummation( 1, #points / 2,
    (index) ->
      index = index * 2 - 1
      return ((points[index] * cycle(points, index + 3 )) - (cycle(points, index + 2) * points[index + 1]))

  ))
    

getPolygonArea = (...) ->
  math = math
  inp = {...} 
  math.abs(getSignedPolygonArea( ... ))

getTriangleHeight = (base, ...) ->
  input = {unpack(checkInput(...))}
  
  local area
  
  if #input == 1
    area = input[1]
  else
    area = getPolygonArea input

  (2 * area) / base, area

getCentroid = (...) ->
  points = checkInput(...)

  points[#points + 1] = points[1]
  points[#points + 1] = points[2]

  area = getSignedPolygonArea points

  centroidX = (1 / (6 * area)) * ( getSummation(1, #points / 2,
    (index) ->
      index = index * 2 - 1
      return ((points[index] + cycle(points, index + 2 )) * ((points[index] * cycle(points, index + 3)) - (cycle(points, index + 2) * points[index + 1])))
  ))

  centroidY = (1 / (6 * area)) * (getSummation(1, #points / 2,
    (index) ->
      index = index * 2 - 1
      return ((points[index + 1] + cycle(points, index + 3)) * ((points[index] * cycle(points, index + 3)) - (cycle(points, index + 2) * points[index + 1])))
  ))

  centroidX, centroidY

isSegmentInsidePolygon = (x1, y1, x2, y2, ...) ->
  input = {unpack(checkInput(...))}

  choices = getPolygonSegmentIntersection x1, y1, x2, y2, input
  if choices then return true 

  if checkPolygonPoint(x1, y1, input) or checkPolygonPoint(x2, y2, input) then return true
  return false


getPolygonPolygonIntersection = (polygon1, polygon2) ->
  choices = {}

  for index1 = 1, #polygon1, 2
    intersections = getPolygonSegmentIntersection(polygon1[index1], polygon1[index1 + 1], cycle(polygon1, index1 + 2), cycle(polygon1, index1 + 3), polygon2)
    if intersections
      for index2 = 1, #intersections
        choices[#choices + 1] = intersections[index2]

  for index1 = 1, #polygon2, 2
    intersections = getPolygonSegmentIntersection(polygon2[index1], polygon2[index1 + 1], cycle( polygon2, index1 + 2), cycle( polygon2, index1 + 3), polygon1)
    if intersections
      for index2 = 1, #intersections
        choices[#choices + 1] = intersections[index2]

  choices = removeDuplicatePairs choices
  for i = #choices, 1, -1
    if type(choices[i][1]) == 'table'
      table.remove(choices, i)

  #choices > 0 and choices


getPolygonCircleIntersection = (x, y, radius, ...) ->
  input = {unpack(checkInput(...))}
  choices = {}

  for i = 1, #input, 2
    local Type, x1, y1, x2, y2
    cInter = getCircleSegmentIntersection(x, y, radius, input[i], input[i + 1], cycle(input, i + 2), cycle(input, i + 3))
    if type(cInter) == 'table'
      Type, x1, y1, x2, y2 = unpack(cInter)
    else
      Type = cInter
    if x2
      choices[#choices + 1] = {Type, x1, y1, x2, y2}
    elseif x1 then choices[#choices + 1] = {Type, x1, y1}

  final = removeDuplicates4Points choices
  #final > 0 and final


isPolygonInsidePolygon = (polygon1, polygon2) ->
  bool = false

  for i = 1, #polygon2, 2
    result = false
    result = isSegmentInsidePolygon(polygon2[i], polygon2[i + 1], cycle(polygon2, i + 2), cycle(polygon2, i + 3), polygon1)
    if result 
      bool = true
      break
  bool

isPolygonCompletelyInsidePolygon = (polygon1, polygon2) ->
  for i = 1, #polygon1, 2
    x1, y1 = polygon1[i], polygon1[i + 1]
    x2, y2 = polygon1[i + 2] or polygon1[1], polygon1[i + 3] or polygon1[2]
    if isSegmentCompletelyInsidePolygon(x1, y1, x2, y2, polygon2) == false
      return false

  true


isPolygonCompletelyInsideCircle = (circleX, circleY, circleRadius, ...) ->
  input = {unpack(checkInput(...))}
  isDistanceLess = (px, py, x, y, circleRadius) ->
    distanceX, distanceY = px - x, py - y
    return distanceX * distanceX + distanceY * distanceY < circleRadius * circleRadius

  for i = 1, #input, 2
    if checkCirclePoint(input[i], input[i + 1], circleX, circleY, circleRadius) == false then return false

  true

isCircleCompletelyInsidePolygon = (circleX, circleY, circleRadius, ...) ->
  input = {unpack(checkInput(...))}
  if checkPolygonPoint(circleX, circleY, ...) == false then return false
    
  rad2 = circleRadius * circleRadius

  for i = 1, #input, 2
    x1, y1 = input[i], input[i + 1]
    x2, y2 = input[i + 2] or input[1], input[i + 3] or input[2]
    if distance2(x1, y1, circleX, circleY) <= rad2 then return false
    if getCircleSegmentIntersection(circleX, circleY, circleRadius, x1, y1, x2, y2) then return false

  true
  
{ 
  point: {
    rotate: rotatePoint
    scale: scalePoint
    polarToCartesian: polarToCartesian
    cartesianToPolar: cartesianToPolar
  }

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

  segment: {
    checkPoint: checkSegmentPoint
    getPerpendicularBisector: getPerpendicularBisector
    getIntersection: getSegmentSegmentIntersection
    getSegmentIntersection: getSegmentSegmentIntersection
    getCircleIntersection: getCircleSegmentIntersection
    getPolygonIntersection: getPolygonSegmentIntersection
    isSegmentCompletelyInsideCircle: isSegmentCompletelyInsideCircle
    isSegmentCompletelyInsidePolygon: isSegmentCompletelyInsidePolygon
    getLineIntersection: getLineSegmentIntersection
  }

  math: {
    getRoot: getRoot
    isPrime: isPrime
    round: round
    getSummation: getSummation
    getPercentOfChange: getPercentOfChange
    getQuadraticRoots: getQuadraticRoots
    getAngle: getAngle
    getPercentage: getPercentage
  }

  circle: {
    getArea: getCircleArea
    checkPoint: checkCirclePoint
    isPointOnCircle: isPointOnCircle
    getCircumference: getCircumference
    getLineIntersection: getCircleLineIntersection
    getSegmentIntersection: getCircleSegmentIntersection
    getCircleIntersection: getCircleCircleIntersection
    isCircleCompletelyInside: isCircleCompletelyInsideCircle
    isPolygonCompletelyInside: isPolygonCompletelyInsideCircle
    isSegmentCompletelyInside: isSegmentCompletelyInsideCircle

    getPolygonIntersection: getPolygonCircleIntersection
    isCircleInsidePolygon: isCircleInsidePolygon
    isCircleCompletelyInsidePolygon: isCircleCompletelyInsidePolygon
  }

  polygon:{
    getSignedArea: getSignedPolygonArea
    getArea: getPolygonArea
    getTriangleHeight: getTriangleHeight
    getCentroid: getCentroid
    getLineIntersection: getPolygonLineIntersection
    getSegmentIntersection: getPolygonSegmentIntersection
    checkPoint: checkPolygonPoint
    isSegmentInside: isSegmentInsidePolygon
    getPolygonIntersection: getPolygonPolygonIntersection
    getCircleIntersection: getPolygonCircleIntersection
    isCircleInside: isCircleInsidePolygon
    isPolygonInside: isPolygonInsidePolygon
    isCircleCompletelyInside: isCircleCompletelyInsidePolygon
    isSegmentCompletelyInside: isSegmentCompletelyInsidePolygon
    isPolygonCompletelyInside: isPolygonCompletelyInsidePolygon

    isCircleCompletelyOver: isPolygonCompletelyInsideCircle

    getPolygonArea: getPolygonArea

    getCircleSegmentIntersection: getCircleSegmentIntersection
  }
}
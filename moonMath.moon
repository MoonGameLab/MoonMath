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

--- scales a point
-- @tparam number x
-- @tparam number y
-- @tparam number scale
-- @tparam number ox
-- @tparam number oy
-- @treturn table {x, y}
scalePoint = (x, y, scale, ox = 0, oy = 0) ->
  (x - ox) * scale + ox, (y - oy) * scale + oy
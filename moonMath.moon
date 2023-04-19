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
removeDuplicate3Points = (t) ->
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



{
  :checkFuzzy
  :removeDuplicate3Points
}
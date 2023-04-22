mm = assert require "moonMath"

checkFuzzy = (n1, n2) ->
  (n1 - .00001 <= n2 and n2 <= n1 + .00001)

deepCompre = (tab1, tab2) ->
  if type(tabe1) ~= type(tab2) then return false

  for key, value in pairs tab1
    if type(value) == 'table' and type(tab2[key]) == 'table'
      if deepCompre(value, tab2[key]) == false then return false
    else
        if type(value) ~= type(tab2[key]) then return false
        if type(value) == 'number'
          return checkFuzzy(value, tab2[key])
        elseif value ~= tab2[key] then return false

  for key, value in pairs tab2
    if type(value) == 'table' and type(tab1[key]) == 'table'
      if deepCompre(value, tab1[key]) == false then return false
    else
        if type(value) ~= type(tab1[key]) then return false
        if type(value) == 'number'
          return checkFuzzy(value, tab1[key])
        elseif value ~= tab1[key] then return false
  return true


fuzzyEqual = (a, b) ->
  checkFuzzy a, b

tablesFuzzyEqual = (tab1, tab2) ->
  deepCompre tab1, tab2

multipleFUzzyEqual = (a, b) ->
  for i = 1, #a
    if type(a[i]) == 'number'
      if a[i] ~= b[i] then return false
    else
      if checkFuzzy(a[i], b[i]) then return false
  true


--- Register helpers
assert\register "assertion", "fuzzyEqual",fuzzyEqual
assert\register "assertion", "tablesFuzzyEqual",tablesFuzzyEqual
assert\register "assertion", "multipleFUzzyEqual",multipleFUzzyEqual


describe "getLineIntersection", ->
  it "test1", ->
    print mm.line.getLineIntersection( 1, 0, 1, 0, 0, 1 )
    assert.multipleFUzzyEqual mm.line.getLineIntersection( 1, 0, 1, 0, 0, 1 ), { .5, .5 }
m = assert require 'moon'
dump = m.p

mm = assert require "init"
vec2D = mm.vec2D!

checkFuzzy = (a, b) ->
  (a - .00001 <= b and b <= a + .00001)

deepCompare = (Table1, Table2) ->
  if type(Table1) ~= type(Table2) then return false
  
  for Key, Value in pairs(Table1)
    if (type(Value) == 'table' and type(Table2[Key]) == 'table')
      if ( not deepCompare( Value, Table2[Key] ) ) then return false
    else
      if type( Value ) ~= type( Table2[Key] ) then return false
      if type( Value ) == 'number'
        return checkFuzzy(Value, Table2[Key])
      elseif ( Value ~= Table2[Key] ) then return false

  for Key, Value in pairs(Table2)
    if ( type( Value ) == 'table' and type( Table1[Key] ) == 'table' )
      if ( not deepCompare( Value, Table1[Key] ) ) then return false
    else
      if type( Value ) ~= type( Table1[Key] ) then return false
      if type( Value ) == 'number'
        return checkFuzzy( Value, Table1[Key] )
      elseif ( Value ~= Table1[Key] ) then return false

  true


fuzzyEqual = (i, p) ->
  a, b = p[1], p[2]
  checkFuzzy a, b

tablesFuzzyEqual = (params) =>
  deepCompare params[1], params[2]

--- Register helpers
assert\register "assertion", "fuzzyEqual",fuzzyEqual
assert\register "assertion", "tablesFuzzyEqual",tablesFuzzyEqual

describe "vec2D.from", ->

  it " :: Create a vec2D from a table.", ->
    vec = vec2D.from {2, 43}
    assert.tablesFuzzyEqual vec, {x: 2, y: 43}


describe "vec2D.set", ->

  it " :: Sets a vector.", ->
    vec = vec2D.ZERO!
    
    vec2D.set vec, 10, 5
    
    assert.tablesFuzzyEqual vec, {x: 10, y: 5}


    

  
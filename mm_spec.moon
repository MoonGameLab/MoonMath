mm = assert require "moonMath"

m = assert require 'moon'
dump = m.p

checkFuzzy = (n1, n2) ->
  (n1 - .00001 <= n2 and n2 <= n1 + .00001)

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

fuzzyEqual = (a, b) ->
  checkFuzzy a, b

tablesFuzzyEqual = (params) =>
  deepCompare params[1], params[2]

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


--- Point
describe "point.rotate", ->
  point = mm.point

  it " :: Rotates a point.", ->
    assert.multipleFUzzyEqual {point.rotate(3, 6, math.pi)}, {-3, -6}
    assert.multipleFUzzyEqual {point.rotate(3, 6, 2 * math.pi)}, {3, 6}
    assert.multipleFUzzyEqual {point.rotate(2, 2, -math.pi / 6)}, {02.7320508075600003, .7320508075600001}


  it " :: Rotates about other point.", ->
    assert.multipleFUzzyEqual {point.rotate(2, 3, math.pi / 2, 2, -2)}, {-3, -2}
    assert.multipleFUzzyEqual {point.rotate(-6, 1, math.pi,-1, 2 )}, { 4, 3 }
  
describe "point.scale", ->
  point = mm.point

  it " :: Scales a point.", ->
    print "\npoint.scale :: "
    dump {point.scale(-2, -2, 2 )}
    assert.multipleFUzzyEqual {point.scale(-2, -2, 2 )}, {-4, -4}
    assert.multipleFUzzyEqual {point.scale(6, -3, 1/3)}, {2, -1}

  it " :: Scales a point about other point.", ->
    print "\npoint.scale :: "
    dump {point.scale(2, 4, .5, -2, -2)}
    assert.multipleFUzzyEqual {point.scale(2, 4, .5, -2, -2)}, {0, 1}
    assert.multipleFUzzyEqual {point.scale(5, -1, 5/3, -4, -4)}, {11, 1}
    assert.multipleFUzzyEqual {point.scale(6, 4, 4/5, 5, -1)}, {5.8, 3}

  


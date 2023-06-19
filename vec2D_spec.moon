m = assert require 'moon'
dump = m.p

mm = assert require "init"
vec2D = mm.vec2D!
vec2DArr = mm.vec2DArr!

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

describe "vec2D.from", ->
  it " :: Creates a vec2D from given vec2D/Table", ->
    vec1 = vec2D.from {10, 20}
    vec2 = vec2D.from {x: 11, y: 22}

    assert.tablesFuzzyEqual vec1, {x: 10, y: 20}
    assert.tablesFuzzyEqual vec2, {x: 11, y: 22}

describe "vec2D.ZERO", ->
  it " :: Creates a zero vec2D {x: 0, y: 0}", ->
    vec = vec2D.ZERO!

    assert.tablesFuzzyEqual vec, {x: 0, y: 0}

describe "vec2D.set", ->

  it " :: Sets a vector.", ->
    vec = vec2D.ZERO!
    
    vec2D.set vec, 10, 5
    
    assert.tablesFuzzyEqual vec, {x: 10, y: 5}


describe "vec2D.setFrom", ->

  it " :: Sets a vec2D from another.", ->
    vecO = vec2D.from {100, 30}
    vec = vec2D.ZERO!
    vec2D.setFrom vec, vecO
    
    assert.tablesFuzzyEqual vec, {x: 100, y: 30}


describe "vec2D.add", ->

  it " :: Adds a vec2D to another or scalar.", ->
    vecO = vec2D.from {100, 30}
    vec = vec2D.ZERO!
    vec2D.setFrom vec, {x: 2, y: 4}
    
    vec2D.add vec, vecO
    assert.tablesFuzzyEqual vec, {x: 102, y: 34}
    
    vec2D.addS vec, 10
    assert.tablesFuzzyEqual vec, {x: 112, y: 44}

  
describe "vec2D.crossProd", ->

  it " :: Gets crossProd of twi vec2D.", ->
    vec1 = vec2D.from {20, 50}
    vec2 = vec2D.from {21, 66}

    assert.equal 270, vec2D.crossProd vec1, vec2

describe "vec2D.lenght", ->

  it " :: Gets vec2D mag.", ->
    vec = vec2D.from {3, 4}

    assert.equal 5, vec2D.length vec
    assert.equal 25, vec2D.sqlength vec

describe "vec2D.dist", ->

  it " :: Gets the dist between two pos vectors.", ->
    vec1 = vec2D.from {1, 2}
    vec2 = vec2D.from {1, 3}

    assert.equal 1, vec2D.dist vec1, vec2

describe "vec2D.normalize", ->

  it " :: Normalizes a vectors.", ->
    vec1 = vec2D.from {3, 2}
    vec2D.normalize vec1
    assert.tablesFuzzyEqual vec1, {x: 0.83205, y: 0.5547}

m = assert require 'moon'
dump = m.p

mm = assert require "moonMath"




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

multipleFUzzyEqual = (i, p) ->
  a, b = p[1], p[2]
  for i = 1, #a do
    if type( a[i] ) ~= 'number'
      if a[i] ~= b[i]
        return false
    else
      if checkFuzzy( a[i], b[i] ) == false
        return false

  return true
  
  


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
    assert.multipleFUzzyEqual {point.scale(-2, -2, 2 )}, {-4, -4}
    assert.multipleFUzzyEqual {point.scale(6, -3, 1/3)}, {2, -1}

  it " :: Scales a point about other point.", ->
    assert.multipleFUzzyEqual {point.scale(2, 4, .5, -2, -2)}, {0, 1}
    assert.multipleFUzzyEqual {point.scale(5, -1, 5/3, -4, -4)}, {11, 1}
    assert.multipleFUzzyEqual {point.scale(6, 4, 4/5, 5, -1)}, {5.8, 3}


describe "point.polarToCartesian", ->
  point = mm.point

  it " :: Convert polar coords to cartesian coords.", ->
    assert.multipleFUzzyEqual point.polarToCartesian(10, math.pi / 2), {0, 10} 
    assert.multipleFUzzyEqual point.polarToCartesian(math.sqrt( 2 ), math.pi / 4), {1, 1}

  it " :: Convert polar coords to cartesian coords. <Uses absolute angle>", ->
    assert.multipleFUzzyEqual point.polarToCartesian(math.sqrt(2), 5 * math.pi / 4), {-1, -1}

  it " :: Convert polar coords to cartesian coords. <Offset>", ->
    assert.multipleFUzzyEqual point.polarToCartesian(10, math.pi / 2, 5.8309518948453, 0.54041950027058), {5, 13}
    assert.multipleFUzzyEqual point.polarToCartesian(math.sqrt(2), math.pi / 4, 13.453624047074, 0.83798122500839), {10, 11}
    assert.multipleFUzzyEqual point.polarToCartesian(math.sqrt(2), 5 * math.pi / 4, 4.0311288741493, 2.6224465393433), {-4.5, 1}


describe "point.cartesianToPolar", ->
  point = mm.point

  it " :: Convert cartesian coords to polar coords.", ->
    assert.multipleFUzzyEqual point.cartesianToPolar(0, 10), { 10, math.pi / 2 }
    assert.multipleFUzzyEqual point.cartesianToPolar(1, 1), {math.sqrt(2), math.pi / 4}

  it " :: Convert cartesian coords to polar coords. <Uses absolute angle>", ->
    assert.multipleFUzzyEqual point.cartesianToPolar(-1, -1), {math.sqrt(2), 5 * math.pi / 4}

  it " :: Convert cartesian coords to polar coords. <Offset>", ->
    assert.multipleFUzzyEqual point.cartesianToPolar( 5, 13, 5, 3 ), { 10, math.pi / 2 }
    assert.multipleFUzzyEqual point.cartesianToPolar( 10, 11, 9, 10 ), { math.sqrt( 2 ), math.pi / 4 }
    assert.multipleFUzzyEqual point.cartesianToPolar( -4.5, 1, -3.5, 2 ), { math.sqrt( 2 ), 5 * math.pi / 4 } 


--- Line

describe "line.getLength", ->
  
  it " :: Gets the leght of a line.", ->
    line = mm.line
    assert.fuzzyEqual line.getLength(1, 1, 1, 2), 1
    assert.fuzzyEqual line.getLength(0, 0, 1, 0), 1
    assert.fuzzyEqual line.getLength(4, 4, 7, 8), 5
    assert.fuzzyEqual line.getLength(9.3, 7.6, -12, .001), 22.61492
    assert.fuzzyEqual line.getLength(4.2, 4.134, 7.2342, -78), 82.190025


describe "line.getDistance", ->
  
  it " :: Gets the leght of a line. <Alias or line.getLength>", ->
    line = mm.line
    assert.fuzzyEqual line.getDistance(1, 1, 1, 2), line.getLength(1, 1, 1, 2)
    assert.fuzzyEqual line.getDistance(0, 0, 1, 0), line.getLength(0, 0, 1, 0)
    assert.fuzzyEqual line.getDistance(4, 4, 7, 8), line.getLength(4, 4, 7, 8)
    assert.fuzzyEqual line.getDistance(9.3, 7.6, -12, .001), line.getLength(9.3, 7.6, -12, .001)
    assert.fuzzyEqual line.getDistance(4.2, 4.134, 7.2342, -78), line.getLength(4.2, 4.134, 7.2342, -78)


describe "line.getMidpoint", ->
  
  it " :: Gets the midPoint of a line.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getMidpoint( 0, 0, 2, 2 ), { 1, 1 }
    assert.multipleFUzzyEqual line.getMidpoint( 4, 4, 7, 8 ), { 5.5, 6 }
    assert.multipleFUzzyEqual line.getMidpoint( -1, 2, 3, -6 ), { 1, -2 }
    assert.multipleFUzzyEqual line.getMidpoint( 6.4, 3, -10.7, 4 ), { -2.15, 3.5 }
    assert.multipleFUzzyEqual line.getMidpoint( 3.14159, 3.14159, 2.71828, 2.71828 ), { 2.92993, 2.92993 }


describe "line.getSlope", ->
  
  it " :: Gets the slope of a line.", ->
    line = mm.line
    assert.fuzzyEqual line.getSlope( 1, 1, 2, 2 ), 1
    assert.fuzzyEqual line.getSlope( 1, 1, 0, 1 ), 0
    assert.fuzzyEqual line.getSlope( 1, 0, 0, 1 ), -1
    -- should return false if slope is vertical
    assert.false line.getSlope(1, 0, 1, 5)
    assert.false line.getSlope(-4, 9, -4, 13423)

describe "line.getPerpendicularSlope", ->
  
  it " :: Gets the perpendicular slope given two lines.", ->
    line = mm.line
    assert.fuzzyEqual line.getPerpendicularSlope(1, 1, 2, 2), -1

  it " :: Gets the perpendicular slope given a slope.", ->
    line = mm.line
    assert.fuzzyEqual line.getPerpendicularSlope(2), -.5

  it " :: Gets the perpendicular slope given a slope.<the initial line is vertical>", ->
    line = mm.line
    assert.fuzzyEqual line.getPerpendicularSlope( 1, 0, 1, 5 ), 0
    assert.fuzzyEqual line.getPerpendicularSlope( false ), 0
  
  it " :: Gets the perpendicular slope given a slope.<the initial slope is horizontal>", ->
    line = mm.line
    assert.false line.getPerpendicularSlope(0, 0, 5, 0)

describe "line.getYIntercept", ->
  
  it " :: Gets the y-intercept.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getYIntercept( 0, 0, 1, 1 ), { 0, false }

  it " :: Gets the x, true if the slope is false.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getYIntercept(1, 0, 1, 5), { 1, true }
    assert.multipleFUzzyEqual line.getYIntercept( 0, 0, false ), { 0, true }

describe "line.getIntersection", ->
  
  it " :: Gets the slope, y-intercept, and two points of other line.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getIntersection( 1, 0, 1, 0, 0, 1 ), { .5, .5 } 

  it " :: Gets the slope, y-intercept, the other slope and y-intercept.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getIntersection( 1, 0, -1, 1 ), { .5, .5 }

  it " :: Gets two points on one line and two on the other.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getIntersection( 1, 1, 0, 0, 1, 0, 0, 1 ), { .5, .5 }

  it " :: Works for vertical lines.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getIntersection( 1, 0, 1, 5, 2, 2, 0, 2 ), { 1, 2 }

  it " :: Returns false if the lines are parallel and don\'t intersect.", ->
    line = mm.line
    assert.false line.getIntersection( 2, 4, 2, 7 )

  it " :: Works with collinear lines.", ->
    line = mm.line
    assert.true line.getIntersection( 0, 0, 2, 2, 1, 1, 3, 3 )

describe "line.getClosestPoint", ->
  it " :: Returns the point and two points on the line.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getClosestPoint( 4, 2, 1, 1, 3, 5 ), { 2, 3 }
    assert.multipleFUzzyEqual line.getClosestPoint( 3, 5, 3, 0, 2, 2 ), { 1, 4 }
    assert.multipleFUzzyEqual line.getClosestPoint( -1, 3, -2, 0, 2, 2 ), { 0, 1 }

  it " :: Returns the point and the slope and y-intercept.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getClosestPoint( 4, 2, 2, -1 ), { 2, 3 }
    assert.multipleFUzzyEqual line.getClosestPoint( -1, 3, .5, 1 ), { 0, 1 } 

describe "line.getSegmentIntersection", ->
  it " :: Given the end points of the segment and 2 points on the line.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getSegmentIntersection( 3, 6, 5, 8, 3, 8, 5, 6 ), { 4, 7 }
    assert.multipleFUzzyEqual line.getSegmentIntersection( 0, 0, 4, 4, 0, 4, 4, 0 ), { 2, 2 }
  
  it " :: Given end points of the segment and the slope and intercept.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getSegmentIntersection( 3, 6, 5, 8, -1, 11 ), { 4, 7 }

  it " :: Returns false if they don\'t intersect.", ->
    line = mm.line
    assert.false line.getSegmentIntersection( 0, 0, 1, 1, 0, 4, 4, 0 )
    assert.false line.getSegmentIntersection( 0, 0, 1, 1, -1, 4 ) 
  
  it " :: Works with collinear lines.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getSegmentIntersection( 0, 0, 2, 2, -1, -1, 3, 3 ), { 0, 0, 2, 2 } 

describe "line.checkPoint", ->
  it " :: Returns true if the point is on the line.", ->
    line = mm.line
    assert.true line.checkPoint(1, 1, 0, 0, 2, 2)
    assert.true line.checkPoint(3, 10, 0, 1, 1, 4)

  it " :: Returns false if the point is on the line.", ->
    line = mm.line
    assert.false line.checkPoint(4, 5, 1, 0, 6, 3)

  it " :: Works with vertical lines.", ->
    line = mm.line
    assert.true line.checkPoint(1, 1, 1, 0, 1, 2)
    assert.false line.checkPoint(2, 4, 1, 0, 1, 2)


describe "line.getCircleIntersection", ->
  it " :: Returns \'Secant\' when intersects twice.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getCircleIntersection( 4, 9, 1, 0, 9, 6, 9 ), { 'secant', 3, 9, 5, 9 }
    assert.multipleFUzzyEqual line.getCircleIntersection( 2, 2, 1, 2, 3, 3, 2 ), { 'secant', 2, 3, 3, 2 }

  it " :: Returns \'Secant\' when intersects twice.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getCircleIntersection( 4, 9, 1, 0, 8, 6, 8 ), { 'tangent', 4, 8 }
    assert.multipleFUzzyEqual line.getCircleIntersection( 2, 2, 1, 2, 3, 0, 3 ), { 'tangent', 2, 3 }

  it " :: Returns \'false\' when neither.", ->
    line = mm.line
    assert.false line.getCircleIntersection( 4, 9, 1, 0, 7, 6, 8 )


describe "line.getPolygonIntersection", ->
  it " :: Returns true if the line intersects the polygon.", ->
    line = mm.line
    tab = line.getPolygonIntersection( 0, 4, 4, 4, 0, 0, 0, 4, 4, 4, 4, 0 )
    assert.tablesFuzzyEqual tab, { { 0, 4 }, { 4, 4 } }
    tab2 = line.getPolygonIntersection(0, 4, 4, 0, 0, 0, 0, 4, 4, 4, 4, 0)
    assert.tablesFuzzyEqual tab, { { 0, 4 }, { 4, 0 } }
  
  it " :: Returns false if the line does not intersect.", ->
    line = mm.line
    assert.false line.getPolygonIntersection( 0, 5, 5, 5, 0, 0, 0, 4, 4, 4, 4, 0 )

  it " :: Works with vertical lines.", ->
    line = mm.line
    tab = line.getPolygonIntersection( 0, 0, 0, 4, 0, 0, 0, 4, 4, 4, 4, 0 )
    assert.tablesFuzzyEqual tab, { { 0, 4 }, { 0, 0 } }
    assert.false line.getPolygonIntersection( -1, 0, -1, 5, 0, 0, 0, 4, 4, 4, 4, 0 )

describe "line.getLineIntersection", ->
  it " :: Returns true if the line intersects the polygon.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getLineIntersection( 1, 0, 1, 0, 0, 1 ), { .5, .5 }

  it " :: Given two points on one line and two on the other.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getLineIntersection( 1, 1, 0, 0, 1, 0, 0, 1 ), { .5, .5 }

  it " :: Given the slope, y-intercept, the other slope and y-intercept.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getLineIntersection( 1, 0, -1, 1 ), { .5, .5 }
    assert.multipleFUzzyEqual line.getLineIntersection( 2, -11, -1, 19 ), { 10, 9 }

  it " :: Works for vertical lines.", ->
    line = mm.line
    assert.multipleFUzzyEqual line.getLineIntersection( 1, 0, 1, 5, 2, 2, 0, 2 ), { 1, 2 }

  it " :: Returns false if the lines are parallel and don\'t intersect.", ->
    line = mm.line
    assert.false line.getLineIntersection( 2, 4, 2, 7 )

  it " :: Works with collinear lines.", ->
    line = mm.line
    assert.true line.getLineIntersection( 0, 0, 2, 2, 1, 1, 3, 3 )

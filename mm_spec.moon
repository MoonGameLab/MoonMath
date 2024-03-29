m = assert require 'moon'
dump = m.p

mm = assert require "init"


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


-- SEGMENT
describe "segment.checkPoint", ->
  it " :: Returns true if the point is on the segment.", ->
    segment = mm.segment
    assert.true segment.checkPoint( 1, 1, 2, 2, 0, 0 )
    assert.true segment.checkPoint( 3, 8, 1, 4, 5, 12 )
    assert.true segment.checkPoint( -.5, 2, -1, 4, 0, 0 )

  it " :: Returns false if the point is not on the segment.", ->
    segment = mm.segment
    assert.false segment.checkPoint( 3, 1, 2, 2, 0, 0 )
    assert.false segment.checkPoint( 3, 9, 1, 4, 5, 12 )

describe "segment.getPerpendicularBisector", ->
  it " :: Returns true if the point is on the segment.", ->
    segment = mm.segment
    assert.multipleFUzzyEqual segment.getPerpendicularBisector( 1, 1, 3, 3 ), { 2, 2, -1 } 
    assert.multipleFUzzyEqual segment.getPerpendicularBisector( 1, 0, 1, 8 ), { 1, 4, 0 } 
    assert.multipleFUzzyEqual segment.getPerpendicularBisector( 4, 4, 6, 8 ), { 5, 6, -.5 }

  it " :: Returns false and midpoint if original slope is horizontal.", ->
    segment = mm.segment
    assert.multipleFUzzyEqual segment.getPerpendicularBisector( 0, 0, 6, 0 ), { 3, 0, false }
    assert.multipleFUzzyEqual segment.getPerpendicularBisector( 5, 7, 10, 7 ), { 7.5, 7, false }

describe "segment.getIntersection", ->
  it " :: Returns the point of intersection if they do.", ->
    segment = mm.segment
    assert.multipleFUzzyEqual segment.getIntersection( 1, 1, 5, 3, 2, 3, 4, 1 ), { 3, 2, nil, nil }
    assert.multipleFUzzyEqual segment.getIntersection( 0, 0, 3, 3, 0, 1, 3, 1 ), { 1, 1, nil, nil }

  it " :: Returns false if they don\'t.'", ->
    segment = mm.segment
    assert.false segment.getIntersection( 3, 7, 6, 8, 1, 6, 5, 4 ), { false, nil, nil, nil }

  it " :: Return x1, y1, x2, y2 if lines have same slope and intercept.'", ->
    segment = mm.segment
    assert.multipleFUzzyEqual segment.getIntersection( 0, 0, 2, 2, 1, 1, 3, 3 ), { 2, 2, 1, 1 }
    assert.multipleFUzzyEqual segment.getIntersection( 0, 1, 4, 1, 2, 1, 3, 1 ), { 2, 1, 3, 1 } 

  
describe "segment.getCircleIntersection", ->
  it " :: Returns \'Secant\' if the line connects two points.", ->
    segment = mm.segment
    assert.multipleFUzzyEqual segment.getCircleIntersection( 4, 9, 1, 0, 9, 6, 9 ), { 'secant', 3, 9, 5, 9 }


  it " :: Returns \'Tangent\' if the line attaches only one point.", ->
    segment = mm.segment
    assert.multipleFUzzyEqual segment.getCircleIntersection( 1, 1, 1, 0, 0, 0, 2 ), { 'tangent', 0, 1 } 

  
  it " :: Returns \'Chord\' if both points are on the circle.", ->
    segment = mm.segment
    assert.multipleFUzzyEqual segment.getCircleIntersection( 0, 0, 1, -1, 0, 1, 0 ), { 'chord', -1, 0, 1, 0 }

  
  it " :: Returns \'Enclosed\' if the line is within the circle entirely.", ->
    segment = mm.segment
    assert.multipleFUzzyEqual segment.getCircleIntersection( 0, 0, 2, -1, 0, 1, 0 ), { 'enclosed', -1, 0, 1, 0 }


  it " :: Returns \'false\' if the line doesn\'t touch anywhere.", ->
    segment = mm.segment
    assert.false segment.getCircleIntersection( 0, 0, 1, 2, 2, 2, 3 )


describe "segment.getPolygonIntersection", ->
  it " :: Returns the points of intersection.", ->
    segment = mm.segment
    assert.tablesFuzzyEqual mm.segment.getPolygonIntersection( 4, 2, 6, 4, 3, 4, 4, 6, 8, 4, 7, 2 ), { { 5, 3 } }
    assert.tablesFuzzyEqual mm.segment.getPolygonIntersection( 4, 2, 8, 6, 3, 4, 4, 6, 8, 4, 7, 2 ), { { 6.66666, 4.66666 }, { 5, 3 } }
    assert.false mm.segment.getPolygonIntersection( 0, 0, 0, 1, 3, 4, 4, 6, 8, 4, 7, 2 )


  it " :: Works with collinear lines.", ->
    assert.tablesFuzzyEqual mm.segment.getPolygonIntersection( 2, 7, 10, 3, 3, 4, 4, 6, 8, 4, 7, 2 ), { { 4, 6 }, { 8, 4 } }
    assert.false mm.segment.getPolygonIntersection( 2, 7, 0, 8, 3, 4, 4, 6, 8, 4, 7, 2 )

  it " :: Works with vertical lines (on poly. and/or segment).", ->
    assert.tablesFuzzyEqual mm.segment.getPolygonIntersection( 6, 2, 6, 6, 3, 4, 4, 6, 8, 4, 7, 2 ), { { 6, 2.5 }, { 6, 5 } }
    assert.tablesFuzzyEqual mm.segment.getPolygonIntersection( 6, 4, 10, 4, 3, 4, 4, 6, 8, 5, 8, 3 ), { { 8, 4 } }
    assert.tablesFuzzyEqual mm.segment.getPolygonIntersection( 8, 1, 8, 4, 3, 4, 4, 6, 8, 5, 8, 3 ), { { 8, 3, 8, 4 } } 
    assert.false mm.segment.getPolygonIntersection( 1, 0, 1, 5, 3, 4, 4, 6, 8, 5, 8, 3 ) 


describe "segment.getPolygonIntersection", ->
  it " :: Same as line.getSegmentIntersection", ->
    assert.true true


describe "segment.getLineIntersection", ->
  it " :: Given the end points of the segment and 2 points on the line.", ->
    segment = mm.segment
    assert.multipleFUzzyEqual mm.segment.getLineIntersection( 3, 6, 5, 8, 3, 8, 5, 6 ), { 4, 7 }
    assert.multipleFUzzyEqual mm.segment.getLineIntersection( 0, 0, 4, 4, 0, 4, 4, 0 ), { 2, 2 }

  it " :: Given end points of the segment and the slope and intercept.", ->
    assert.multipleFUzzyEqual mm.segment.getLineIntersection( 3, 6, 5, 8, -1, 11 ), { 4, 7 } 

  it " :: Returns false if they don\'t intersect.", ->
    assert.false mm.segment.getLineIntersection( 0, 0, 1, 1, 0, 4, 4, 0 )
    assert.false mm.segment.getLineIntersection( 0, 0, 1, 1, -1, 4 )

  it " :: Works with collinear lines.", ->
    assert.multipleFUzzyEqual mm.segment.getLineIntersection( 0, 0, 2, 2, -1, -1, 3, 3 ), { 0, 0, 2, 2 }

describe "segment.getSegmentIntersection", ->
  it " :: Returns the point of intersection if they do.", ->
    segment = mm.segment
    assert.multipleFUzzyEqual mm.segment.getSegmentIntersection( 1, 1, 5, 3, 2, 3, 4, 1 ), { 3, 2, nil, nil }
    assert.multipleFUzzyEqual mm.segment.getSegmentIntersection( 0, 0, 3, 3, 0, 1, 3, 1 ), { 1, 1, nil, nil }
    
  it " :: Returns false if they don\'t.", ->
    assert.multipleFUzzyEqual {mm.segment.getSegmentIntersection( 3, 7, 6, 8, 1, 6, 5, 4 )}, { false, nil, nil, nil }

  it " :: Return x1, y1, x2, y2 if lines have same slope and intercept.", ->
    assert.multipleFUzzyEqual mm.segment.getSegmentIntersection( 0, 0, 2, 2, 1, 1, 3, 3 ), { 2, 2, 1, 1 } 
    assert.multipleFUzzyEqual mm.segment.getSegmentIntersection( 0, 1, 4, 1, 2, 1, 3, 1 ), { 2, 1, 3, 1 }


describe "segment.isSegmentCompletelyInsidePolygon", ->
  it " :: Returns if a segment is completely inside of a polygon.", ->
    segment = mm.segment
    assert.true mm.segment.isSegmentCompletelyInsidePolygon( 0, .5, .5, 0, -.5, -.5, -1, -.5, -1, .5, -.5, .5, -.5, 1, .5, 1, .5, .5, 1, .5, 1, -.5, .5, -.5, .5, -1 )
    assert.false mm.segment.isSegmentCompletelyInsidePolygon( 1.5, 1, 1, 1, -.5, -.5, -1, -.5, -1, .5, -.5, .5, -.5, 1, .5, 1, .5, .5, 1, .5, 1, -.5, .5, -.5, .5, -1 )
    assert.false mm.segment.isSegmentCompletelyInsidePolygon( 1, .5, .5, 1, -.5, -.5, -1, -.5, -1, .5, -.5, .5, -.5, 1, .5, 1, .5, .5, 1, .5, 1, -.5, .5, -.5, .5, -1 )


describe "segment.isSegmentCompletelyInsidePolygon", ->
  it " :: Returns if a segment is completely within a circle.", ->
    segment = mm.segment
    assert.true mm.segment.isSegmentCompletelyInsideCircle( 3, 3, 2, 2, 2, 3, 4 )
    assert.false mm.segment.isSegmentCompletelyInsideCircle( 3, 3, 2, 1, 1, 3, 4 )
    assert.false mm.segment.isSegmentCompletelyInsideCircle(3, 3, 2, 1, 1, -1, -1 )


describe "math.getRoot", ->
  it " :: Returns the nth root to x, given n and x.", ->
    math = mm.math
    assert.multipleFUzzyEqual {math.getRoot(4, 2)}, {2}
    assert.multipleFUzzyEqual {math.getRoot(16, 2)}, {4}
    assert.multipleFUzzyEqual {math.getRoot(4, -2)}, {.5}


describe "math.isPrime", ->
  it " :: Returns true if a number is prime.", ->
    math = mm.math
    assert.true math.isPrime 3
    assert.true math.isPrime 2
    assert.true math.isPrime 47
    assert.false math.isPrime 1
    assert.false math.isPrime 100

describe "math.round", ->
  it " :: Returns tnumber rounded.", ->
    math = mm.math
    assert.equal math.round(3.4), 3
    assert.equal math.round(6.7), 7
    assert.equal math.round(197.88, 2), 197.88
    assert.equal math.round(197.88, 1), 197.9
    assert.equal math.round(197.88, -2), 200 

describe "math.getSummation", ->
  it " :: Adds up numbers and such.", ->
    math = mm.math
    assert.equal math.getSummation(1, 10, (i) -> return (i*2)), 110
    assert.equal math.getSummation(1, 2, (i) -> return (i*2)), 6
    assert.equal math.getSummation(1, 5, ( i, t ) ->
      if t[i-1] 
        return i + t[i-1] 
      else 
        return 1 ), 35

describe "math.getPercentOfChange", ->
  it " :: Gives the percentage of change.", ->
    math = mm.math
    assert.equal math.getPercentOfChange(2, 4), 1
    assert.equal math.getPercentOfChange(4, 2), -.5
    assert.equal math.getPercentOfChange(4, 0), -1
    assert.equal math.getPercentOfChange(0, 0), 0
    assert.equal math.getPercentOfChange(0, 3), 1/0


describe "math.getPercentage", ->
  it " :: Gives the percent.", ->
    math = mm.math
    assert.equal math.getPercentage(1, 2), 2
    assert.equal math.getPercentage(2, 1), 2
    assert.equal math.getPercentage(.5, 50), 25
    assert.equal math.getPercentage(50, 2), 100
    assert.equal math.getPercentage(-.5, 4), -2

describe "math.getQuadraticRoots", ->
  it " :: Gives roots given a, b, and c.", ->
    math = mm.math
    assert.multipleFUzzyEqual { math.getQuadraticRoots(1, -3, -4) }, {-1, 4}
    assert.multipleFUzzyEqual { math.getQuadraticRoots(1, 0, -4) }, {-2, 2}
    assert.multipleFUzzyEqual { math.getQuadraticRoots(6, 11, -35) }, {-3.5, 5/3}

    assert.false math.getQuadraticRoots(1, 2, 4)
    assert.false math.getQuadraticRoots(.6, .3, .9)

describe "math.getAngle", ->
  it " :: Gives roots given a, b, and c.", ->
    math = mm.math
    assert.fuzzyEqual math.getAngle(1, 3, 1, 1, 3, 1), 1.57079633
    assert.fuzzyEqual math.getAngle(4, 4, 1, 1, 4, 1), 0.785398163


describe "circle.getArea", ->
  it " :: Gives the area of the circle.", ->
    circle = mm.circle
    assert.fuzzyEqual circle.getArea(1), 3.14159
    assert.fuzzyEqual circle.getArea(2), 12.56637
    assert.fuzzyEqual circle.getArea(5), 78.53981
    assert.fuzzyEqual circle.getArea(10), 314.15926
    assert.fuzzyEqual circle.getArea(20), 1256.63706


describe "circle.getCircumference", ->
  it " :: Gives the circumference of the circle.", ->
    circle = mm.circle
    assert.fuzzyEqual circle.getCircumference(1), 6.28318
    assert.fuzzyEqual circle.getCircumference(2), 12.56637
    assert.fuzzyEqual circle.getCircumference(5), 31.41592
    assert.fuzzyEqual circle.getCircumference(10), 62.83185
    assert.fuzzyEqual circle.getCircumference(20), 125.66370

describe "circle.getCircleIntersection", ->
  it " :: Returns \'Equal\' if the circles are the same.", ->
    circle = mm.circle
    assert.equal circle.getCircleIntersection( 0, 0, 4, 0, 0, 4 ), 'equal'

  it " :: Returns \'collinear\' if circles have same x and y but not radii.", ->
    circle = mm.circle
    assert.equal circle.getCircleIntersection( 0, 0, 4, 0, 0, 8 ), 'collinear'
    assert.equal circle.getCircleIntersection( 0, 0, 8, 0, 0, 4 ), 'collinear'

  it " :: Returns \'inside\' if the circles are inside but not touching one another.", ->
    circle = mm.circle
    assert.equal circle.getCircleIntersection( 1, 1, 2, 2, 1, 4 ), 'inside'

  it " :: Returns false if the point is not within the cirlce.", ->
    circle = mm.circle
    assert.false circle.getCircleIntersection( 4, 4, 1, 6, 6, 1 )


describe "circle.isCircleCompletelyInside", ->
  it " :: Returns if a circle is completely inside of another circle.", ->
    circle = mm.circle
    assert.true circle.isCircleCompletelyInside( 1, 1, 2, 2, 1, 4 )
    assert.true circle.isCircleCompletelyInside( 1, 1, 3, 2, 1, 4 )
    assert.false circle.isCircleCompletelyInside( 8, 2, .1, 2, 1, 4 )


describe "polygon.getTriangleHeight", ->
  it " :: Given points of triangle and length of base.", ->
    polygon = mm.polygon
    assert.multipleFUzzyEqual {polygon.getTriangleHeight( 3, 0, 0, 0, 4, 3, 0 )}, {4, 6}
    assert.multipleFUzzyEqual {polygon.getTriangleHeight( 6, -2, 1, 2, 4, 4, 1 )}, {3, 9}
    assert.multipleFUzzyEqual {polygon.getTriangleHeight( 3, 1, 1, 3, 4, 0, 4 )}, {3, 4.5}

  it " :: Given the length of the base and the area.", ->
    polygon = mm.polygon
    assert.fuzzyEqual polygon.getTriangleHeight( 3, 6 ), 4 
    assert.fuzzyEqual polygon.getTriangleHeight( 6, 9 ), 3

describe "polygon.getSignedArea", ->
  it " :: Gives the sigend area of the shape. Positive if clockwise.", ->
    polygon = mm.polygon
    assert.fuzzyEqual polygon.getSignedArea( 0, 0, 3, 0, 3, 4, 0, 4 ), 12
    assert.fuzzyEqual polygon.getSignedArea( 0, 0, 3, 0, 0, 4 ), 6
    assert.fuzzyEqual polygon.getSignedArea( 4, 4, 0, 4, 0, 0, 4, 0 ), 16

  it " :: Negative if counter clock-wise.", ->
    polygon = mm.polygon
    assert.fuzzyEqual polygon.getSignedArea( 0, 0, 0, 4, 3, 4, 3, 0 ), -12
    assert.fuzzyEqual polygon.getSignedArea( 0, 0, 0, 4, 3, 0 ), -6


describe "polygon.getArea", ->
  it " :: Gives the sigend area of the shape. Positive if clockwise.", ->
    polygon = mm.polygon
    assert.fuzzyEqual polygon.getArea( 0, 0, 3, 0, 3, 4, 0, 4 ), 12
    assert.fuzzyEqual polygon.getArea( 0, 0, 3, 0, 0, 4 ), 6
    assert.fuzzyEqual polygon.getArea( 4, 4, 0, 4, 0, 0, 4, 0 ), 16

  it " :: Gives the area of the shape. Negative if counter clock-wise.", ->
    polygon = mm.polygon
    assert.fuzzyEqual polygon.getArea( 0, 0, 0, 4, 3, 4, 3, 0 ), 12
    assert.fuzzyEqual polygon.getArea( 0, 0, 0, 4, 3, 0 ), 6

describe "polygon.getCentroid", ->
  it " :: Gives the x and y of the centroid.", ->
    polygon = mm.polygon
    assert.multipleFUzzyEqual {polygon.getCentroid( 0, 0, 0, 4, 4, 4, 4, 0 )}, { 2, 2 }
    assert.multipleFUzzyEqual {polygon.getCentroid( 0, 0, 0, 6, 3, 0 ) }, { 1, 2 } 
    assert.multipleFUzzyEqual {polygon.getCentroid( 2, -1, 2, 1, 1, 2, -1, 2, -2, 1, -2, -1, -1, -2, 1, -2 ) }, { 0, 0 }
    assert.multipleFUzzyEqual {polygon.getCentroid( 2, 0, 3, 0, 4, 1, 3, 2, 2, 2, 1, 1 ) }, { 2.5, 1 }
    assert.multipleFUzzyEqual {polygon.getCentroid( 3, 5, 2, 2, 4, 2 ) }, { 3, 3 }
    
describe "polygon.isSegmentInside", ->
  it " :: Returns true if the segment is fully inside the polygon.", ->
    polygon = mm.polygon
    assert.true polygon.isSegmentInside( 4, 4, 4, 5, 4, 3, 2, 5, 3, 6, 5, 6, 6, 5 )
    assert.false polygon.isSegmentInside( 6, 3, 7, 6, 4, 3, 2, 5, 3, 6, 5, 6, 6, 5 )

  it " :: True if at least part of the segment is on/inside.", ->
    polygon = mm.polygon
    assert.true polygon.isSegmentInside( 6, 3, 4, 5, 4, 3, 2, 5, 3, 6, 5, 6, 6, 5 )

describe "polygon.getPolygonIntersection", ->
  it " :: Returns true if the polygons intersect.", ->
    polygon = mm.polygon
    tab = polygon.getPolygonIntersection( { 2, 6, 3, 8, 4, 6 }, { 3, 7, 2, 9, 4, 9 } )
    assert.tablesFuzzyEqual tab, { { 2.75, 7.5 }, { 3.25, 7.5 } }
    tab = polygon.getPolygonIntersection( { 3, 5, 4, 4, 3, 3, 2, 3, 1, 4, 1, 2, 3, 2, 5, 4, 3, 6, 1, 6 }, { 0, 6, 4, 5, 2, 4 } )
    assert.tablesFuzzyEqual tab, { { 3.33333, 4.66666 }, { 4, 5 }, { 2, 5.5 } }
    
  it " :: Returns false if the polygons don\'t intersect.", ->
    polygon = mm.polygon
    assert.false polygon.getPolygonIntersection( { 2, 6, 3, 8, 4, 6 }, { 4, 7, 3, 9, 5, 9 } )
    assert.false polygon.getPolygonIntersection( { 3, 5, 4, 4, 3, 3, 2, 3, 1, 4, 1, 2, 3, 2, 5, 4, 3, 6, 1, 6 }, { 0, 6, 3, 4, 2, 4 } )

  it " :: Works with vertical lines.", ->
    polygon = mm.polygon
    tab = polygon.getPolygonIntersection( { 2, 3, 2, 6, 4, 6, 4, 4, 5, 5, 5, 3 }, { 3, 2, 3, 5, 6, 4, 6, 3, 4, 3, 4, 2 } )
    assert.tablesFuzzyEqual tab, { { 4, 4.66666 }, { 4.5, 4.5 }, { 5, 4.33333 }, { 5, 3 }, { 3, 3 }, { 4, 3 } }


describe "polygon.getCircleIntersection", ->
  it " :: Returns true if the circle intersects", ->
    polygon = mm.polygon
    tab = polygon.getCircleIntersection( 3, 5, 2, 3, 1, 3, 6, 7, 4 )
    assert.tablesFuzzyEqual tab, { { 'tangent', 3, 3 }, { 'tangent', 5, 5 } }

    tab = polygon.getCircleIntersection( 5, 5, 1, 4, 4, 6, 4, 6, 6, 4, 6 )
    assert.tablesFuzzyEqual tab, { { 'tangent', 5, 4 }, { 'tangent', 6, 5 }, { 'tangent', 5, 6 }, { 'tangent', 4, 5 } }

    tab = polygon.getCircleIntersection( 3, 4, 2, 3, 3, 2, 4, 3, 5, 4, 4 )
    assert.tablesFuzzyEqual tab, { { 'enclosed', 3, 3, 2, 4 }, { 'enclosed', 2, 4, 3, 5 }, { 'enclosed', 3, 5, 4, 4 }, { 'enclosed', 4, 4, 3, 3 } }

  it " :: Returns false if the circle doesn\'t intersect.", ->
    polygon = mm.polygon
    assert.false polygon.getCircleIntersection( 9, 9, 2, 3, 1, 3, 6, 7, 4 )
    assert.false polygon.getCircleIntersection( 10, 5, 1, 4, 4, 6, 4, 6, 6, 4, 6 )


describe "polygon.isPolygonInside", ->
  it " :: Returns true if polygon2 is inside", ->
    polygon = mm.polygon

    assert.false polygon.isPolygonInside( { 0, 0, 0, 4, 4, 4, 4, 0 }, { 5, 5, 5, 7, 7, 7, 7, 5 } )
    assert.true polygon.isPolygonInside( { 0, 0, 0, 4, 4, 4, 4, 0 }, { 2, 2, 2, 3, 3, 3, 3, 2 } )

describe "polygon.isPolygonCompletelyInside", ->
  it " :: Returns if a polygon is completely inside of a polygon", ->
    polygon = mm.polygon
    assert.true polygon.isPolygonCompletelyInside( { -.5, 0, 0, .5, .5, 0, 0, -.5 }, { -.5, -.5, -1, -.5, -1, .5, -.5, .5, -.5, 1, .5, 1, .5, .5, 1, .5, 1, -.5, .5, -.5, .5, -1 } )
    assert.false polygon.isPolygonCompletelyInside( { -.5, 0, 0, 1, .5, 0, 0, -.5 }, { -.5, -.5, -1, -.5, -1, .5, -.5, .5, -.5, 1, .5, 1, .5, .5, 1, .5, 1, -.5, .5, -.5, .5, -1 } )
    assert.false polygon.isPolygonCompletelyInside( { 0, .5, .5, 1, 1, .5, .5, 0 }, { -.5, -.5, -1, -.5, -1, .5, -.5, .5, -.5, 1, .5, 1, .5, .5, 1, .5, 1, -.5, .5, -.5, .5, -1 } )

describe "polygon.isCircleCompletelyOver", ->
  it " :: Returns if a polygon is completely within a circle", ->
    polygon = mm.polygon
    assert.true polygon.isCircleCompletelyOver( 4, 2, 2.69, 4, 1, 2, 3, 3, 3, 6, 1, 4, 0 )
    assert.false polygon.isCircleCompletelyOver( 4, 2, 1, 4, 1, 2, 3, 3, 3, 6, 1, 4, 0 )
    assert.false polygon.isCircleCompletelyOver( 9, 2, 2.69, 4, 1, 2, 3, 3, 3, 6, 1, 4, 0 )

describe "polygon.isCircleCompletelyInside", ->
  it " :: Returns if a circle is completely inside of a polygon", ->
    polygon = mm.polygon
    assert.true polygon.isCircleCompletelyInside( 0, 0, .2, -.5, 0, 0, .5, .5, 0, 0, -.5 )
    assert.false polygon.isCircleCompletelyInside( .2, .2, .2, -.5, 0, 0, .5, .5, 0, 0, -.5 ) 
    assert.false polygon.isCircleCompletelyInside( 0, 0, .4, -.5, 0, 0, .5, .5, 0, 0, -.5 )
    assert.false polygon.isCircleCompletelyInside( 0, 0, .5, -.5, 0, 0, .5, .5, 0, 0, -.5 )
    assert.false polygon.isCircleCompletelyInside( 0, 0, 1, -.5, 0, 0, .5, .5, 0, 0, -.5 )
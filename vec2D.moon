vec2D = {}

math = math

META = {
  __tostring: (v) -> return string.format("vec2(%s,%s)",v.x,v.y)
  __le: (lhs, rhs) -> return lhs.x <= rhs.x and lhs.y <= rhs.y
  __lt: (lhs, rhs) -> return lhs.x < rhs.x and lhs.y < rhs.y
  __eq: (lhs, rhs) -> return lhs.x == rhs.x and lhs.y == rhs.y
}

with vec2D

  -- Creates a ZERO vector2D
  -- @treturn vec2D
  .ZERO = ->
    vec = {x: 0, y: 0}
    setmetatable(vec, META)

  -- Creates a vector from a table
  -- @tparam table v (Asumes x in [1] and y in [2])
  -- @treturn vec2D
  .from = (v) ->
    local x, y
    x = v.x and v.x or v[1]
    y = v.y and v.y or v[2]
    vec = {:x, :y}
    setmetatable(vec, META)

  -- Sets a vec2D from two numbers 
  -- @tparam vec2D v
  -- @tparam number x
  -- @tparam number y
  .set = (v, x, y) ->
    v.x = x
    v.y = y

  -- Sets a vec2D from another vec2D
  -- @tparam vec2D v
  -- @tparam vec2D sv
  .setFrom = (v, sv) ->
    v.x = sv.x
    v.y = sv.y

  -- Adds two vectors or a num to a vec2D
  -- @tparam vec2D v
  -- @tparam vec2D/number v1
  .add = (v, v1) ->
    v.x = v.x + v1.x
    v.y = v.y + v1.y

  -- Adds a scalar to a vec2D
  -- @tparam vec2D v
  -- @tparam number s
  .addS = (v, s) ->
    v.x = v.x + s
    v.y = v.y + s

  -- Adds two vectors and sets a vec2D
  -- @tparam vec2D v
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .sum = (v, v1, v2) ->
    v.x = v1.x + v2.x
    v.y = v1.y + v2.y

  -- Makes a vec2D from the sum of two others
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .makeSum = (v1, v2) ->
    vec = {
      x: v1.x + v2.x
      y: v1.y + v2.y
    }
    setmetatable(vec, META)
  
  -- Subs a vec2D or a num from a vec2D
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .sub = (v, v1) ->
    v.x = v.x - v1.x
    v.y = v.y - v1.y

  -- Subs a scalar from a vec2D
  -- @tparam vec2D v
  -- @tparam number s
  .subS = (v, s) ->
    v.x = v.x - s
    v.y = v.y - s

  -- Subs two vec2Ds and create a new vec2D from result
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .makeSub = (v1, v2) ->
    vec = {
      x: v1.x - v2.x
      y: v1.y - v2.y
    }
    setmetatable(vec, META)

  -- multiplies two vec2Ds/vec2D*number
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .mul = (v1, v2) ->
    v.x = v.x * v1.x
    v.y = v.y * v1.y

  -- multiplies a vec2D by a scalar
  -- @tparam vec2D v
  -- @tparam number v1
  .mulS = (v, s) ->
    v.x = v.x * s
    v.y = v.y * s

  -- Multiplies two vec2Ds and create a new vec2D from result
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .makeMul = (v1, v2) ->
    vec = {
      x: v1.x * v2.x
      y: v1.y * v2.y
    }
    setmetatable(vec, META)

  -- divides two vec2Ds/(vec2D/number) trusts the dev to not div by 0
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .div = (v1, v2) ->
    v.x = v.x / v1.x
    v.y = v.y / v1.y

  -- divides vec2D by scalar
  -- @tparam vec2D v
  -- @tparam number s
  .divS = (v, s) ->
    v.x = v.x / s
    v.y = v.y / s

  -- modulus of two vec2Ds/(vec2D%number)
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .mod = (v1, v2) ->
    v.x = v.x % v1.x 
    v.y = v.y % v1.y

  -- modulus vec2D % scalar
  -- @tparam vec2D v
  -- @tparam number s
  .modS = (v, s) ->
    v.x = v.x * s
    v.y = v.y * s

  -- power of two vec2Ds/(vec2D%number)
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .pow = (v1, v2) ->
    v.x = v.x ^ (v1.x or v1)
    v.y = v.y ^ (v1.y or v1)

  -- power of vec2D
  -- @tparam vec2D v
  -- @tparam number s
  .modS = (v, s) ->
    v.x = v.x ^ s
    v.y = v.y ^ s

  -- scales a vec2D
  -- @tparam vec2D v1
  -- @tparam number num
  .scale = (v, num) ->
    v.x = v.x * num
    v.y = v.y * num

  -- scales a vec2D and creates a new vec2D from result
  -- @tparam vec2D v1
  -- @tparam number num
  .makeScale = (v1, num) ->
    vec = {
      x: v.x * num
      y: v.y * num
    }
    setmetatable(vec, META)

  -- cross product
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .crossProd = (v1, v2) ->
    v1.x* v2.y- v1.y* v2.x

  -- dot product
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .dotProd = (v1, v2) ->
    v1.x* v2.x+ v1.y* v2.y

  -- length
  -- @tparam vec2D v1
  .length = (v1) ->
    math.sqrt v1.x*v1.x + v1.y*v1.y

  -- length^2
  -- @tparam vec2D v1
  .sqlength = (v1) ->
    v1.x*v1.x + v1.y*v1.y

  -- distance vetween two vec2Ds
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .dist = (v1, v2) ->
    vec2D.length {
      x: v2.x - v1.x 
      y: v2.y - v1.y
    }


  .normalize = (v) ->
    tmp = 1 / vec2D.length(v)
    v.x = v.x * tmp
    v.y = v.y * tmp

  .makeNormalized = (v) ->
    tmp = 1 / vec2D.length(v)
    vec = {
      x: v.x * tmp
      y: v.y * tmp
    }
    setmetatable(vec, META)

  .rotate = (v, angle) ->
    tmpVx = v.x
    v.x = v.x * math.cos(angle) - v.y * math.sin(angle)
    v.y = tmpVx * math.sin(angle) + v.y * math.cos(angle)

  .makeRotated = (v, angle) ->
    tmpVx = v.x
    vec = {
      x: v.x * math.cos(angle) - v.y * math.sin(angle)
      y: tmpVx * math.sin(angle) + v.y * math.cos(angle)
    }
    setmetatable(vec, META)

  .makeFromAngle = (angle) ->
    vec = {
      x: math.cos angle
      y: math.sin angle
    }
    setmetatable(vec, META)


return vec2D
vec2D = {}

math = math

META = {
  __tostring: (v) -> return string.format("vec2(%s,%s)",v[1],v[2])
  __le: (lhs, rhs) -> return lhs[1] <= rhs[1] and lhs[2] <= rhs[2]
  __lt: (lhs, rhs) -> return lhs[1] < rhs[1] and lhs[2] < rhs[2]
  __eq: (lhs, rhs) -> return lhs[1] == rhs[1] and lhs[2] == rhs[2]
}

with vec2D

  -- Creates a ZERO vector2D
  -- @treturn vec2D
  .ZERO = ->
    vec = {0, 0}
    setmetatable(vec, META)

  -- Creates a vector from a table
  -- @tparam table v (Asumes x in [1] and y in [2])
  -- @treturn vec2D
  .from = (v) ->
    local x, y
    x = v[1] and v[1] or v[1]
    y = v[2] and v[2] or v[2]
    vec = {x, y}
    setmetatable(vec, META)

  -- Sets a vec2D from two numbers 
  -- @tparam vec2D v
  -- @tparam number x
  -- @tparam number y
  .set = (v, x, y) ->
    v[1] = x
    v[2] = y

  -- Sets a vec2D from another vec2D
  -- @tparam vec2D v
  -- @tparam vec2D sv
  .setFrom = (v, sv) ->
    v[1] = sv[1]
    v[2] = sv[2]

  -- Adds two vectors or a num to a vec2D
  -- @tparam vec2D v
  -- @tparam vec2D/number v1
  .add = (v, v1) ->
    v[1] = v[1] + v1[1]
    v[2] = v[2] + v1[2]

  -- Adds a scalar to a vec2D
  -- @tparam vec2D v
  -- @tparam number s
  .addS = (v, s) ->
    v[1] = v[1] + s
    v[2] = v[2] + s

  -- Adds two vectors and sets a vec2D
  -- @tparam vec2D v
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .sum = (v, v1, v2) ->
    v[1] = v1[1] + v2[1]
    v[2] = v1[2] + v2[2]

  -- Makes a vec2D from the sum of two others
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .makeSum = (v1, v2) ->
    vec = {
      x: v1[1] + v2[1]
      y: v1[2] + v2[2]
    }
    setmetatable(vec, META)
  
  -- Subs a vec2D or a num from a vec2D
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .sub = (v, v1) ->
    v[1] = v[1] - v1[1]
    v[2] = v[2] - v1[2]

  -- Subs a scalar from a vec2D
  -- @tparam vec2D v
  -- @tparam number s
  .subS = (v, s) ->
    v[1] = v[1] - s
    v[2] = v[2] - s

  -- Subs two vec2Ds and create a new vec2D from result
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .makeSub = (v1, v2) ->
    vec = {
      x: v1[1] - v2[1]
      y: v1[2] - v2[2]
    }
    setmetatable(vec, META)

  -- multiplies two vec2Ds/vec2D*number
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .mul = (v1, v2) ->
    v[1] = v[1] * v1[1]
    v[2] = v[2] * v1[2]

  -- multiplies a vec2D by a scalar
  -- @tparam vec2D v
  -- @tparam number v1
  .mulS = (v, s) ->
    v[1] = v[1] * s
    v[2] = v[2] * s

  -- Multiplies two vec2Ds and create a new vec2D from result
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .makeMul = (v1, v2) ->
    vec = {
      x: v1[1] * v2[1]
      y: v1[2] * v2[2]
    }
    setmetatable(vec, META)

  -- divides two vec2Ds/(vec2D/number) trusts the dev to not div by 0
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .div = (v1, v2) ->
    v[1] = v[1] / v1[1]
    v[2] = v[2] / v1[2]

  -- divides vec2D by scalar
  -- @tparam vec2D v
  -- @tparam number s
  .divS = (v, s) ->
    v[1] = v[1] / s
    v[2] = v[2] / s

  -- modulus of two vec2Ds/(vec2D%number)
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .mod = (v1, v2) ->
    v[1] = v[1] % v1[1] 
    v[2] = v[2] % v1[2]

  -- modulus vec2D % scalar
  -- @tparam vec2D v
  -- @tparam number s
  .modS = (v, s) ->
    v[1] = v[1] * s
    v[2] = v[2] * s

  -- power of two vec2Ds/(vec2D%number)
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .pow = (v1, v2) ->
    v[1] = v[1] ^ (v1[1] or v1)
    v[2] = v[2] ^ (v1[2] or v1)

  -- power of vec2D
  -- @tparam vec2D v
  -- @tparam number s
  .modS = (v, s) ->
    v[1] = v[1] ^ s
    v[2] = v[2] ^ s

  -- scales a vec2D
  -- @tparam vec2D v1
  -- @tparam number num
  .scale = (v, num) ->
    v[1] = v[1] * num
    v[2] = v[2] * num

  -- scales a vec2D and creates a new vec2D from result
  -- @tparam vec2D v1
  -- @tparam number num
  .makeScale = (v1, num) ->
    vec = {
      x: v[1] * num
      y: v[2] * num
    }
    setmetatable(vec, META)

  -- cross product
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .crossProd = (v1, v2) ->
    v1[1]* v2[2]- v1[2]* v2[1]

  -- dot product
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .dotProd = (v1, v2) ->
    v1[1]* v2[1]+ v1[2]* v2[2]

  -- length
  -- @tparam vec2D v1
  .length = (v1) ->
    math.sqrt (v1[1]*v1[1]) + (v1[2]*v1[2])

  -- length^2
  -- @tparam vec2D v1
  .sqlength = (v1) ->
    v1[1]*v1[1] + v1[2]*v1[2]

  -- distance vetween two vec2Ds
  -- @tparam vec2D v1
  -- @tparam vec2D v2
  .dist = (v1, v2) ->
    vec2D.length {
      x: v2[1] - v1[1] 
      y: v2[2] - v1[2]
    }


  .normalize = (v) ->
    tmp = 1 / vec2D.length(v)
    v[1] = v[1] * tmp
    v[2] = v[2] * tmp

  .makeNormalized = (v) ->
    tmp = 1 / vec2D.length(v)
    vec = {
      x: v[1] * tmp
      y: v[2] * tmp
    }
    setmetatable(vec, META)

  .rotate = (v, angle) ->
    tmpVx = v[1]
    v[1] = v[1] * math.cos(angle) - v[2] * math.sin(angle)
    v[2] = tmpVx * math.sin(angle) + v[2] * math.cos(angle)

  .makeRotated = (v, angle) ->
    tmpVx = v[1]
    vec = {
      x: v[1] * math.cos(angle) - v[2] * math.sin(angle)
      y: tmpVx * math.sin(angle) + v[2] * math.cos(angle)
    }
    setmetatable(vec, META)

  .makeFromAngle = (angle) ->
    vec = {
      x: math.cos angle
      y: math.sin angle
    }
    setmetatable(vec, META)


return vec2D
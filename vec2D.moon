vec2D = {}


META = {
  __tostring: (v) -> return string.format("vec2(%s,%s)",v.x,v.y)
  __le: (lhs, rhs) -> return lhs.x <= rhs.x and lhs.y <= rhs.y
	__lt: (lhs, rhs) -> return lhs.x < rhs.x and lhs.y < rhs.y
	__eq: (lhs, rhs) -> return lhs.x == rhs.x and lhs.y == rhs.y
}

with vec2D

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

  .set = (v, x, y) ->
    v.x = x
    v.y = y

  .setFrom = (v, sv) ->
    v.x = sv.x
    v.y = sv.y

  .add = (v, v1) ->
    v.x = v.x + (v1.x or v1)
    v.y = v.y + (v1.y or v1)

  .sum = (v, v1, v2) ->
    v.x = v1.x + v2.x
    v.y = v1.y + v2.y

  .makeSum = (v1, v2) ->
    vec = {
      x: v1.x + v2.x
      y: v1.y + v2.y
    }
    setmetatable(vec, META)
  
  .sub = (v, v1) ->
    v.x = v.x - (v1.x or v1)
    v.y = v.y - (v1.y or v1)

  .makeSub = (v1, v2) ->
    vec = {
      x: v1.x - v2.x
      y: v1.y - v2.y
    }
    setmetatable(vec, META)

  .mul = (v1, v2) ->
    v.x = v.x * (v1.x or v1)
    v.y = v.y * (v1.y or v1)

  .div = (v1, v2) ->
    v.x = v.x / (v1.x or v1)
    v.y = v.y / (v1.y or v1)

  .mod = (v1, v2) ->
    v.x = v.x % (v1.x or v1)
    v.y = v.y % (v1.y or v1)

  .pow = (v1, v2) ->
    v.x = v.x ^ (v1.x or v1)
    v.y = v.y ^ (v1.y or v1)

  .scale = (v, num) ->
    v.x = v.x * num
    v.y = v.y * num

  .makeScale = (v1, num) ->
    vec = {
      x: v.x * num
      y: v.y * num
    }
    setmetatable(vec, META)

  .crossProd = (v1, v2) ->
    v1.x* v2.y- v1.y* v2.x

  .dotProd = (v1, v2) ->
    v1.x* v2.x+ v1.y* v2.y










return vec2D
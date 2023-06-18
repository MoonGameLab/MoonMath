vec2D = {}




with vec2D

  -- Creates a vector from a table
  -- @tparam table v (Asumes x in [1] and y in [2])
  -- @treturn vec2D
  .from = (v) ->
    local x, y
    x = v.x and v.x or v[1]
    y = v.y and v.y or v[2]
    {x: x, y: y}











return vec2D
-- Code for unit.start()
local seed  = 17   --export: random number seed
local speed = 0.5  --export: speed of change
step = 0
math.randomseed(seed)
unit.setTimer("Live", speed)

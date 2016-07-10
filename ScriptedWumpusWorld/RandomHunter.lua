-- Random Wumpus Hunter script

--enum HunterAction: Int32 {
--    case MoveLeft,
--    MoveRight,
--    MoveUp,
--    MoveDown,
--    ShootLeft,
--    ShootRight,
--    ShootUp,
--    ShootDown,
--    PickUp,
--    Exit
--}

--    0 MoveLeft
--    1 MoveRight
--    2 MoveUp
--    3 MoveDown
--    4 ShootLeft
--    5 ShootRight
--    6 ShootUp
--    7 ShootDown
--    8 PickUp
--    9 Exit

function get_action(smell, breeze, glitter, bumped, scream)
  print("smell", smell)
  print("breeze", breeze)
  print("glitter", glitter)
  print("bumped", bumped)
  print("scream", scream)
  
  return math.floor(math.random() * 10)
end

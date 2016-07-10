-- Sample Wumpus Hunter script

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

commands = {}
commands[1] = 3
commands[2] = 3
commands[3] = 1
commands[4] = 2
commands[5] = 5

command_counter = 0

function get_action(smell, breeze, glitter, bumped, scream)
  print("smell", smell)
  print("breeze", breeze)
  print("glitter", glitter)
  print("bumped", bumped)
  print("scream", scream)
  
  -- return math.floor(math.random() * 10)
  command_counter = command_counter + 1
  return commands[command_counter]
end

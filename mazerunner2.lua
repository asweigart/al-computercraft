while true do
  if turtle.getFuelLevel() == 0 then
    return
  end

  while true do
    turtle.turnLeft()
    if not turtle.detect() then
      print('Moving left.')
      break
    end
    turtle.turnRight()
    if not turtle.detect() then
      print('Moving forward.')
      break
    end
    turtle.turnRight()
    if not turtle.detect() then
      print('Moving right.')
      break
    end
    turtle.turnRight()
    print('Moving back.')
    break
  end
  
  turtle.forward()
end

while true do
  if turtle.getFuelLevel() == 0 then
    return
  end
  
  turtle.turnLeft()
  if not turtle.detect() then
    print('Moving left.')
    turtle.forward()
  else
    turtle.turnRight()
    if not turtle.detect() then
      print('Moving forward.')
      turtle.forward()
    else
      turtle.turnRight()
      if not turtle.detect() then
        print('Moving right.')
        turtle.forward()
      else
        turtle.turnRight()
        print('Moving back.')
        turtle.forward()
      end
    end
  end
end


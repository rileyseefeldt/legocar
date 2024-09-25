%brick = ConnectBrick('ASU_PD_VAN_8');

% Close the claw on start
brick.GyroCalibrate(4);
brick.MoveMotor('A',-30);
pause(0.2);

keepMoving = 0; %change to 0 to kill
brick.StopAllMotors();

while(keepMoving == 1) %move as long as button not pressed
  brick.MoveMotor('D',-50);
  brick.MoveMotor('B',-50);
  
  distance = brick.UltrasonicDist(2);

  if (brick.TouchPressed(3) == 1) %when the button on the claw is pressed
    brick.StopAllMotors();

    reactHitWall(brick);
    
  elseif (distance > 60) %when there is no wall on the right
    reactNoWall(brick);
  end
  
end

function reactHitWall(brick) %when the robot hits a wall
  brick.StopAllMotors();
  brick.MoveMotor('D',25);
  brick.MoveMotor('B',25); %move back
  pause(1);
  brick.MoveMotor('A',-30); %close claw
  pause(0.2);
  turnLeftPrecise(brick); %turn left until -90 degrees
  brick.StopAllMotors();
end

function reactNoWall(brick)
  brick.GyroCalibrate(4);
  pause(0.4);
  brick.StopAllMotors();
  turnRightPrecise(brick);
  brick.MoveMotor('A',-30);
  pause(0.2);
  brick.MoveMotor('D',-50); %keep moving forward
  brick.MoveMotor('B',-50);
  pause(2.25);
  brick.StopAllMotors();
end


function turnRightPrecise(brick) %direction should be 1 or -1; -1 is left, 1 is right
  pause(0.25);
  brick.GyroCalibrate(4); %reset the gyroscope to 0
  pause(0.25)
  while(brick.GyroAngle(4) < (90 + 2)) %while the current angle is 2 more or less than the desired angle...
    turnRight(brick);
  end
  brick.StopAllMotors(); %stop all motors when reached desired angle
end

function turnLeftPrecise(brick) %direction should be 1 or -1; -1 is left, 1 is right
  pause(0.25);
  brick.GyroCalibrate(4); %reset the gyroscope to 0
  pause(0.25);
  while(brick.GyroAngle(4) > (-85 + 2)) %while the current angle is 2 more or less than the desired angle...
    turnLeft(brick);
  end
  brick.StopAllMotors(); %stop all motors when reached desired angle
end

function turnUntilAngle(brick, angle) %direction should be 1 or -1; -1 is left, 1 is right
  brick.GyroCalibrate(4); %reset the gyroscope to 0
  pause(0.5);
  while(brick.GyroAngle(4) - angle > 2) %while the current angle is 5 more or less than the desired angle...
    brick.MoveMotor('D', -1 * direction * 20);
    brick.MoveMotor('B', direction * 20); %rotate the robot
    if(brick.GyroAngle(4) - angle <= 2)
      brick.StopAllMotors(); %stop all motors when reached desired angle
      break;
    end
  end
end

function turnUntilAngle2(brick, angle)
  brick.GyroCalibrate(4); %reset the gyroscope to 0
  pause(0.5);

  while(mod(abs(brick.GyroAngle(4)), 360) >= (angle-5)) %while the current angle is 5 more or less than the desired angle...
    turnRight(brick);
  end
    brick.StopAllMotors(); %stop all motors when reached desired angle
end

% brick = ConnectBrick('ASU_PD_VAN_8');
% A: Claw motor
% B: Right wheel motor
% D: Left wheel motor
% found = false;
% while(~ found) % move as long as button not pressed
%   moveAlongWall(brick);
% end

function moveAlongWall(brick)
  move(brick)
  while (~ isTouchingWall(brick) && ~ isOffWall(brick))
    pause(0.1);
  end
  stopMotors(brick);
  if (isTouchingWall(brick))
    reactHitWall(brick);
  elseif (distance > 60)
    reactNoWall(brick);
  end
end

function stopMotors(brick)
  brick.StopAllMotors();
end

function x = isOffWall(brick)
  x = brick.UltrasonicDist(2) > 60;
end

function x = isTouchingWall(brick)
  x = brick.TouchPressed(3) == 1;
end

function move(brick)
  brick.MoveMotor('D', -50);
  brick.MoveMotor('B', -50);
end

function moveBackward(brick)
  brick.MoveMotor('D', 50);
  brick.MoveMotor('B', 50);
end

function turnLeft(brick)
  brick.MoveMotor('D',25);
  brick.MoveMotor('B',-25);
end

function turnRight(brick)
  brick.MoveMotor('D',-25);
  brick.MoveMotor('B',25);
end
  



% Team 4
% Thomas Kennedy, Seva Gaskov, Riley Seefeldt, Man-Ning Chen

% brick = ConnectBrick('ASU_PD_VAN_8');

%turnRight(brick);
stop(brick);
brick.GyroCalibrate(4);
%turnLeft(brick);

while 0
    moveForward(brick);
    if (~onWall(brick))
        moveAroundWall(brick);
    elseif (frontClear(brick))
        backupAndTurn(brick);
    end
    pause(0.05);
end

function moveAroundWall(brick)
    stop(brick);
    pause(1);
    moveForward(brick);
    pause(1.5);
    stop(brick);

    turnRight(brick);

    moveForward(brick);
    pause(4);
    stop(brick);
end

function backupAndTurn(brick)
    stop(brick);
    pause(2);

    moveBackward(brick);
    pause(2);
    stop(brick);

    turnLeft(brick);
end

function frontIsClear = frontClear(brick)
    frontIsClear = brick.TouchPressed(3);
end

function isOnWall = onWall(brick)
    isOnWall = brick.UltrasonicDist(2) < 50;
end

function moveBackward(brick)
    speed = 25;
    brick.MoveMotor('B', speed);
    brick.MoveMotor('D', speed*1.05);
end

function moveForward(brick)
    speed = -25;
    brick.MoveMotor('B', speed);
    brick.MoveMotor('D', speed*1.05);
end

function turnRight(brick)
    turnUntilAngle(brick, 75);
end

function turnLeft(brick)
    turnUntilAngle(brick, -90);
end

function turnUntilAngle(brick, targetAngle)
    speed = 10;
    error = 2.5;
    brick.GyroCalibrate(4);
    currentAngle = brick.GyroAngle(4);
    %disp(abs(targetAngle - currentAngle))
    while (abs(targetAngle - currentAngle) > error)
        brick.MoveMotor('B', speed);
        brick.MoveMotor('D', -speed);
        if (targetAngle > currentAngle && speed < 0 || targetAngle < currentAngle && speed > 0)
            speed = -speed;
        end
        currentAngle = brick.GyroAngle(4);
        pause(0.05);
    end
    stop(brick);
end

function stop(brick)
    brick.StopAllMotors();
end


function love.load()
	--love.graphics.origin()
	love.graphics.setPointSize(30)
	ball = {
		x = 100,
		y = 100,
		xMax = love.graphics.getWidth(),
		yMax = love.graphics.getHeight(),
		xMin = 1,
		yMin = 1,
		xVel = 100,
		yVel = 50,
		radius = 5,
		update = function (dt)
			ball.x = ball.x + ball.xVel*dt
			ball.y = ball.y + ball.yVel*dt
			if ball.x > ball.xMax or ball.x < ball.xMin then ball.xVel = -ball.xVel end
			if ball.y > ball.yMax or ball.y < ball.yMin then ball.yVel = -ball.yVel end
		end,
		draw = function ()
			love.graphics.circle("fill",ball.x,ball.y,ball.radius)
		end
		}
	ship = {
		Base = love.graphics.newImage("ws-vessel-01.png"),
		xMax = love.graphics.getWidth(),
		yMax = love.graphics.getHeight(),
		angle = 270,
		direction = 0,
		directionAcceleration = 0,
		directionAccelerationModifier = 0.05,
		momentum = 0,
		momentumAcceleteration = 0.05,
		maxMomentum = 5,
		tendancyToZero = 0.01,
		zeroSnapValue = 0.009,
		scale = 0.3
		}
	ship.centreX = ship.xMax/2
	ship.centreY = ship.yMax/2
	ship.posX = ship.centreX
	ship.posY = ship.centreY
	ship.width = ship.Base:getHeight()
	ship.height = ship.Base:getWidth()
end

function lineEquation(x1,y1,x2,y2)
	gradient = (y2-y1)/(x2-x1)
	c = gradient*x1 - y1
	return gradient,c
	
function love.update(dt)
	--love.graphics.points(x,y)
	ball.update(dt)
	
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
	if love.keyboard.isDown('s') then
		if ship.momentum > -ship.maxMomentum then
			ship.momentum = ship.momentum - ship.momentumAcceleteration
		end
	end
	if love.keyboard.isDown('w') then
		if ship.momentum < ship.maxMomentum then
			ship.momentum = ship.momentum + ship.momentumAcceleteration
		end
	end
	if not(ship.momentum == 0) then
		
		if ship.momentum > 0 then
			ship.momentum = ship.momentum - ship.tendancyToZero
		else
			ship.momentum = ship.momentum + ship.tendancyToZero
		end
		if ship.momentum < ship.zeroSnapValue and ship.momentum > -ship.zeroSnapValue then
			ship.momentum = 0
		end
	end
	if love.keyboard.isDown('d') then
		
		ship.directionAcceleration = ship.directionAcceleration + ship.directionAccelerationModifier
	end
	if love.keyboard.isDown('a') then
		ship.directionAcceleration = ship.directionAcceleration - ship.directionAccelerationModifier
	end
	if ship.directionAcceleration > -ship.zeroSnapValue and ship.directionAcceleration < ship.zeroSnapValue then
		ship.directionAcceleration = 0
	end
	ship.direction = ship.direction + ship.directionAcceleration

	if not(ship.directionAcceleration == 0) then
		if ship.directionAcceleration > 0 then
			ship.directionAcceleration = ship.directionAcceleration - ship.tendancyToZero
		else
			ship.directionAcceleration = ship.directionAcceleration + ship.tendancyToZero
		end
	end
	if ship.direction > 360 then
		ship.direction = ship.direction - 360
	end
	if ship.direction < 0 then
		ship.direction = ship.direction + 360
	end
	
	if ship.posX > ball.xMax then
		ship.posX = ball.xMax
	elseif ship.posX < ball.xMin then
		ship.posX = ball.xMin
	end
	if ship.posY > ball.yMax then
		ship.posY = ball.yMax
	elseif ship.posY < ball.yMin then
		ship.posY = ball.yMin
	end
	
	--if ship.momentum > 0 then
	ship.posX = ship.posX + ((math.sin(math.rad(ship.direction)))*ship.momentum)
	ship.posY = ship.posY - ((math.cos(math.rad(ship.direction)))*ship.momentum)
	--elseif ship.momentum < 0 then
		--ship.posX = ship.posX - (math.sin(math.rad(ship.direction))*(0-ship.momentum))
		--ship.posY = ship.posY + (math.cos(math.rad(ship.direction))*(0-ship.momentum))
	--end
	
	print("PosX "..ship.posX)
	print("PosY "..ship.posY)
	print("Direction "..ship.direction)
	print("DirectionAcceleration "..ship.directionAcceleration)
	print("Momentum "..ship.momentum)
	print("sin "..math.sin(math.rad(ship.direction)))
	print("cos "..math.cos(math.rad(ship.direction)))
	
	ship.IntAngle1 = math.deg(math.atan((ship.width/2)/(ship.height/2)))
	ship.midLine = (ship.width/2)/math.sin(math.rad(ship.IntAngle1))
	
	ship.topRight = {}
	ship.topRight.xOffset = (math.sin(math.rad((ship.direction-ship.IntAngle1)))*ship.midLine)*ship.scale
	ship.topRight.yOffset = (math.cos(math.rad((ship.direction-ship.IntAngle1)))*ship.midLine)*ship.scale
	ship.topRight.x = ship.posX + ship.topRight.xOffset
	ship.topRight.y = ship.posY - ship.topRight.yOffset
	
	ship.bottomLeft = {}
	ship.bottomLeft.xOffset = -ship.topRight.xOffset
	ship.bottomLeft.yOffset = -ship.topRight.yOffset
	ship.bottomLeft.x = ship.posX + ship.bottomLeft.xOffset
	ship.bottomLeft.y = ship.posY - ship.bottomLeft.yOffset
	
	ship.bottomRight = {}
	ship.bottomRight.xOffset = (math.sin(math.rad((ship.direction+ship.IntAngle1)))*ship.midLine)*ship.scale
	ship.bottomRight.yOffset = (math.cos(math.rad((ship.direction+ship.IntAngle1)))*ship.midLine)*ship.scale
	ship.bottomRight.x = ship.posX + ship.bottomRight.xOffset
	ship.bottomRight.y = ship.posY - ship.bottomRight.yOffset
	
	ship.topLeft = {}
	ship.topLeft.xOffset = -ship.bottomRight.xOffset
	ship.topLeft.yOffset = -ship.bottomRight.yOffset
	ship.topLeft.x = ship.posX + ship.topLeft.xOffset
	ship.topLeft.y = ship.posY - ship.topLeft.yOffset
	
	ship.TR_BR = {}
	ship.TR_BR.gradient,ship.TR_BL.intercept = lineEquation(ship.topRight.x,ship.topRight.y,ship.bottomRight.x,ship.bottomRight.y)
	ship.TR_TL = {}
	ship_TR_TL.gradient,ship.TR_TL.intercept = lineEquation(ship.topRight.x,ship.topRight.y,ship.topLeft.x,ship.topRight.y)
	ship.TL_BL = {}
	ship.TL_BL.gradient,ship.TL_BL.intercept = lineEquation(ship.topLeft.x,ship.topRight.y,ship.bottomLeft.x,ship.bottomLeft.y)
	ship.BL_BR = {}
	ship.BL_BR.gradient,ship.BL_BR.intercept = lineEquation(ship.bottomLeft.x,ship.bottomLeft.y,ship.bottomRight.x,ship.bottomRight.y)
end

function love.draw()
	love.graphics.setColor(0,255,0,255)
	ball.draw()
	love.graphics.circle("fill",ship.posX+ship.topRight.xOffset,ship.posY-ship.topRight.yOffset,5)
	love.graphics.circle("fill",ship.posX+ship.topLeft.xOffset,ship.posY-ship.topLeft.yOffset,5)
	love.graphics.circle("fill",ship.posX+ship.bottomRight.xOffset,ship.posY-ship.bottomRight.yOffset,5)
	love.graphics.circle("fill",ship.posX+ship.bottomLeft.xOffset,ship.posY-ship.bottomLeft.yOffset,5)
	
	--love.graphics.circle("fill",x,y,radius)
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(ship.Base,ship.posX,ship.posY,math.rad(ship.direction+90),ship.scale,ship.scale,ship.Base:getWidth()/2,ship.Base:getHeight()/2)
end
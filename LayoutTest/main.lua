
function love.load()
	--love.graphics.origin()
	love.graphics.setPointSize(30)
	
	x,y = 100,100
	xMax,yMax = love.graphics.getDimensions()
	xMin,yMin = 0,0
	reverseX,reverseY = 0,0	
	shipBase = love.graphics.newImage("ws-vessel-01.png")
	centreX,centreY = xMax/2,yMax/2
	posX,posY = centreX,centreY
	angle = 270
	direction = 0
	momentum = 0
end

function love.update(dt)
	--love.graphics.points(x,y)
	if reverseX == 0 then
		x = x + 1
	else
		x = x - 1
	end
	if reverseY == 0 then
		y = y + 1
	else
		y = y - 1
	end
	if x > xMax then
		reverseX = 1
	elseif x < xMin then
		reverseX = 0
	end
	if y > yMax then
		reverseY = 1
	elseif y < yMin then
		reverseY = 0
	end
	--[[if love.keyboard.isDown('d') then
		posX = posX + 10
	end
	if love.keyboard.isDown('a') then
		posX = posX - 10
	end
	if love.keyboard.isDown('s') then
		posY = posY + 10
	end
	if love.keyboard.isDown('w') then
		posY = posY - 10
	end
	if love.keyboard.isDown('q') then
		angle = angle + 3
	end
	if love.keyboard.isDown("e") then
		angle = angle - 3
	end
	--]]
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
	if love.keyboard.isDown('s') then
		if momentum > -10 then
			momentum = momentum - 0.1
		end
	end
	if love.keyboard.isDown('w') then
		if momentum < 10 then
			momentum = momentum + 0.1
		end
	end
	if love.keyboard.isDown('d') then
		direction = direction + 3
	end
	if love.keyboard.isDown('a') then
		direction = direction - 3
	end
	if direction > 360 then
		direction = direction - 360
	end
	if direction < 0 then
		direction = direction + 360
	end
	if posX > xMax then
		posX = xMax
	elseif posX < xMin then
		posX = xMin
	end
	if posY > yMax then
		posY = yMax
	elseif posY < yMin then
		posY = yMin
	end
	if momentum > 0 then
		posX = posX + ((math.sin(math.rad(direction)))*momentum)
		posY = posY - ((math.cos(math.rad(direction)))*momentum)
	elseif momentum < 0 then
		posX = posX - (math.sin(math.rad(direction))*(0-momentum))
		posY = posY + (math.cos(math.rad(direction))*(0-momentum))
	end
	print("PosX "..posX)
	print("PosY "..posY)
	print("Direction "..direction)
	print("Momentum "..momentum)
	print("sin "..math.sin(math.rad(direction)))
	print("cos "..math.cos(math.rad(direction)))
end

function love.draw()
	love.graphics.setColor(0,255,0,255)
	love.graphics.circle("fill",x,y,5)
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(shipBase,posX,posY,math.rad(direction+90),0.3,0.3,shipBase:getWidth()/2,shipBase:getHeight()/2)
end
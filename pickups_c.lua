local currentPickup = nil
local pickupCountdown = 0


local screenWidth,screenHeight = guiGetScreenSize()


addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		outputDebugString("Race powerups by Rhytz loaded")
	end
)


function pickupInvincibility()
	local theVehicle = getPedOccupiedVehicle (localPlayer)	
	if theVehicle then
		local weightSound = playSound("assets/sounds/invinc.mp3")
		setVehicleDamageProof(theVehicle, true) 
		triggerServerEvent("invincibilityAlpha", resourceRoot, theVehicle)
	end
end


function stopInvincibility()
	local theVehicle = getPedOccupiedVehicle (localPlayer)
	if theVehicle then
		setVehicleDamageProof(theVehicle, false)
		triggerServerEvent("invincibilityAlphaOff", resourceRoot, theVehicle)
		local offSound = playSound("assets/sounds/off.mp3")
	end
end


function pickupMaxWeight()
	local theVehicle = getPedOccupiedVehicle (localPlayer)
	if theVehicle then	
		local weightSound = playSound("assets/sounds/weight.mp3")
		triggerServerEvent("maxWeight", resourceRoot, theVehicle)
	end
end


function stopMaxWeight()
	local offSound = playSound("assets/sounds/off.mp3")
end


function pickupBoost()
	local theVehicle = getPedOccupiedVehicle (localPlayer)
	if theVehicle then	
		triggerServerEvent("boostPickup", resourceRoot, theVehicle)
		local boostsound = playSound("assets/sounds/boost.mp3")
		speed = 1.4
		_,_, rotz = getElementRotation(theVehicle) 
		rotz = math.rad(rotz) 
		vel_x = speed * math.sin(rotz) * -1 
		vel_y = speed * math.cos(rotz) 
		setElementVelocity(theVehicle, vel_x, vel_y, 0)
	end
end


function pickupBarrels()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if theVehicle then	
		triggerServerEvent("createBarrel", resourceRoot, theVehicle)
		local barrelSound = playSound("assets/sounds/barreldrop.mp3")
	end
end


function pickupRamps()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if theVehicle then	
		triggerServerEvent("createRamp", resourceRoot, theVehicle)
		local rampSound = playSound("assets/sounds/thud.mp3")
	end
end


function pickupRockets()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	local x,y,z = getElementPosition(theVehicle)
	local rX,rY,rZ = getVehicleRotation(theVehicle)
	local x = x+4*math.cos(math.rad(rZ+90))
	local y = y+4*math.sin(math.rad(rZ+90))
	createProjectile(theVehicle, 19, x, y, z, 1.0, nil)
end


function pickupMines()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if theVehicle then	
		triggerServerEvent("createMine", resourceRoot, theVehicle)
		local mineSound = playSound("assets/sounds/mine.mp3")
	end
end


local randomPickups = {
	{
		name = "Invincibility",
		amount = 1, --How many times the pickup can be activated
		description = "for 10 seconds of invincibility",
		seconds = 10,
		callback = pickupInvincibility,
		endfunc = stopInvincibility,
		icon = "invincibility.png"
	},
	{
		name = "Max weight",
		amount = 1,
		description = "to get maximum car weight for 10 seconds",
		seconds = 10,
		callback = pickupMaxWeight,
		endfunc = stopMaxWeight,
		icon = "maxweight.png"
	},
	{
		name = "Boost",
		amount = 1,
		description = "for a quick boost with max weight",
		seconds = nil,
		callback = pickupBoost,
		icon = "boost.png"
	},	
	{
		name = "Barrels",
		amount = 3,
		description = "to drop barrels",
		seconds = nil,
		callback = pickupBarrels,
		icon = "barrels.png"
	},
	{
		name = "Ramps",
		amount = 3,
		description = "to spawn ramps",
		seconds = nil,
		callback = pickupRamps,
		icon = "ramps.png"
	},
	{
		name = "Rockets",
		amount = 3,
		description = "to shoot rockets",
		seconds = nil,
		callback = pickupRockets,
		icon = "rockets.png"
	},
	{
		name = "Mines",
		amount = 3,
		description = "to drop mines",
		seconds = nil,
		callback = pickupMines,
		icon = "mines.png"
	} 
}
--[[
may be buggy
,
	{
		name = "Ghostmode",
		amount = 1,
		description = "for 20 seconds of ghostmode",
		seconds = 20,
		callback = pickupGhostmode,
		endfunc = stopGhostmode,
		icon = "ghostmode.png"
	}
]]--


function updatePickupStatus()
	if(pickupCountdown <= 0) then
		unbindKey("lshift", "down", activatePickup)
		unbindKey("rshift", "down", activatePickup)
		unbindKey("z", "down", discardPickup)
		triggerServerEvent("noLongerHasPickup", resourceRoot, localPlayer)
		currentPickup = nil
	end
end


function activatePickup(key, keyState)
	currentPickup.callback();
	
	if currentPickup.seconds then
		unbindKey("lshift", "down", activatePickup)
		unbindKey("rshift", "down", activatePickup)
		unbindKey("z", "down", discardPickup)
		setTimer(
			function() 
				pickupCountdown = pickupCountdown - 1
				if(pickupCountdown <= 0) then
					currentPickup.endfunc()
					updatePickupStatus()
				end
			end,
			1000,
			currentPickup.seconds
		)	
	else
		pickupCountdown = pickupCountdown - 1
	end

	updatePickupStatus()
end


function discardPickup(key, keyState)
	pickupCountdown = 0
	updatePickupStatus()
end


local shufflingPickup = nil
local lastTick = 0
function showPickupData()
	if shufflingPickup then
		if(getTickCount() - lastTick > 50) then
			randomIcon = randomPickups[math.random(#randomPickups)].icon
			lastTick = getTickCount()
		end
		dxDrawImage(screenWidth-155, screenHeight-185, 150, 150, "assets/images/" .. randomIcon)
	end
	if currentPickup then
		dxDrawImage(screenWidth-155, screenHeight-190, 150, 150, "assets/images/" .. currentPickup.icon)
		dxDrawRectangle(screenWidth-210, screenHeight-170, 55, 120, tocolor(245,149,28))
		dxDrawImage(screenWidth-205, screenHeight-165, 45, 32, "assets/images/keyboard_key_shift.png")
		dxDrawImage(screenWidth-199, screenHeight-87, 32, 32, "assets/images/keyboard_key_z.png")
		dxDrawText(pickupCountdown, screenWidth-210, screenHeight-130, screenWidth-155, nil, nil, 1.3, "pricedown", "center")
	end
end
addEventHandler("onClientRender", root, showPickupData)


addEvent("pickedUpPowerup", true)
addEventHandler("pickedUpPowerup", localPlayer,
	function()
		if(not currentPickup and getElementData(localPlayer,"state") == "alive") then
			local shufflesound = playSound("assets/sounds/shuffle.mp3")
			local x,y,z = getElementPosition(source)
			createExplosion(x, y, z, 5, nil, nil, false)

			shufflingPickup = true
			
			setTimer(
				function()
					shufflingPickup = nil
					if not isPedDead(localPlayer) then
						currentPickup = randomPickups[math.random(#randomPickups)]
						
						if(currentPickup.seconds) then
							pickupCountdown = currentPickup.seconds
						else
							pickupCountdown = currentPickup.amount
						end

						outputChatBox("You picked up #FFFFFF" .. currentPickup.name .. "#696969. Press #00FF00Shift#696969 ".. currentPickup.description .. ". #FF0000Z#696969 to discard", 105, 105, 105, true);
						bindKey("lshift", "down", activatePickup)
						bindKey("rshift", "down", activatePickup)
						bindKey("z", "down", discardPickup)
					end
				end,
				1850,
				1
			)
		end
	end
)


addEvent("createBoostExplosion", true)
addEventHandler("createBoostExplosion", resourceRoot, 
	function(theVehicle)
		if theVehicle then
			local x,y,z = getElementPosition(theVehicle)
			createExplosion(x,y,z, 5, nil, nil, false)
		end
	end
)


addEventHandler("onClientPlayerWasted", localPlayer,
	function()
		if(source == localPlayer) then
			currentPickup = nil
		end
	end
)



local triggeredObject = {}
addEventHandler("onClientVehicleCollision", root, 
	function(object, force, bodyPart, x, y, z, nx, ny, nz, force, model)
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		if(object and source == theVehicle and not triggeredObject[object]) then
			if(model == 1218) then
				triggerServerEvent("barrelHit", resourceRoot, object)
			elseif(model == 2918) then
				setElementVelocity(source, math.random() + math.random(-1, 0), math.random() + math.random(-1, 0), math.random())
			end
			triggeredObject[object] = true
		end
	end
)
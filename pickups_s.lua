function pickedUpPowerup(hitElement, matchingDimension)	
	if(getElementType(hitElement) == "vehicle") then
		local vehOccupant = getVehicleOccupant(hitElement)
		local hasPickup = getElementData(vehOccupant, "hasPickup")
		if not hasPickup then
			local x,y,z = getElementPosition(source)
			local cR, cG, cB = getMarkerColor(source)
			local markerSize = getMarkerSize(source)
			local markerType = getMarkerType(source)		
			destroyElement(source)
			setElementData(vehOccupant, "hasPickup", true, false)
			triggerClientEvent(vehOccupant, "pickedUpPowerup", vehOccupant)
			setTimer(
				function()
					local newMarker = createMarker(x,y,z, markerType, markerSize, cR, cG, cB)
					addEventHandler("onMarkerHit", newMarker, pickedUpPowerup) 
				end,
				5000, 1
			)		
		end
	end
end


addEvent("onMapStarting")
addEventHandler("onMapStarting", resourceRoot, 
	function()
		for index, marker in ipairs(Element.getAllByType("marker")) do			
			addEventHandler("onMarkerHit", marker, pickedUpPowerup)  
		end
		outputDebugString("Pickups loaded")
		for index, player in ipairs(Element.getAllByType("player")) do			
			setElementData(player, "hasPickup", false, false)
		end
	end
)


addEvent("noLongerHasPickup", true)
addEventHandler("noLongerHasPickup", resourceRoot, 
	function(localPlayer)
		setElementData(localPlayer, "hasPickup", false, false)
	end
)


addEvent("boostPickup", true)
addEventHandler("boostPickup", resourceRoot, 
	function(theVehicle)
		local handlingTable = getVehicleHandling (theVehicle)
		local oldMass = handlingTable[mass]
		setVehicleHandling(theVehicle, "mass", 50000) 
		triggerClientEvent("createBoostExplosion", resourceRoot, theVehicle)
		
		setTimer(
			function ()			
				setVehicleHandling(theVehicle, "mass", oldMass) 
			end
			, 1000, 1
		)		
	end
)


addEvent("maxWeight", true)
addEventHandler("maxWeight", resourceRoot,
	function(theVehicle)
		local handlingTable = getVehicleHandling(theVehicle)
		local oldMass = handlingTable[mass]
		setVehicleHandling (theVehicle, "mass", 25000) 
		
		setTimer(
			function ()			
				setVehicleHandling (theVehicle, "mass", oldMass) 
			end
			, 10000, 1
		)		
	end
)


addEvent("invincibilityAlpha", true)
addEventHandler("invincibilityAlpha", resourceRoot, 
	function(theVehicle)
		setElementAlpha(theVehicle, 180)
	end
)


addEvent("invincibilityAlphaOff", true)
addEventHandler("invincibilityAlphaOff", resourceRoot,
	function(theVehicle)
		setElementAlpha(theVehicle, 255)
	end
)


addEvent("createRamp", true)
addEventHandler("createRamp", resourceRoot,
	function(theVehicle)  
		if theVehicle then
			local x, y, z = getElementPosition (theVehicle) 
			local a,b,r = getVehicleRotation (theVehicle) 
			x = x - math.sin ( math.rad(r) ) * -20 
			y = y + math.cos ( math.rad(r) ) * -20 
			local theRamp = createObject ( 1634, x, y, z, 0, 0, r )
			setTimer(removeRamp, 8000, 1, theRamp) 
		end
	end 
)


function removeRamp(theRamp) 
    destroyElement(theRamp)
end 


local playerBarrels = {}
addEvent("createBarrel", true)
addEventHandler("createBarrel", resourceRoot, 
	function(theVehicle)  
		if theVehicle then
			local x, y, z = getElementPosition ( theVehicle ) 
			local a,b,r = getVehicleRotation ( theVehicle ) 
			x = x - math.sin ( math.rad(r) ) * -5 
			y = y + math.cos ( math.rad(r) ) * -5
			local barrel = createObject (1218, x, y, z, 0, 0, r)
			playerBarrels[barrel] = getVehicleOccupant(theVehicle)
			
			setTimer(
				function()
					setElementVelocity(barrel,0,0,0.1)
				end,
				50,
				1
			)
		end
	end
)


addEvent("barrelHit", true)
addEventHandler("barrelHit", resourceRoot,
	function(theBarrel)
		local barrelOwner = playerBarrels[theBarrel]
		local bX, bY, bZ = getElementPosition(theBarrel)
		createExplosion(bX, bY, bZ, 9, barrelOwner)
		playerBarrels[theBarrel] = nil
		destroyElement(theBarrel)
	end
)


addEvent("createMine", true)
addEventHandler("createMine", resourceRoot, 
	function(theVehicle)  
		if theVehicle then
			local x, y, z = getElementPosition(theVehicle) 
			local a,b,r = getVehicleRotation(theVehicle) 
			x = x - math.sin ( math.rad(r) ) * -5 
			y = y + math.cos ( math.rad(r) ) * -5
			local mine = createObject (2918, x, y, z+1.5, 0, 0, r)
			setTimer(
				function()
					setElementVelocity(mine,0,0,0.1)
				end,
				50,
				1
			)		
		end
	end
)
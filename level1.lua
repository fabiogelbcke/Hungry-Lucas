-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget = require("widget")
local scene = storyboard.newScene()
--local score = require ("score")

-- include Corona's "physics" library
local physics = require "physics"
 physics.start()
require "sprite"
system.setAccelerometerInterval (100)


-- load the JSON library.
local json = require("json")


--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5



-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--       unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

-- Function to save a table.&nbsp; Since game settings need to be saved from session to session, we will
-- use the Documents Directory
local json = require("json")
function saveTable(t, filename)
	local path = system.pathForFile( filename, system.DocumentsDirectory)
	local file = io.open(path, "w")
	if file then
		local contents = json.encode(t)
		file:write( contents )
		io.close( file )
		return true
	else
		return false
	end
end
function loadTable(filename)
	local path = system.pathForFile( filename, system.DocumentsDirectory)
	local contents = ""
	local myTable = {}
	local file = io.open( path, "r" )
	if file then
		 -- read all contents of file into a string
		 local contents = file:read( "*a" )
		 myTable = json.decode(contents);
		 io.close( file )
		 return myTable 
	end
	return nil
end

function mergeSort(A, p, r)
        -- return if only 1 element
	if p < r then
		local q = math.floor((p + r)/2)
		mergeSort(A, p, q)
		mergeSort(A, q+1, r)
		merge(A, p, q, r)
	end
end
-- merge an array split from p-q, q-r
function merge(A, p, q, r)
	local n1 = q-p+1
	local n2 = r-q
	local left = {}
	local right = {}
	
	for i=1, n1 do
		left[i] = A[p+i-1]
	end
	for i=1, n2 do
		right[i] = A[q+i]
	end
	
	left[n1+1] = math.huge
	right[n2+1] = math.huge
	
	local i=1
	local j=1
	
	for k=p, r do
		if left[i]<=right[j] then
			A[k] = left[i]
			i=i+1
		else
			A[k] = right[j]
			j=j+1
		end
	end
end


local fattyData = {

frames = {
	
		{
			-- Gordinho Fase 1-1 suor invertido
			x=328,
			y=2,
			width=62,
			height=110,

		},
		{
			-- Gordinho Fase 1-1 suor
			x=264,
			y=2,
			width=62,
			height=110,

		},
		{
			-- Gordinho correndo 1 (3) copy
			x=199,
			y=2,
			width=63,
			height=110,

		},
		{
			-- Gordinho correndo 1 (3)
			x=134,
			y=2,
			width=63,
			height=110,

		},
		{
			-- Gordinho correndo 2 (2) copy
			x=707,
			y=2,
			width=61,
			height=110,

		},
		{
			-- Gordinho correndo 2 (2)
			x=644,
			y=2,
			width=61,
			height=110,

		},
		{
			-- Gordinho correndo 3 (1) copy
			x=68,
			y=2,
			width=64,
			height=110,

		},
		{
			-- Gordinho correndo 3 (1)
			x=2,
			y=2,
			width=64,
			height=110,

		},
		{
			-- Gordinho correndo 4 (1) copy
			x=581,
			y=2,
			width=61,
			height=110,

		},
		{
			-- Gordinho correndo 4 (1)
			x=518,
			y=2,
			width=61,
			height=110,

		},
		{
			-- Gordinho correndo 5 copy
			x=455,
			y=2,
			width=61,
			height=110,

		},
		{
			-- Gordinho correndo 5
			x=392,
			y=2,
			width=61,
			height=110,

		},
	},
	
	sheetContentWidth = 770,
	sheetContentHeight = 114
}
local spriteSheet = graphics.newImageSheet ("hungrysprite.png", fattyData)
local sequenceData = {
{name ="left1", frames = {3,5,7,9,11}, time=400},
{name ="right1", frames = {4,6,8,10,12}, time=400},
{name ="stoppedleft1", frames = {1}, time=300},
{name ="stoppedright1", frames = {2}, time=300},

}
local frameno = 0
local foodno = 0
local saladno = 0
local barno = 1
local direction = 0
local timeSinceStart = 0
local decreasedTime=0
local isRunning=1
local isStopping=1
local meterObjects = {}
local imageNames = {"Nuvem Pizza.png", "Nuvem Bolo.png", "Nuvem Hamburguer.png", "Nuvem Coxinha.png", "Nuvem Cachorro-quente.png"}
local cloudNumber = 0
print("foradetodas")

local function removeBody(body)

	if body then
		body:removeSelf()
	end
end

local function increaseTimer( )
	if isRunning==1 then
		timeSinceStart = timeSinceStart+1
		if timeSinceStart%30 == 0 then
			
			audio.play( coinsound )
			coinsQty = coinsQty +2
			coinCounter.text = string.format("x%d",coinsQty)
		end
		timeCounter.text = string.format( "%d:%2.2d",(timeSinceStart - timeSinceStart%60)/60, timeSinceStart%60 )
		
	end
	timer.performWithDelay( 1000, increaseTimer )
end

local function handleButtonEvent( event )
	overButton:removeSelf( )
	congrats:removeSelf( )
	
	
	storyboard.gotoScene( "menu", "fade", 1100  )
end

local function explodeFat()
	fattySprite:setSequence( "explode2" )
	fattySprite:play()
end
local function playpause()
	if isRunning==1 then
		physics.pause( )
		fattySprite:pause( )
		isRunning=0
	else
		physics.start( )
		fattySprite:play( )
		isRunning=1
	end
end

function scene:createScene( event )
	system.setIdleTimer( false )
	print("createscene")
	frameno = 0
	foodno = 0
	saladno = 0
	barno = 1
	direction = 0
	timeSinceStart = 0
	decreasedTime=0
	counter=0
	isRunning=1
	isStopping=1
	meterObjects = {}
	imageNames = {"Nuvem Pizza.png", "Nuvem Bolo.png", "Nuvem Hamburguer.png", "Nuvem Coxinha.png", "Nuvem Cachorro-quente.png"}
	cloudNumber = 0
	bodyToRemove = nil
	local group = self.view
	local background = display.newImageRect ("background_game.png", display.contentWidth, display.contentHeight)
	background:setReferencePoint(display.TopLeftReferencePoint)
	background.x=0
	background.y=0
	frameHealthy = display.newImageRect( "score_healthy.png", 55, 50 )
	frameHealthy:setReferencePoint(display.TopLeftReferencePoint)
	frameHealthy.x=0
	frameHealthy.y=screenH/2-15
	frameJunk = display.newImageRect( "score_junk.png", 55, 50 )
	frameJunk:setReferencePoint(display.TopLeftReferencePoint)
	frameJunk.x=0
	frameJunk.y=screenH/2-70
	frameTime = display.newImageRect( "scoreboard.png", 120, 55 )
	frameTime:setReferencePoint(display.TopCenterReferencePoint)
	frameTime.x = screenW/12
	frameTime.y = 10
	foodCounter = display.newText ("0", 10, screenH/2 - 64, "Chango",20)
	foodCounter.setReferencePoint = (display.TopLeftReferencePoint)
	foodCounter.x=22
	saladCounter = display.newText ("0", 10, screenH/2-9, "Chango", 20)
	saladCounter.setReferencePoint = (display.TopLeftReferencePoint)
	saladCounter.x=22
	timeCounter = display.newText ("0:00", 500, display.contentHeight/8+65, "Chango", 27)
	timeCounter:setReferencePoint(display.TopCenterReferencePoint)
	timeCounter.x=screenW/12-2
	timeCounter.y = 15
	coinsQty=0
	coinCounter = display.newText( "x0", 28, 63, native.systemFont, 15 )
	coinCounter:setTextColor( 0, 0, 0 )
	coin = display.newImageRect( "Coin-icon.png", 21,21)
	coin.x=13
	coin.y=70
	--local ground
	ground = display.newRect( -5, display.contentHeight-5, display.contentWidth+10, 1 )
	ground.alpha=0

	physics.addBody(ground,{isSensor=true})
	ground.gravityScale=0
	ground.myName="ground"
	
	timeCounter:setTextColor(255,225,62)
	meter = display.newImageRect( "blood_marker.png", 45, display.contentHeight*3/4-26 )
	meter:setReferencePoint(display.TopLeftReferencePoint)
	meter.x=display.contentWidth-45 
	meter.y=display.contentHeight/8+26
	meter:toFront()
	barCounter = display.newText ("1/3", meter.x +7, meter.y-18, native.systemFont,14)
	barCounter:setTextColor(0,0,0)
	wall1 = display.newRect (-1,0,1, screenH)
	wall2 = display.newRect (screenW+1, 0, 1, screenH)
	decreasedTime=1
	counter=0
	physics.setGravity(20,0)
	physics.addBody(wall1, "static")
	physics.addBody(wall2, "static")
	topcloud = display.newImage ("topcloud.png", 0, 0 )
	local n = cloudNumber
	while
		n==cloudNumber do
		n = math.random(1,5)
	end
	cloudNumber=n
	local cloud1 = display.newImage(imageNames[cloudNumber], screenW/3.5, screenH*0.0)
	physics.addBody (cloud1, {isSensor=true})
	n = cloudNumber
	while
		n==cloudNumber do
		n = math.random(1,5)
	end
	cloudNumber=n
	local cloud2 = display.newImage(imageNames[cloudNumber],screenW/1.5, screenH*0.0)
	physics.addBody(cloud2, { isSensor=true})
	cloud1:setLinearVelocity(-11,0)
	cloud2:setLinearVelocity(-11,0)
	cloud2.myName="cloud"
	cloud1.myName="cloud"
	cloud2.gravityScale=0
	cloud1.gravityScale=0
	topcloud:toFront()
	saladCounter:toFront()
	pauseBtn = widget.newButton{
    labelColor = { default={255}, over={128} },
        defaultFile="button_pause.png",
        overFile="button_pause.png",
        width=40, height=40,
        onRelease = playpause
    }
    pauseBtn:setReferencePoint(display.TopRightReferencePoint)
    pauseBtn.x = display.contentWidth*19.83/20
    pauseBtn.y = display.contentHeight*0.78/10
    

	group:insert( background )
	group:insert( barCounter )
	group:insert( frameJunk )
	group:insert(frameHealthy)
	group:insert( frameTime )
	group:insert( foodCounter )
	group:insert( saladCounter )
	group:insert( timeCounter )
	group:insert( wall1 )
	group:insert( wall2 )
	group:insert( meter )
	group:insert( cloud1 )
	group:insert( cloud2 )
	group:insert (topcloud)
	group:insert( coinCounter )
	group:insert(coin)
	group:insert(ground)
	group:insert(pauseBtn)
	pauseBtn:toFront( )
	fattySprite = display.newSprite(spriteSheet, sequenceData)

	fattySprite.x=screenW/2
	fattySprite.y=screenH*7.3/9
	fattySprite:setSequence(string.format("stoppedleft1"))
	fattySprite:play()
	physics.addBody(fattySprite)
	fattySprite.gravityScale=0
	fattySprite.myName="fatty"
	group:insert( fattySprite )
	coinsound = audio.loadSound( "smw_coin.wav")


	function newCloud()
		local n = cloudNumber
		while n==cloudNumber do
			n = math.random(1,5)
		end
		cloudNumber=n
		local cloud = display.newImage(imageNames[cloudNumber], screenW+30, screenH*0.02)
		timer.performWithDelay(15000, newCloud)
		cloud.myName="cloud"
		physics.addBody (cloud, {isSensor=true})
		cloud:setLinearVelocity(-11,0)
		cloud.gravityScale=0
		local function removeacloud() if cloud then removeBody(cloud) end end
		timer.performWithDelay(100000, removeacloud )
		topcloud:toFront()
		foodCounter:toFront()
		barCounter:toFront()
		saladCounter:toFront()
		group:insert(cloud)
		frameTime:toFront( )
		timeCounter:toFront( )
		barCounter:toFront( )
		meter:toFront( )
		pauseBtn:toFront( )
		for i=0, #meterObjects do
			if i<counter then
				if meterObjects[i]then
					meterObjects[i]:toFront( )
				end
			end
		end
		


	end
	timer.performWithDelay(6000,newCloud())
	function increaseMeter( )
	   local meterIncrease
	   if counter==0 then
			meterIncrease = display.newImageRect("blood_bottom.png",27,22)
			meterIncrease:setReferencePoint(display.TopLeftReferencePoint)
			meterIncrease.x=meter.x+6
			meterIncrease.y=meter.y+7*meterIncrease.height+19
		elseif counter==7 then
			meterIncrease = display.newImageRect("blood_top.png", 27, 25)
			meterIncrease:setReferencePoint(display.TopLeftReferencePoint)
			meterIncrease.x=meter.x+6
			meterIncrease.y=meter.y+(7-counter)*meterIncrease.height+8
		else
			meterIncrease = display.newImageRect("blood_middle.png",27, 23.3)
			meterIncrease:setReferencePoint(display.TopLeftReferencePoint)
			meterIncrease.x=meter.x+6
			meterIncrease.y=meter.y+(6-counter)*(meterIncrease.height)+33
		end
					meterObjects[counter]=meterIncrease
					meterIncrease.tag=counter
					counter=counter+1
					--meterIncrease:addEventListener("saladCollision", meterDecrease)
					if (foodno-9)%10 == 0 then
					foodno=foodno+2
					sizefood = 1
					plusone = display.newText("+1", 60, screenH/2 - 64, "Chango",sizefood)
					local group = scene.view
					group:insert(plusone)
					timer.performWithDelay( 0.2, plusOneIncrease )
				else 
					foodno = foodno+1
				end
					foodCounter.text=foodno
		group:insert(meterIncrease)
		-- body
	end
	;function meterDecrease (event)
	for i=0, #meterObjects do
		if meterObjects[i].tag==counter-1 then
			meterObjects[i]:removeSelf()
		end
	end
	counter=counter-1

end

	function plusOneIncrease ( )
		if sizefood<20 then
			plusone:removeSelf( )
				sizefood = sizefood + 2.2
				plusone = display.newText("+1", 60, screenH/2 - 64, "Chango",sizefood)
				local group = scene.view
					group:insert(plusone)
					timer.performWithDelay( 0.2, plusOneIncrease )
		else
			timer.performWithDelay( 500, plusOneDecrease )
		end


	end
	function plusOneDecrease( )
		plusone:removeSelf()
		if sizefood>1 then
			 sizefood = sizefood - 2.2
			plusone = display.newText("+1", 60, screenH/2 - 64, "Chango",sizefood)
			local group = scene.view
			group:insert(plusone)
			timer.performWithDelay( 0.2, plusOneDecrease )
		end


		-- body
	end

	function plusOneSaladIncrease ( a )
		if sizesalad<20 then
			if plusonesalad then
				plusonesalad:removeSelf( )
			end
			plusonesalad:setReferencePoint(display.TopLeftReferencePoint)
				sizesalad = sizesalad + 2.2
				if a  ==1 then
					plusonesalad = display.newText("+10", 60, screenH/2 - 9, "Chango",sizesalad)
				else
					plusonesalad = display.newText("+1", 60, screenH/2 - 9, "Chango",sizesalad)
				end
				local group = scene.view
					group:insert(plusonesalad)
					group:toFront( plusonesalad)
					local function plus() plusOneSaladIncrease(a) end
					timer.performWithDelay( 0.2, plus)
		else
			local function plus() plusOneSaladDecrease(a) end
			timer.performWithDelay( 500, plus)
		end


	end
	function plusOneSaladDecrease( a )
		if plusonesalad then
			plusonesalad:removeSelf()
		end
		if sizesalad>1 then
			 sizesalad = sizesalad - 2.2
			if a  ==1 then
				plusonesalad = display.newText("+10", 60, screenH/2 - 9, "Chango",sizesalad)
			else
				plusonesalad = display.newText("+1", 60, screenH/2 - 9, "Chango",sizesalad)
			end
			local group = scene.view
			group:insert(plusonesalad)
			local function plus() plusOneSaladDecrease(a) end
			timer.performWithDelay( 0.2, plus)
		end


		-- body
	end


print("createScene")


end

-- Called immediately after scene has moved onscreen:


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	print("exitScene")
	

	physics.stop()

end


function scene:destroyScene( event )

print("destroyScene")
	local group = self.view
	for j=group.numChildren, 1, -1 do
		display.remove(group[group.numChildren])
		group[group.numChildren] = nil
	end
	if newButton then
		newButton:removeSelf( )
	end
	local group = self.view
	Runtime:removeEventListener("enterFrame", decreaseTime)
	frameno = nil
	foodno = 0
	saladno = 0
	barno = 1
	direction = nil
	timeSinceStart = nil
	decreasedTime=nil
	counter=0
	isRunning=nil
	isStopping=nil
	meterObjects = nil
	imageNames = nil
	cloudNumber = nil
	saladCounter = nil
	--[[package.loaded[physics] = nil
	physics = nil]]
end

function saladCollision( event )
	if ( event.phase == "began" ) then
		local salada = event.object2

		if (event.object1.myName=="salad")then
			if (event.object2.myName == "fatty" or event.object2.myName =="ground") then
			   
				if event.object2.myName =="ground" then
					local shadow = display.newImageRect("splash.png", 25, 20)
					shadow:setReferencePoint(display.TopLeftReferencePoint)
					shadow.x=event.object1.x
					shadow.y=ground.y-15
					local function removeShadow( ) shadow:removeSelf( ) end

					timer.performWithDelay( 150, removeShadow)

				end
				event.object1:removeSelf()
			end
			if(event.object2.myName=="fatty")then

				if event.object1.tag==30 then
					saladno = saladno+10
					sizesalad = 1
					plusonesalad = display.newText("+10", 60, screenH/2 - 9, "Chango",sizesalad)
					local group = scene.view
					group:insert(plusonesalad)
					local function plusten() plusOneSaladIncrease(1)end
					timer.performWithDelay( 0.2, plusten)
				elseif (saladno-9)%10 ~= 0 then
					saladno=saladno+1
				else
					saladno = saladno+2
					sizesalad = 1
					plusonesalad = display.newText("+1", 60, screenH/2 - 9, "Chango",sizesalad)
					local group = scene.view
					group:insert(plusonesalad)
					local function plusone() plusOneSaladIncrease(0)end
					timer.performWithDelay( 0.2, plusone)
				end
				saladCounter.text=saladno
				if counter ~=0 then
					if barno ~= 4 then
						meterDecrease()
						print ("meterdecrease ta sendo chamado")
					end
				end
			end
		elseif (event.object2.myName=="salad")then
			if (event.object1.myName == "fatty" or event.object1.myName =="ground") then
				if event.object1.myName =="ground" then
					local shadow = display.newImageRect("splash.png", 30, 20)
					--shadow:setReferencePoint(display.TopLeftReferencePoint)
					shadow.x=event.object2.x
					shadow.y=event.object1.y-10
					local function removeShadow( ) shadow:removeSelf( ) end
					timer.performWithDelay( 150, removeShadow )

				end
				if event.object1.myName == "fatty" then 
					print("aque")
				end
				if event.object2 ~= nil then
					salada:removeSelf( )
				end
			end
			if(event.object1.myName=="fatty")then
			   if event.object2.tag==30 then
					saladno = saladno+10
					sizesalad = 1
					plusonesalad = display.newText("+10", 60, screenH/2 - 9, "Chango",sizesalad)
					local group = scene.view
					group:insert(plusonesalad)
					local function plusten() plusOneSaladIncrease(1)end
					timer.performWithDelay( 0.2, plusten)
				elseif (saladno-9)%10 ~= 0 then
					saladno=saladno+1
				else
					saladno = saladno+2
					sizesalad = 1
					plusonesalad = display.newText("+1", 60, screenH/2 - 9, "Chango",sizesalad)
					local group = scene.view
					group:insert(plusonesalad)

					local function plusone() plusOneSaladIncrease(0)end
					timer.performWithDelay( 0.2, plusone)
				end
				saladCounter.text=saladno
				if counter ~=0 then
					if barno ~= 4 then
						meterDecrease()
					end
				end
			end
		end
	end
end

local function isHighScore (score) 

	if loadTable("highscores.json") then
    	highScoresTable = loadTable("highscores.json")
    	if #highScoresTable<10 then
    		highScoresTable[#highScoresTable+1]=score
    		mergeSort(highScoresTable, 1, #highScoresTable)
    		saveTable(highScoresTable, "highscores.json")
    		print(highScoresTable[1])
    	else
    		if highScoresTable[1]<score then
    			highScoresTable[1]=score
    			mergeSort(highScoresTable, 1, #highScoresTable)
    			print(highScoresTable[1])
    			saveTable(highScoresTable, "highscores.json")
    		end
    	end
    else 
	    highScoresTable={timeSinceStart}
	    saveTable(highScoresTable, "highscores.json")
	end


end





local function foodCollision( event )
	
	if ( event.phase == "began" ) then
		if (event.object1.myName == "salad" or event.object2.myName=="salad")then
			saladCollision(event)

		elseif (event.object1.myName=="food")then
			if (event.object2.myName=="fatty" or event.object2.myName=="ground") then
				
				if event.object2.myName =="ground" then
					local shadow = display.newImageRect("splash.png", 25, 20)
					shadow:setReferencePoint(display.TopLeftReferencePoint)
					shadow.x=event.object1.x
					shadow.y=ground.y-15
					local function removeShadow( ) shadow:removeSelf( ) end

					timer.performWithDelay( 150, removeShadow)

				end
				event.object1:removeSelf()
			end
			if(event.object2.myName=="fatty")then
				if counter ~= 8 then
					increaseMeter()
				end
				if counter == 8 then
					barno = barno + 1
					if barno < 4 then
						if direction==0 then
							fattySprite:setSequence( string.format( "left%d", 2*barno-1 ) )
							fattySprite:play()
						elseif direction ==1 then
							fattySprite:setSequence( string.format( "right%d", 2*barno-1 ) )
							fattySprite:play()
						elseif direction ==2 then
							fattySprite:setSequence( string.format( "stoppedleft%d", 2*barno-1 ) )
							fattySprite:play()
						else
							fattySprite:setSequence( string.format( "stoppedright%d", 2*barno-1 ) )
							fattySprite:play()
						end
						for i=1,9 do
							meterDecrease()
						end
						counter = 0

						if barno < 4 then
							barCounter.text = string.format("%d/3", barno)
							--meter.height = meter.height - 26
							--meter.y=meter.y-13
						end
					end
				if barno==4 then
					Runtime:removeEventListener( "accelerometer", urTiltFunc )
				    Runtime:removeEventListener("collision", foodCollision)
					congrats = display.newText("Well done!", screenW/2-90, screenH/2-45,native.systemFont,40)
					isRunning=0
					fattySprite:setSequence( "explode" )
					fattySprite:setLinearVelocity( 0, 0 )
					overButton = widget.newButton{
					left = screenW/2-70,
					top = screenH/2,
					width = 160,
					height = 50,
					label = "Go To Menu",
					onEvent = handleButtonEvent,
					}
				end
			end
					end
		elseif (event.object2.myName=="food")then
			if (event.object1.myName == "fatty" or event.object1.myName =="ground") then
				if event.object1.myName =="ground" then
					local shadow = display.newImageRect("splash.png", 30, 20)
					--shadow:setReferencePoint(display.TopLeftReferencePoint)
					shadow.x=event.object2.x
					shadow.y=event.object1.y-10
					local function removeShadow( ) shadow:removeSelf( ) end
					timer.performWithDelay( 150, removeShadow )

				end
				if event.object2 ~= nil then
					event.object2:removeSelf()
			    end
			end
			if(event.object1.myName=="fatty")then
				if counter ~=8 then
					increaseMeter()
				end
				if counter == 8 then
					barno = barno + 1
					if barno < 4 then
						if direction==0 then
							fattySprite:setSequence( string.format( "left%d", 2*barno-1) )
							fattySprite:play()
						elseif direction ==1 then
							fattySprite:setSequence( string.format( "right%d", 2*barno-1 ) )
							fattySprite:play()
						elseif direction ==2 then
							fattySprite:setSequence( string.format( "stoppedleft%d", 2*barno-1) )
							fattySprite:play()
						else
							fattySprite:setSequence( string.format( "stoppedright%d", 2*barno-1) )
							fattySprite:play()
						end
						for i=1,9 do
							meterDecrease()
						end
						counter = 0
						if barno < 4 then
							barCounter.text = string.format("%d/3", barno)
							--meter.height = meter.height - 26
							--meter.y=meter.y-13
						end
				end
				if barno==4 then
					Runtime:removeEventListener( "accelerometer", urTiltFunc )
				    Runtime:removeEventListener("collision", foodCollision)
				    Runtime:removeEventListener("enterFrame", decreaseTime)
				    
                    isHighScore(timeSinceStart)
					print("rodou essa porra aqui")
					congrats = display.newText("Well done!", screenW/2-90, screenH/2-45,native.systemFont,40)
					isRunning=0
					fattySprite:setSequence( "explode" )
					fattySprite:setLinearVelocity( 0, 0 )
					overButton = widget.newButton{
					left = screenW/2-70,
					top = screenH/2,
					width = 160,
					height = 50,
					label = "Go To Menu",
					onEvent = handleButtonEvent,
				}
				--group:insert(overButton)
				end
			end
		end
	end
	elseif ( event.phase == "ended" ) then
end
end


function createFood(  )
	if isRunning == 1 then
		local food
		if math.random(0,1)==0 then
			food = display.newImage("burger.png",math.random(0,display.contentWidth-25), -26)
		else
			food = display.newImage("hotdog.png",math.random(0,display.contentWidth-25), -26)
		end
		local group = scene.view
				topcloud:toFront( )
		frameTime:toFront( )
		timeCounter:toFront( )
		

		food.myName="food"
		physics.addBody(food)
		food.gravityScale = 0
		food:setLinearVelocity (0, 150)
		food.angularVelocity = math.random(0,130 )
		--timer.performWithDelay( 5000, food:removeSelf() )
		group:insert(food)
		
	end
	local delay = math.random (500-decreasedTime,1300-decreasedTime)
		fatorhealthy = math.random(1,5)
		if fatorhealthy<5 then
			timer.performWithDelay(delay, createFood)
		elseif(fatorhealthy==5)then
			timer.performWithDelay(delay,createSalad)
		end
		
		

end

function createSalad(  )

	if isRunning == 1 then
		local salad
		if math.random(0,2)==0 then
			salad = display.newImage("melancia.png",math.random(0,display.contentWidth-25), -26)
			salad.angularVelocity = math.random (0,130)
		elseif math.random(0,1)==0 then
			salad = display.newImage("maca.png",math.random(0,display.contentWidth-25), -26)
			salad.angularVelocity = math.random (0,130)
		else
			salad = display.newImage("golden_grapes.png",math.random(0,display.contentWidth-25), -26)
			salad.tag=30
		end
		local group = scene.view
		
		topcloud:toFront( )
		frameTime:toFront( )
		timeCounter:toFront( )

		salad.myName="salad"
		physics.addBody(salad)
		salad.gravityScale=0
		salad:setLinearVelocity (0, 150)
		
		
		group:insert(salad)
	end
	local delay = math.random (500-decreasedTime,2000-decreasedTime)
		fatorhealthy = math.random(1,5)
		if fatorhealthy<5 then
			timer.performWithDelay(delay, createFood)
		elseif(fatorhealthy==5)then
			timer.performWithDelay(delay,createSalad)
		end
		
end
function decreaseTime( event )
 if decreasedTime<450 then
	decreasedTime=decreasedTime+0.5
end
fattySprite.y=screenH*7.3/9
fattySprite.rotation=0
frameno= frameno+1

end
local function urTiltFunc( event )
if isRunning==1 then
	if event.yGravity>0.06 then
		fattySprite:setLinearVelocity(-220,0)
		isStopping=1
		if (direction ~= 0) then
			direction=0
			fattySprite:setSequence(string.format("left1"))
			fattySprite:play()
		end
	else
		if event.yGravity<-0.06 then
			fattySprite:setLinearVelocity (220,0)
			isStopping=1
			if (direction ~= 1) then
				direction=1
				fattySprite:setSequence(string.format("right1"))
				fattySprite:play()
			end
		else
			if (direction==0 ) then
				direction=2
				fattySprite:setSequence(string.format("stoppedleft1"))
				elseif (direction==1)then
					direction=3
					fattySprite:setSequence(string.format("stoppedright1"))
				end
				fattySprite:setLinearVelocity(0,0)
				isStopping=0
			end
		end
	end
end

function scene:enterScene( event )
	print("enterScene")
	local group = self.view
	frameno = 0
	foodno = 0
	saladno = 0
	barno = 1
	direction = 0
	timeSinceStart = 0
	decreasedTime=0
	counter=0
	isRunning=1
	isStopping=1
	meterObjects = {}    
	imageNames = {"Nuvem Pizza.png", "Nuvem Bolo.png", "Nuvem Hamburguer.png", "Nuvem Coxinha.png", "Nuvem Cachorro-quente.png"}
	cloudNumber = 0
	physics.start()
	timer.performWithDelay( 1000, increaseTimer )
	createFood()
	Runtime:addEventListener( "accelerometer", urTiltFunc )
--Runtime:addEventListener("collision", saladCollision)
    Runtime:addEventListener("collision", foodCollision)

    Runtime:addEventListener("enterFrame", decreaseTime)
	--saladCounter = 0

	

end








-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene
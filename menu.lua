-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

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

--------------------------------------------

-- forward declarations and other locals
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	print ("play")
	audio.fade( {backgroundlullaby, time =1500, volume = 0}  )
	storyboard.gotoScene( "level1", "fade", 500 )
	return true	-- indicates successful touch
end
local function onScoreBtnRelease()
	
	-- go to level1.lua scene
	local soundOptions = loadTable("soundOptions.json")
    if soundOptions.isOn then sounaudio.fade( {backgroundlullaby, time =1200, volume = 0.2}  ) end
	storyboard.gotoScene( "highscores", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function onUpgradesBtnRelease()
	local soundOptions = loadTable("soundOptions.json")
    if soundOptions.isOn then audio.fade( {backgroundlullaby, time =1200, volume = 0.2}  ) end
	storyboard.gotoScene( "upgrades", "fade", 500 )
	return true
end



-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	group = self.view
	storyboard.removeScene( "level1" )

	-- display a background image
	local background = display.newImageRect( "sleepinglucas.png", 568, 320 )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	

	lampsound = audio.loadSound( "abajur.mp3" )
	lullaby = audio.loadSound( "lullaby.mp3")

	playBtn = display.newRect( display.contentWidth*0.07, display.contentHeight*0.07, display.contentWidth*2/7, display.contentHeight*2/7 )
	playBtn:setFillColor( 255,0,0 )
	playBtn.alpha=0
	playBtn.isHitTestable=true
	
	scoreBtn = widget.newButton{
		labelColor = { default={255}, over={128} },
		defaultFile="button_scores.png",
		overFile="button_scores_down.png",
		width=115, height=50,
		onRelease = onScoreBtnRelease	-- event listener function
	}
	scoreBtn:setReferencePoint( display.CenterReferencePoint )
	scoreBtn.x = display.contentWidth*0.816
	scoreBtn.y = display.contentHeight*0.881

	upgradesBtn = widget.newButton{
		labelColor = { default={255}, over={128} },
		defaultFile="button_upgrades.png",
		overFile="button_upgrades_down.png",
		width=121, height=48,
		onRelease = onUpgradesBtnRelease	-- event listener function
	}
	upgradesBtn:setReferencePoint( display.CenterReferencePoint )
	upgradesBtn.x = display.contentWidth*0.812
	upgradesBtn.y = display.contentHeight*0.734

	

	local soundOn
	local soundOptions

	if loadTable("soundOptions.json") then
		soundOptions = loadTable("soundOptions.json")
		soundOn = soundOptions.isOn
	else
		soundOn = true
		soundOptions = {}
		soundOptions.isOn = soundOn
		saveTable(soundOptions, "soundOptions.json")
	end


	soundBtnOn = display.newImageRect("Speaker_ON.png", 34.5, 35)
	soundBtnOn:setReferencePoint( display.TopLeftReferencePoint )
	soundBtnOff = display.newImageRect( "Speaker_OFF.png",37.5, 35 )
	soundBtnOff:setReferencePoint( display.TopLeftReferencePoint )
	soundBtnOn.x=display.contentWidth*0.01
	soundBtnOn.y=display.contentHeight*17.4/20
	soundBtnOff.x=display.contentWidth*0.01
	soundBtnOff.y=display.contentHeight*17.4/20

	function soundSwitch ( event )
		if soundOn then
			audio.fade(  { backgroundlullaby, time=1, volume=0} )
			soundOn = false
			soundBtnOff.isVisible = true
			soundBtnOn.isVisible = false
			soundOptions.isOn = false
			saveTable(soundOptions, "soundOptions.json")

		else 
			audio.fade(  { backgroundlullaby, time=200, volume=1} )
			soundOn = true
			soundBtnOff.isVisible=false
			soundBtnOn.isVisible=true
			soundOptions.isOn = true
			saveTable(soundOptions, "soundOptions.json")
		end
		return true
	end
	

	if soundOn then
		soundBtnOff.isVisible=false
	else
		soundBtnOn.isVisible=false
	end

	local lampOn = true

	lampBtnOn = display.newImageRect("lampon.png", 76, 85)
	lampBtnOn:setReferencePoint( display.TopRightReferencePoint )
	lampBtnOff = display.newImageRect( "lampoff.png",65, 85 )
	lampBtnOff:setReferencePoint( display.TopRightReferencePoint )
	lampBtnOn.x=display.contentWidth
	lampBtnOn.y=display.contentHeight*2.2/7
	lampBtnOff.x=display.contentWidth
	lampBtnOff.y=display.contentHeight*2.2/7

	function lampSwitch ( event )
		if soundOn then audio.play( lampsound ) end
		if lampOn then
			lampOn = false
			lampBtnOff.isVisible = true
			lampBtnOn.isVisible = false
		else 
			lampOn = true
			lampBtnOff.isVisible=false
			lampBtnOn.isVisible=true
		end
		return true
	end
	lampBtnOff.isVisible=false

	


    

	
	-- all display objects must be inserted into group
	--group:insert( background )
	group:insert(background)
	--group:insert( titleLogo )
	group:insert( playBtn )
	group:insert (scoreBtn)
	group:insert (upgradesBtn)
	group:insert( lampBtnOn )
	group:insert( lampBtnOff )
	group:insert (soundBtnOff)
	group:insert( soundBtnOn)
	lampBtnOn:toFront( )
	function playMusic() 
		backgroundlullaby = audio.play( lullaby, {loops=-1} ) 
		if soundOn==false then
			audio.fade(  { backgroundlullaby, time=1, volume=0} )
		end
	end
	media.playVideo( "tilsix.mov", false, playMusic)	--createFood()
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	
	local group = self.view
	storyboard.removeScene( "level1" )
	storyboard.removeScene( "highscores")
	lampBtnOff:addEventListener( "tap", lampSwitch )
	lampBtnOn:addEventListener( "tap", lampSwitch )
	soundBtnOn:addEventListener( "tap", soundSwitch )
	soundBtnOff:addEventListener( "tap", soundSwitch )
	playBtn:addEventListener( "tap", onPlayBtnRelease )
	local soundOptions = loadTable("soundOptions.json")
	if soundOptions.isOn then audio.fade( {backgroundlullaby, time =1200, volume = 1}  )end
	

	print( "taremovendo" )
	
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	--local function audiostop() audio.stop( backgroundlullaby, 6000 )	end
	--timer.performWithDelay( 6000,audiostop )
	--backgroundlullaby=nil
	lampBtnOn:removeEventListener( "tap", lampSwitch )
	lampBtnOff:removeEventListener( "tap", lampSwitch )
	soundBtnOn:removeEventListener( "tap", soundSwitch )
	soundBtnOff:removeEventListener( "tap", soundSwitch )
	playBtn:removeEventListener( "tap", onPlayBtnRelease)
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	if scoreBtn then
		scoreBtn:removeSelf( )
		scoreBtn= nil
	end
	if upgradesBtn then
		upgradesBtn:removeSelf( )
		upgradesBtn = nil
	end
	
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
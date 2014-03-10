local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"


local function back( )
        storyboard.gotoScene( "menu", "fade", 500 )
end

function scene:createScene( event )

	local group = self.view

	local background = display.newImageRect ("background_game.png", display.contentWidth, display.contentHeight)
	background:setReferencePoint(display.TopLeftReferencePoint)
	background.x=0
	background.y=0

    local comingSoon
    comingSoon1 = display.newText( "COMING", display.contentWidth, display.contentHeight, "Chango", 60 )
    comingSoon2 = display.newText( "SOON", display.contentWidth, display.contentHeight, "Chango", 60 )
    comingSoon1:setReferencePoint( display.CenterCenterReferencePoint )
    comingSoon1.x=display.contentWidth/2
    comingSoon1.y=display.contentHeight/2-30
    comingSoon1:setTextColor( 255, 0, 0 )
    comingSoon2:setReferencePoint( display.CenterCenterReferencePoint )
    comingSoon2.x=display.contentWidth/2
    comingSoon2.y=display.contentHeight/2+30
    comingSoon2:setTextColor( 255, 0, 0 )

    backBtn = widget.newButton{
    labelColor = { default={255}, over={128} },
        defaultFile="button_back.png",
        overFile="button_back.png",
        width=55, height=55,
        onRelease = back
    }
    backBtn.x = display.contentWidth*1.1/20
    backBtn.y = display.contentHeight*1.1/10
    
    
    group:insert( background)
    group:insert( comingSoon1 )
    group:insert( comingSoon2 )
    group:insert(backBtn)

    


end


function scene:enterScene( event )

end

function scene:exitScene (event)


end

function scene:destroyScene (event)
	if backBtn then
        backBtn:removeSelf( )
        backBtn=nil
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


return scene
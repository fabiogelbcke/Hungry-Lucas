local storyboard = require( "storyboard" )
local widget = require("widget")
local scene = storyboard.newScene()

-- load the JSON library.
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
local function back( )
        storyboard.gotoScene( "menu", "fade", 500 )
    end


local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

function scene:createScene( event )

    local group = self.view

    local background = display.newImageRect( "highscores.png", display.contentWidth, display.contentHeight )
    background:setReferencePoint( display.TopLeftReferencePoint )
    background.x=0
    background.y=0
    group:insert( background)


    backBtn = widget.newButton{
    labelColor = { default={255}, over={128} },
        defaultFile="button_back.png",
        overFile="button_back.png",
        width=55, height=55,
        onRelease = back
    }
    backBtn.x = display.contentWidth*1.1/20
    backBtn.y = display.contentHeight*1.1/10
    group:insert(backBtn)
    

    
end

function scene:enterScene (event)
    local group = self.view
    if loadTable("highscores.json") then
        highScoresTable = loadTable("highscores.json")
        print(highScoresTable[1])
        for i=#highScoresTable,1,-1 do
            highScore = highScoresTable[i]
            local dotString
            if highScoresTable[i]>6000 then
                dotString = "."
            elseif highScoresTable[i]>600 then
                dotString = "..."
            else
                dotString = "....."
            end
            if (#highScoresTable-i)<5 then
                if (#highScoresTable-i)==0 then 
                    bestScore = display.newText(string.format( "%dst .....%s...... %d:%2.2d",(#highScoresTable-i+1),dotString,(highScore - highScore%60)/60, highScore%60 ),  display.contentWidth*2.1/13, display.contentHeight*2.8/13 + (#highScoresTable-i)*36, "Anivers",25)
                elseif (#highScoresTable-i)==1 then 
                    bestScore = display.newText(string.format( "%dnd ....%s...... %d:%2.2d",(#highScoresTable-i+1),dotString,(highScore - highScore%60)/60, highScore%60 ),  display.contentWidth*2.1/13, display.contentHeight*2.8/13 + (#highScoresTable-i)*36, "Anivers",25)
                elseif (#highScoresTable-i)==2 then 
                    bestScore = display.newText(string.format( "%drd .....%s...... %d:%2.2d",(#highScoresTable-i+1),dotString,(highScore - highScore%60)/60, highScore%60 ),  display.contentWidth*2.1/13, display.contentHeight*2.8/13 + (#highScoresTable-i)*36, "Anivers",25)
                else
                    bestScore = display.newText(string.format( "%dth ....%s...... %d:%2.2d",(#highScoresTable-i+1),dotString,(highScore - highScore%60)/60, highScore%60 ),  display.contentWidth*2.1/13, display.contentHeight*2.8/13 + (#highScoresTable-i)*36, "Anivers",25)
                end
            else
                if (#highScoresTable-i)==9 then
                    bestScore = display.newText(string.format( "%dth ...%s..... %d:%2.2d",(#highScoresTable-i+1),dotString,(highScore - highScore%60)/60, highScore%60 ),  display.contentWidth*6.8/13, display.contentHeight*5/13 + (#highScoresTable-i-5)*36, "Anivers",25)
                else
                    bestScore = display.newText(string.format( "%dth .....%s..... %d:%2.2d",(#highScoresTable-i+1),dotString,(highScore - highScore%60)/60, highScore%60 ),  display.contentWidth*6.8/13, display.contentHeight*5/13 + (#highScoresTable-i-5)*36, "Anivers",25)
                end
            end
            bestScore:setReferencePoint( display.TopLeftReferencePoint )
            bestScore:setTextColor( 113,68,34)
            group:insert( bestScore)
            bestScore:toFront( )
            print (i)
        end
    else 
        bestScore = display.newText(string.format("0 %s", "vamo porra"),  display.contentWidth*2.1/13, display.contentHeight*3/13, "Anivers",22)
        bestScore:setReferencePoint( display.TopLeftReferencePoint )
        bestScore:setTextColor( 113,68,34)
        group:insert( bestScore)
        bestScore:toFront( )
    end

end

function scene:exitScene (event)


end

function scene:destroyScene ( event )
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

-----------------------------------------------------------------------------------------

return scene
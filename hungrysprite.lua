--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:08d153fbadd32074b97b969de2b3cea5:1e71332299e92656e60bd2a145fc0b24:d5e7318d16e6c68bc3b484563157ee85$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
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

SheetInfo.frameIndex =
{

    ["Gordinho Fase 1-1 suor invertido"] = 1,
    ["Gordinho Fase 1-1 suor"] = 2,
    ["Gordinho correndo 1 (3) copy"] = 3,
    ["Gordinho correndo 1 (3)"] = 4,
    ["Gordinho correndo 2 (2) copy"] = 5,
    ["Gordinho correndo 2 (2)"] = 6,
    ["Gordinho correndo 3 (1) copy"] = 7,
    ["Gordinho correndo 3 (1)"] = 8,
    ["Gordinho correndo 4 (1) copy"] = 9,
    ["Gordinho correndo 4 (1)"] = 10,
    ["Gordinho correndo 5 copy"] = 11,
    ["Gordinho correndo 5"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo

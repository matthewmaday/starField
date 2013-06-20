-- Starfield
-- Development by Matthew Maday
-- DBA - Weekend Warrior Collective
-- a 100% not-for-profit developer collective

-- This is the main scene

display.setStatusBar( display.HiddenStatusBar )

--------------------------------------------------------------------------------------
-- External Libraries
--------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------
-- variable declaritions
--------------------------------------------------------------------------------------

local screen      = display.newGroup()
local gComponents = {}

--------------------------------------------------------------------------------------
-- functions
--------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
-- INIT scene components
--------------------------------------------------------------------------------------

-- loadStarfield()

local function loadStarfield()

	require "application.views.starfield"

	gComponents[#gComponents+1] = {starField=nil}
	gComponents.starField  = LoadStarfield:new({
		size=1,
		centerX=display.contentCenterX,
		centerY=display.contentCenterY,
		image="content/images/star.png",
		speed=1,
		numStars=100,
		width=display.contentWidth,
		height=display.contentHeight
	})

	gComponents.starField:show(300)
	Runtime:addEventListener("enterFrame", function()
	gComponents.starField:process(display.contentCenterX,display.contentCenterY)	
	end
	)
end

--------------------------------------------------------------------------------------
-- scene execution
--------------------------------------------------------------------------------------

loadStarfield()
gComponents.starField:show()
return screen




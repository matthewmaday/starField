-- PILLPOPPER
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

-- loadRipple()

local function loadRipple()

	require "application.views.ripple"

	gComponents[#gComponents+1] = {loadRipple=nil}
	gComponents.loadRipple  = LoadRipple:new({
		speed=5, 
		magnitude=5, 
		source="content/images/test.png", 
		xCellCnt=8,
		yCellCnt=8,
		sheetContentWidth=640,
		sheetContentHeight=480
	})

	gComponents.loadRipple:show(300)

end

--------------------------------------------------------------------------------------
-- scene execution
--------------------------------------------------------------------------------------

loadRipple()
gComponents.loadRipple:pause()
return screen

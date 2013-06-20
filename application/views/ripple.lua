-- starfield class

LoadStarfield = {}

function LoadStarfield:new(params)

	local screen = display.newGroup()

	------------------------------------------------------------------------------------------
	-- Primary Views
	------------------------------------------------------------------------------------------

	-- initialize()
	-- show()
	-- hide()

	function screen:initialize(params)

		self.state = 1   -- 0 = idle, 1 = active, 2 = paused
		self.world = {
			stars           = {},				-- (array) 	an array of all of the star image objects
			size            = params.size,      -- (int) 	the size of the stars
			x               = {},				-- (array)	x positions of all of the stars (the horizontal position)
			y               = {},				-- (array)	y positions of all of the stars (the vertical position)
			z               = {},				-- (array)	z positions of all of the stars (the depth)
			screenX 		= {},
			screenY 		= {},
			numStars        = params.numStars,  -- (int)	the number of stars that will be part of the animation
			images 		    = {},
			dimmer          = {},
			speed 			= params.speed,
			angleXvel       = 0,
			angleYvel       = 0,
			angleZvel       = 0,
			angleX          = 0,
			angleY          = 0,
			angleZ          = 0
		}

		self.sysProps = {
			width  			= params.width,
			height  		= params.height,
			fieldx   		= {},
			fieldy		    = {},
			centerX         = params.centerX,
			centerY         = params.centerY,
			star_Oldscreenx = {},
			star_Oldscreeny = {}
		}

		-- place the stars in their initial positions
		for i=1,self.world.numStars, 1 do
			self.world.x[i] = (math.random(2)*2-3)*math.random(self.sysProps.width)   	-- INIT the x location of the star
			self.world.y[i] = (math.random(2)*2-3)*math.random(self.sysProps.height) 	-- INIT the y location of the star
			self.world.z[i] = math.random(5)*10 										-- INIT the z location of the star      
	        self.sysProps.fieldx[i] = math.random(self.sysProps.width)   
	       	self.sysProps.fieldy[i] = math.random(self.sysProps.height)
	       	self.world.images[i]    = display.newImage( screen, params.image, self.world.x[i], self.world.y[i])
		end

		screen.alpha = 0

	end
	--------
	function screen:show(time)
		transition.to(self, {time = time, alpha = 1, onComplete = function()
			screen.state = 0
		end
		})
	end
	--------
	function screen:hide(time)

		transition.to(self, {time = time, alpha = 0, onComplete = function()
			screen.state = 0
		end
		})
	end	
	--------
	function screen:process(touchX, touchY)

		if self.state == 0 then

		for i=1,self.world.numStars, 1 do
    
     	-- test mouse interaction
	    self.world.x[i] = self.world.x[i] + (self.sysProps.centerX - touchX) * 10 / self.sysProps.centerX
	    self.world.y[i] = self.world.y[i] + (self.sysProps.centerY - touchY) * 10 / self.sysProps.centerX
    
    	-- projections
   		self.world.z[i] = self.world.z[i] - self.world.speed
	    self.world.screenX[i] = (self.world.x[i] / (self.world.z[i]+.001) *15 + self.sysProps.centerX) 
	    self.world.screenY[i] = (self.world.y[i] / (self.world.z[i]+.001) *15 + self.sysProps.centerY)
    
		-- boundry testing

		if (self.world.x[i] < 0) or (self.world.x[i] > self.sysProps.width) or (self.world.y[i] < 0) or (self.world.y[i] > self.sysProps.height) then
			self.world.x[i] = (math.random(2)*2-3)*math.random(self.sysProps.width)   	-- INIT the x location of the star
			self.world.y[i] = (math.random(2)*2-3)*math.random(self.sysProps.height) 	-- INIT the y location of the star
			self.world.z[i] = math.random(5)*10 										-- INIT the z location of the star      
		end
    
--     -- draw the star

    	self.world.images[i].x, self.world.images[i].y = self.world.screenX[i], self.world.screenY[i], b
    	-- self.world.images[i].alpha = self.world.z[i]/1000
   end






		end
	end
	--------
	function screen:pause()

		if self.state == 0 then
			self.state = 2
		elseif self.state == 2 then
			self.state = 0
		end 
	end	
	--------
	function screen:destory()

		local xEnd, yEnd = #self.matrix, #self.matrix[1]
			
		for y = 1,yEnd, 1 do
			for x=1,xEnd, 1 do
				self.matrix[y][x].image:removeSelf()
				self.matrix[y][x].image = nil
			end
		end

		self.matrix  = {}
		self.anchors = {}

	end	
	
	screen:initialize(params)
	return screen

end

return LoadStarfield




-- on generateStarfield pMemberResult, pSize, pColor, pSpeed, pStarCount, pFieldW, pFieldH
  
--   global screen.world
  
--   -- [1] x, [2] y, [3] z, [4] star_screenx, [5] star_screeny
--   -- [6] centerX, [7] centerY [8] source image [9] star 
--   -- [10] dimmer, [11]star_Oldscreenx, [12] star_Oldscreeny, [13] angleXvel [14] angleYvel
--   -- [15] angleZvel [16] angleX [17] angleY [18] angleZ
  
--   -- Initial setup
--   if voidp(screen.world) then
    
--     -- draw background
--     -- INIT the main star array
--     screen.world = [ [], [], [], [], [], pFieldW/2, pFieldH/2, image(pFieldW, pFieldH,the colorDepth), image(pSize[1]*2, pSize[2]*2, the colorDepth), [],[],[],0,0,0,0,0,0] 
    
--     -- draw background star field
--     screen.world.source_image.fill(0, 0, pFieldW, pFieldH, [#color: rgb(0, 0, 0)])
    
--     repeat with i = 1 to pStarCount
--       l = point(math.random(pFieldW), math.random(pFieldH))
--       r = rect(l[1] - screen.world.size, l[2] - screen.world.size, l[1] + screen.world.size, l[2] + screen.world.size)
--       screen.world.source_image.copyPixels(screen.world.star, r, screen.world.star.rect, [#blendlevel:30])
--     end repeat
    
--     -- clear buffer
--     member(pMemberResult).image = screen.world.source_image
    
--     -- draw the star
--     screen.world.star.fill(0,0,pSize[1]*2,pSize[2]*2,pColor)
    
--     -- INIT values for the stars
--     repeat with i = 1 to pStarCount
--       append screen.world.x,  ( (math.random(2)*2 - 3)*math.random(pFieldW) )  -- INIT the x location of the star
--       append screen.world.y,  ( (math.random(2)*2 - 3)*math.random(pFieldH) )  -- INIT the y location of the star
--       append screen.world.z,  ( math.random(5)*10 )                       -- INIT the z location of the star
--       append screen.world.star_screenx,  math.random(pFieldW)                             -- INIT the x drawing range
--       append screen.world.star_screeny,  math.random(pFieldH)                             -- INIT the y drawing range
--     end repeat
    
--   end if 
  
--   -- clean up
--   repeat with i = 1 to pStarCount
--     l = point(screen.world.star_screenx[i], screen.world.star_screeny[i])
--     r = rect(l[1] - pSize[1], l[2] - pSize[2], l[1] + pSize[1], l[2] + pSize[2])
--     member(pMemberResult).image.copyPixels(screen.world.source_image, r, r)
--   end repeat
  
--   repeat with i = 1 to pStarCount
    
--     -- test mouse interaction
--     screen.world.x[i] = screen.world.x[i] + (screen.world.centerX - the mouseH) * 10 / screen.world.centerX
--     screen.world.y[i] = screen.world.y[i] + (screen.world.centerY - the mouseV) * 10 / screen.world.centerX
    
    
--     -- projections
--     screen.world.z[i] = screen.world.z[i] - pSpeed
--     screen.world.star_screenx[i] = (screen.world[1][i] / (screen.world.z[i]+.000001) *15 + screen.world.centerX) 
--     screen.world.star_screeny[i] = (screen.world.y[i] / (screen.world.z[i]+.000001) *15 + screen.world.centerY)
    
--     -- boundry testing
--     if NOT inside( point(screen.world.star_screenx[i], screen.world.star_screeny[i]), member(pMemberResult).rect+member(pMemberResult).rect) then
--       screen.world.x[i] = ( (math.random(2)*2 - 3)*math.random(pFieldW) )     -- INIT the x location of the star
--       screen.world.y[i] = ( (math.random(2)*2 - 3)*math.random(pFieldH) )     -- INIT the y location of the star
--       screen.world.z[i] = ( math.random(5)*10 )                          -- INIT the z location of the star
--     end if
    
--     -- draw the star
--     b = 100-(screen.world.z[i]*(100./50.))
--     l = point(screen.world.star_screenx[i], screen.world.star_screeny[i])
--     r = rect(l[1] - pSize[1], l[2] - pSize[2], l[1] + pSize[1], l[2] + pSize[2])
    
--     member(pMemberResult).image.copyPixels(screen.world.star, r, screen.world.star.rect, [#blendlevel:b])
    
--   end repeat
  
-- end

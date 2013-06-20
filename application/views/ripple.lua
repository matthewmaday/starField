-- ripple panel

LoadRipple = {}
local widget = require( "widget" )

function LoadRipple:new(params)

	local screen = display.newGroup()

	------------------------------------------------------------------------------------------
	-- Primary Views
	------------------------------------------------------------------------------------------

	-- initialize()
	-- show()
	-- hide()

	function screen:initialize(params)

	screen.state = 1   -- 0 = idle, 1 = active, 2 = paused

	-- params
		-- (int) speed 				the speed in which all intersection points move. (normally 1-10)
		-- (int) resolution  		the number of total cells within the matrix. (normal range 5-20)
		-- (int) magnitude 			the amount of distortion (normal range 3-10)
		-- (str) source 			the path to the source image
		-- (int) xCellCnt	  		the number of horizontal divisions in the effect. (normal range 5-20)
		-- (int) yCellCnt			the number of vertical divisions in the effect. (normal range 5-20)
		-- (int) sheetContentWidth	the width of the source image
		-- (int) sheetContentHeight	the height of the source image

		local width,height = params.sheetContentWidth/params.xCellCnt, params.sheetContentHeight/params.yCellCnt
		local options = {
			width     = width,                                -- width of one frame
			height    = height,                               -- height of one frame
			numFrames = params.xCellCnt*params.yCellCnt,      -- total number of frames in spritesheet
		    sheetContentWidth = params.sheetContentWidth,     -- width of original 1x size of entire sheet
    		sheetContentHeight = params.sheetContentHeight    -- height of original 1x size of entire sheet
		}

		-- initialize the image sheet
		self.image = graphics.newImageSheet(params.source, options)

		
		self.matrix  = {}	-- create matrix table
		self.anchors = {}	-- create matrix of intersection points

		local cnt    = 1
		local column = {}

		local rows, columns = params.yCellCnt, params.xCellCnt
		
		for y = 1,columns, 1 do
			column = {}
			for x=1,rows, 1 do

				local img =  display.newImageRect(self.image, cnt, width, height)

				column[#column+1]     = {image=nil}
				column[#column].image = img

				img.x, img.y = (x-1)*width, (y-1)*height
				cnt = cnt+1
				self:insert(img)
			end
			self.matrix[#self.matrix+1] = column
		end


		local rows, columns = params.yCellCnt, params.xCellCnt

		for y = 1,rows, 1 do
			column = {}
			for x=1,columns, 1 do

				column[#column+1] = {
					angle     = math.random(360),
					magnitude = params.magnitude,
					speed     = params.speed
				}

			end

			self.anchors[#self.anchors+1] = column
		end

		self.alpha = 1

		screen:addEventListener("touch", function()
			screen:pause()
		end
		)
		Runtime:addEventListener("enterFrame", function() 
			screen:process() 
		end
			)
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
	function screen:process()
		
		if self.state == 0 then

		local xEnd, yEnd, rads = #self.anchors, #self.anchors[1], 0
			
			-- update transformations
			for y = 1,yEnd, 1 do
				for x=1,xEnd, 1 do
				local ang = self.anchors[y][x].angle + self.anchors[y][x].speed
					
					if ang > 360 then
						ang = ang-360
					elseif ang < 0 then 
						ang = ang + 360
					end
					
					self.anchors[y][x].angle = ang
				end
			end

			-- render transformations
			for y = 1,xEnd, 1 do
				for x=1,yEnd, 1 do

					local props = nil
					local xPos, yPos = x+1, y+1

					if xPos > xEnd then xPos = x end
					if yPos > yEnd then yPos = y end

					-- upper left
					props = self.anchors[y][x]
					rads = props.angle * (math.pi / 180.0)
					self.matrix[y][x].image.x1 = props.magnitude/2 * math.cos(rads) 
					self.matrix[y][x].image.y1 = props.magnitude/2 * math.sin(rads)

					-- lower left
					props = self.anchors[yPos][x]
					rads = props.angle * (math.pi / 180.0)
					self.matrix[y][x].image.x2 = props.magnitude/2 * math.cos(rads)
					self.matrix[y][x].image.y2 = props.magnitude/2 * math.sin(rads)

					-- lower right
					props = self.anchors[yPos][xPos]
					rads = props.angle * (math.pi / 180.0)
					self.matrix[y][x].image.x3 = props.magnitude/2 * math.cos(rads)
					self.matrix[y][x].image.y3 = props.magnitude/2 * math.sin(rads)

					-- lower right
					props = self.anchors[y][xPos]
					rads = props.angle * (math.pi / 180.0)
					self.matrix[y][x].image.x4 = props.magnitude/2 * math.cos(rads)
					self.matrix[y][x].image.y4 = props.magnitude/2 * math.sin(rads)

				end
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

return LoadRipple

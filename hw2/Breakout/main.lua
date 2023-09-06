-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Assets by Kenney
-- kenney.nl

-- Background

local numBackgrounds = math.ceil(display.actualContentWidth / display.actualContentHeight)

for i = 0, numBackgrounds - 1, 1
do 
    local background = display.newImageRect("assets/uncolored_plain.png", display.actualContentHeight, display.actualContentHeight)
    background.x = display.screenOriginX + display.actualContentHeight / 2 + display.actualContentHeight * i
    background.y = display.screenOriginY + display.contentCenterY
end

local physics = require( "physics" )
physics.start()
physics.setGravity(0, 0)

-- Bricks

local brickWidth = 64
local brickHeight = 32
local brickMargin = 10

local numBricksHorizontal = math.floor(display.actualContentWidth / (brickWidth + brickMargin))
local remainder = display.actualContentWidth % (brickWidth + brickMargin) - 10
local additionalMargin = remainder / (numBricksHorizontal + 1)
local horizontalBrickMargin = brickMargin + additionalMargin

local numBricksVertical = 3

local assetOptions = {
    "assets/element_blue_rectangle.png", 
    "assets/element_green_rectangle.png",
    "assets/element_purple_rectangle.png",
    "assets/element_red_rectangle.png",
    "assets/element_yellow_rectangle.png"
}
math.randomseed(os.time())

for i = 0, numBricksVertical - 1, 1
do 
    for j = 0, numBricksHorizontal - 1, 1
    do
        local brick = display.newImageRect(assetOptions[math.random(1, table.getn(assetOptions))], brickWidth, brickHeight)
        brick.x = display.screenOriginX + brickWidth / 2 + horizontalBrickMargin + (brickWidth + horizontalBrickMargin) * j
        brick.y = display.screenOriginY + brickHeight / 2 + brickMargin + (brickHeight + brickMargin) * i
        physics.addBody(brick, "static")
    end
end

-- Paddle

local paddle = display.newImageRect("assets/paddleRed.png", 104, 24)
paddle.x = display.contentCenterX
paddle.y = display.contentHeight - paddle.contentHeight
physics.addBody(paddle, "kinematic")

local function onMouseEvent(event)
    paddle.x = event.x
end

Runtime:addEventListener( "mouse", onMouseEvent)

-- Borders

local borderLeft = display.newRect(display.screenOriginX - 5, display.contentCenterY, 10, display.actualContentHeight)
physics.addBody(borderLeft, "static")
local borderRight = display.newRect(display.screenOriginX + display.actualContentWidth + 5, display.contentCenterY, 10, display.actualContentHeight)
physics.addBody(borderRight, "static")
local borderTop = display.newRect(display.contentCenterX, display.screenOriginY - 5, display.actualContentWidth, 10)
physics.addBody(borderTop, "static")

-- Ball

local ball = display.newImageRect("assets/ballBlue.png", 16, 16)
ball.x = display.contentCenterX
ball.y = display.contentCenterY
physics.addBody(ball, "dynamic", {radius=8, bounce=1.0})
ball:applyLinearImpulse((math.random() - 0.5) / 20, (math.random() - 0.5) / 20, ball.x, ball.y)

local function onBallCollision(self, event)
    if event.other.contentWidth == brickWidth -- Identifying objects like the professional developer I am...
    then
        display.remove(event.other)
    end
end
ball.postCollision = onBallCollision
ball:addEventListener("postCollision")
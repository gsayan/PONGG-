Class = require "class"
require "Ball"
require "Paddle"
require "Wall"

BACKGROUND_RED = 30
BACKGROUND_GREEN = 30
BACKGROUND_BLUE = 55

BALL_RADIUS = 6

FONT_WELCOME_ONE = "fonts/Nervous.ttf"
FONT_WELCOME_TWO = "fonts/pointfree.ttf"
FONT_INSTRUCTIONS_ONE = "fonts/NovaMono-Regular.ttf"
FONT_INSTRUCTIONS_TWO = "fonts/FiraSans-Light.ttf"
FONT_SCOREBOARD = "fonts/DS-DIGI.ttf"
FONT_VICTORY_MESSAGE = "fonts/PatrickHand-Regular.ttf"

SOUND_HIT_WALL = "sounds/hit_wall.wav"
SOUND_HIT_PADDLE = "sounds/hit_paddle.wav"
SOUND_PASS = "sounds/pass.wav"
SOUND_POINT = "sounds/point.wav"
SOUND_BACKGROUND = "sounds/background.wav"
SOUND_PADDLE_REFLECT = "sounds/paddle_reflect.wav"
SOUND_WIN = "sounds/playerwin.wav"
SOUND_LOSE = "sounds/computerwin.wav"

function love.load()
    actualWidth, actualHeight = love.window.getDesktopDimensions( display )
    --[[screenWidth = 4 * actualWidth
    screenHeight = 4 * actualHeight
    push:setupScreen(screenWidth, screenHeight,actualWidth, actualHeight,{
        fullscreen = true,
        resizable = false,
        vsync = false
    })
    ]]
    screenWidth = actualWidth
    screenHeight = actualHeight
    love.window.setMode(screenWidth, screenHeight,{
        resizable = false,
        fullscreen = true
    })
    love.window.setTitle("Pongg")
    math.randomseed(os.time())

    lineGapOne = screenHeight / 10

    fontWelcomeOne = love.graphics.newFont(FONT_WELCOME_ONE, 50)
    fontWelcomeTwo = love.graphics.newFont(FONT_WELCOME_TWO, 30)
    fontInstructionsOne = love.graphics.newFont(FONT_INSTRUCTIONS_ONE, 40)
    fontInstructionsTwo = love.graphics.newFont(FONT_INSTRUCTIONS_TWO, 30)
    fontScoreoard = love.graphics.newFont(FONT_SCOREBOARD, 100)
    fontVictory = love.graphics.newFont(FONT_VICTORY_MESSAGE, 60)

    soundHitWall = love.audio.newSource(SOUND_HIT_WALL, 'static')
    soundHitPaddle = love.audio.newSource(SOUND_HIT_PADDLE, 'static')
    soundPass = love.audio.newSource(SOUND_PASS, 'static')
    soundPoint = love.audio.newSource(SOUND_POINT,'static')
    soundBackground = love.audio.newSource(SOUND_BACKGROUND, 'static')
    soundBackground:setLooping(true)
    soundPaddleReflect = love.audio.newSource(SOUND_PADDLE_REFLECT,'static')
    soundWin = love.audio.newSource(SOUND_WIN, 'static')
    soundLose = love.audio.newSource(SOUND_LOSE, 'static')

    gameMode = 'welcome'

    ball = Ball(BALL_RADIUS, screenWidth / 2 - BALL_RADIUS, screenHeight / 2 - BALL_RADIUS)

    vball1 = Ball(BALL_RADIUS, screenWidth / 4, 0)
    vball1.vx = 1
    vball1.vy = 1
    vball2 = Ball(BALL_RADIUS, screenWidth / 4 * 3, 0)
    vball2.vx = 1
    vball2.vy = 1

    wall1 = Wall(screenWidth, screenHeight, 0)
    wall2 = Wall(screenWidth, screenHeight, screenWidth)

    paddle1 = Paddle(screenWidth / 5, screenHeight, screenWidth, screenHeight)
    paddle2 = Paddle(screenWidth / 5 * 4, 0, screenWidth, screenHeight)

    playerScore = 0
    computerScore = 0

    
end

function love.keypressed(key)
    if key == 'q' then
        love.event.quit()
    end
    if gameMode == 'welcome' then
        if key == 'i' then
            gameMode = 'instructions'
        elseif key == 'return' then
            gameMode = 'serve'
        end
    elseif gameMode == 'instructions' then
        if key == 'escape' then
            gameMode = 'welcome'
        elseif key == 'right' then
            gameMode = 'tips'
        end
    elseif gameMode == 'tips' then
        if key == 'escape' then
            gameMode = 'welcome'
        elseif key == 'left' then
            gameMode = 'instructions'
        end
    elseif gameMode == 'serve' then
        if key == 'space' then
            gameMode = 'play'
        elseif key == 'escape' then
            gameMode = 'welcome'
        end
    elseif gameMode == 'computerwins' or gameMode == 'playerwins' then
        if key == 'return' then
            gameMode = 'serve'
        elseif key == 'escape' then
            gameMode = 'welcome'
        end
    end
end


function love.update(dt)
    if gameMode == 'play' then
        if love.keyboard.isDown("escape") then
            gameMode = 'welcome'
        end
        love.audio.stop(soundBackground)
        if ball:collWall(wall1) then
            ball:retWall(wall1)
            soundHitWall:play()
        elseif ball:collWall(wall2) then
            ball:retWall(wall2)
            soundHitWall:play()
        end
        if ball:collPad(paddle1) then
            ball:retPad(paddle1)
            soundHitPaddle:play()
        elseif ball:collPad(paddle2) then
            ball:retPad(paddle2)
            soundHitPaddle:play()
        end

        if love.keyboard.isDown('left') then
            paddle1.ax = -2000 - paddle1.vx
        elseif love.keyboard.isDown('right') then
            paddle1.ax = 2000 - paddle1.vx
        else
            paddle1.ax = - paddle1.vx
        end


        paddle2:action(ball)

        paddle1.vx = paddle1.vx + paddle1.ax * dt
        if paddle1:reflect() == "R" then
            
            love.audio.play(soundPaddleReflect)
            paddle1.originX = math.min(screenWidth - 1 - paddle1.length / 2, paddle1.originX + paddle1.vx * dt)
            --if paddle1.vx == 0 then
              --  paddle1.vx = -10
            --end
        elseif paddle1:reflect() == "L" then
            paddle1.vx = - paddle1.vx
            paddle1.originX = math.max(1 + paddle1.length / 2, paddle1.originX + paddle1.vx * dt)
            love.audio.play(soundPaddleReflect)
            --if paddle1.vx == 0 then
              --  paddle1.vx = 10
            --end
        else
            paddle1.originX = paddle1.originX + paddle1.vx * dt
        end
        paddle2.vx = paddle2.vx + paddle2.ax * dt
        if paddle2:reflect() == "R" then
            love.audio.play(soundPaddleReflect)
            
            paddle2.originX = math.min(screenWidth - 1 - paddle2.length / 2, paddle2.originX + paddle2.vx * dt)
            --if paddle2.vx == 0 then
              --  paddle1.vx = -10
            --end
        elseif paddle2:reflect() == "L" then
            love.audio.play(soundPaddleReflect)
            paddle2.vx = - paddle2.vx
            paddle2.originX = math.max(1 + paddle2.length / 2, paddle2.originX + paddle2.vx * dt)
            --if paddle2.vx == 0 then
              --  paddle2.vx = 10
            --end
        else
            paddle2.originX = paddle2.originX + paddle2.vx * dt
        end


        ball:update(dt)
        if ball.x <= 0 or ball.x >= screenWidth then
            soundPass:play()
            ball:reset(screenWidth / 2, screenHeight / 2)
            ball:render()
            paddle1:reset()
            paddle2:reset()
            gameMode = 'serve'
        end
        if ball.y <= 0 then
            soundPoint:play()
            ball:reset(screenWidth / 2, screenHeight / 2)
            ball:render()
            paddle1:reset()
            paddle2:reset()
            playerScore = playerScore + 1
            if playerScore == 6 then
                gameMode = 'playerwins'
                playerScore = 0
                computerScore = 0
                soundWin:play()
            else
                gameMode = 'serve'
            end
        elseif ball.y >= screenHeight then
            soundPoint:play()
            ball:reset(screenWidth / 2, screenHeight / 2)
            ball:render()
            paddle1:reset()
            paddle2:reset()
            computerScore = computerScore + 1
            if computerScore == 6 then
                gameMode = 'computerwins'
                playerScore = 0
                computerScore = 0
                soundLose:play()
            else
                gameMode = 'serve'
            end
        end
    elseif gameMode == 'serve' then
        paddle1:reflect()
        paddle2:reflect()
        if love.keyboard.isDown('left') then
            paddle1.ax = -2000 - paddle1.vx
        elseif love.keyboard.isDown('right') then
            paddle1.ax = 2000 - paddle1.vx
        else
            paddle1.ax = - paddle1.vx
        end
        
        if paddle2.originX >= screenWidth / 4 * 3 then
            destination = paddle2.originX + paddle2.vx / 5
            if destination >= screenWidth / 5 * 4 then
                moveleft(paddle2)
            else
                stop(paddle2)
            end
        elseif paddle2.originX <= screenWidth / 4 then
            destination = paddle2.originX + paddle2.vx / 5
            if destination <= screenWidth / 5 then
                moveright(paddle2)
            else
                stop(paddle2)
            end
        else
            stop(paddle2)
        end

        paddle1.vx = paddle1.vx + paddle1.ax * dt
        if paddle1:reflect() == "R" then
            love.audio.play(soundPaddleReflect)
            paddle1.originX = math.min(screenWidth - 1 - paddle1.length / 2, paddle1.originX + paddle1.vx * dt)
        elseif paddle1:reflect() == "L" then
            
            paddle1.vx = - paddle1.vx
            paddle1.originX = math.max(1 + paddle1.length / 2, paddle1.originX + paddle1.vx * dt)
            
            love.audio.play(soundPaddleReflect)
        else
            paddle1.originX = paddle1.originX + paddle1.vx * dt
        end
        paddle2.vx = paddle2.vx + paddle2.ax * dt
        if paddle2:reflect() == "R" then
            love.audio.play(soundPaddleReflect)
            paddle2.originX = math.min(screenWidth - 1 - paddle1.length / 2, paddle2.originX + paddle2.vx * dt)
        elseif paddle1:reflect() == "L" then
            love.audio.play(soundPaddleReflect)
            paddle2.vx = - paddle2.vx
            paddle2.originX = math.max(1 + paddle2.length / 2, paddle2.originX + paddle2.vx * dt)
        else
            paddle2.originX = paddle2.originX + paddle2.vx * dt
        end
    elseif gameMode == 'welcome' then
        soundBackground:play()
    end
end

function love.draw()
    love.graphics.clear(BACKGROUND_RED / 255, BACKGROUND_GREEN / 255, BACKGROUND_BLUE / 255)
    --love.graphics.printf(gameMode, screenWidth / 4, screenHeight / 8, screenWidth / 2, 'center')

    if gameMode == 'welcome' then
        love.graphics.setFont(fontWelcomeOne)
        love.graphics.printf("Welcome to PONGG!", screenWidth / 4, screenHeight / 5, screenWidth / 2, 'center')
        love.graphics.setFont(fontWelcomeTwo)
        love.graphics.printf("Press Q to exit anytime", screenWidth / 4, screenHeight / 3, screenWidth / 2, 'center')
        love.graphics.printf("Press I to continue to instructions", screenWidth / 4, screenHeight / 3 + lineGapOne, screenWidth / 2, 'center')
        love.graphics.printf("Press ENTER to continue BATTLE!", screenWidth / 4, screenHeight / 3 + 2*lineGapOne, screenWidth / 2, 'center')
    end
    
    if gameMode == 'instructions' then
        love.graphics.setFont(fontInstructionsOne)
        love.graphics.printf("INSTRUCTIONS", screenWidth / 4, screenHeight / 6, screenWidth / 2, 'center')
        love.graphics.setFont(fontInstructionsTwo)
        love.graphics.printf("You are in control of the bottom paddle. Your opponent is the top paddle.\n" ..
        "Use the arrow keys (left and right) to accelerate your paddle. Remember, the paddle will deaccelerate on its own when you are not pressing any arrow keys\n" ..
        "When the ball touches the upper side, you gain one point. When it touches the lower side, your opponent gains one point. The player to score 6 points the soonest wins the game.\n"..
        "If the ball passes through the space in left or right side, the game comes back to serving and no one gains any point.\n" ..
        "Press ESCAPE to go back to welcome screen. Press SPACE to pause the game and Q to quit anytime\n" ..
        "Press right arrow key to go to next page",
        screenWidth / 9, screenHeight / 6 + lineGapOne, screenWidth / 9 * 7, 'center')
    end

    if gameMode == 'tips' then
        love.graphics.setFont(fontInstructionsOne)
        love.graphics.printf("TIPS", screenWidth / 4, screenHeight / 6, screenWidth / 2, 'center')
        love.graphics.setFont(fontInstructionsTwo)
        love.graphics.printf("Be careful where the ball hits. A curved surface will deflect the ball.\n" ..
        "Your paddle cannot cross the screen. Be careful when it hits the edges. It will reflect back.\n" ..
        "The ball's speed depends upon how your paddle hits it. If you hit it very hard, it will speed up. Careful control of paddle can also slow down the ball.\n"..
        "Press left arrow key to go to the previous page\n"..
        "GOOD LUCK!",
        screenWidth / 9, screenHeight / 6 + lineGapOne, screenWidth / 9 * 7, 'center')
    end

    if gameMode == 'serve' or gameMode == 'play' then
        love.graphics.setFont(fontScoreoard)
        love.graphics.printf(tostring(playerScore), screenWidth / 4, screenHeight / 4, screenWidth / 4, 'center')
        love.graphics.printf(tostring(computerScore), screenWidth / 2, screenHeight / 4, screenWidth / 4, 'center')
        ball:render()
        wall1:render()
        wall2:render()
        paddle1:render()
        paddle2:render()
    end

    if gameMode == 'playerwins' then
        love.graphics.setFont(fontVictory)
        love.graphics.printf("Congratulations!\nYou won", 0, screenHeight / 5, screenWidth, 'center')
        love.graphics.setFont(fontInstructionsTwo)
        love.graphics.printf("Press ENTER to play again\nPress ESCAPE to go back to main menu", 0, screenHeight / 4 * 3, screenWidth, 'center')
    end

    if gameMode == 'computerwins' then
        love.graphics.setFont(fontVictory)
        love.graphics.printf("Computer won against you\nBetter luck next time", 0, screenHeight / 5, screenWidth, 'center')
        love.graphics.setFont(fontInstructionsTwo)
        love.graphics.printf("Press ENTER to play again\nPress ESCAPE to go back to main menu", 0, screenHeight / 4 * 3, screenWidth, 'center')
    end
end


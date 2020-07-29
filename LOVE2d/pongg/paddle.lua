Paddle = Class{}

function Paddle:init(x, y, scrWidth, scrHeight)
    self.originX = x
    self.originY = y 
    self.length = scrWidth / 6
    self.height = scrHeight / 20
    self.x = self.originX + self.length / 2
    self.y = self.originY - self.height / 2
    self.vx = 0
    self.ax = 0
end

function Paddle:render()
    love.graphics.ellipse('fill', self.originX, self.originY, self.length / 2, self.height / 2, 20000)
end

function Paddle:reset()
    self.vx = 0
    self.ax = 0
    love.graphics.ellipse('fill', self.originX, self.originY, self.length / 2, self.height / 2, 20000)
end

function moveright(paddle)
    paddle.ax = 2000 - paddle.vx
end

function moveleft(paddle)
    paddle.ax = -2000 - paddle.vx
end

function stop(paddle)
    paddle.ax = - paddle.vx
end

function Paddle:action(ball)
    if ball.vy < 0 then
        time = - ball.y / ball.vy
        currentSpeed = self.vx
        destination = ball.x + ball.vx * time
        distance = destination - self.originX
        if distance < 1.5 * self.vx * time then
            moveleft(self)
            --self.ax = -2000 - self.vx
        elseif distance > 1.5 * self.vx * time then
            self.ax = 2000 - self.vx
        else
            self.ax = - self.vx
        end
    else
        self.ax = - self.vx
    end
end

function Paddle:reflect()
    if self.originX + self.length / 2 >= 6 * self.length then
        self.vx = - self.vx
        --self.ax = 0
        self.originX = self.originX
        return "R"
    elseif self.originX - self.length / 2 <= 0 then
        self.vx = - self.vx
        --self.ax = 0
        self.originX = self.originX
        return "L"
    else
        return "N"
    end
end

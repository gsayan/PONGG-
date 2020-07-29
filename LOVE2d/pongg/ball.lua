Ball = Class{}

function Ball:init(radius, x, y)
    self.radius = radius
    self.x = x
    self.y = y
    speed = 300
    angle = math.random(math.pi / 3, 2*math.pi / 3)
    self.vx = speed * math.cos(angle)
    self.vy = speed * math.sin(angle)
--[[    while self.vx < 70 do
        self.vx = math.random(-30, 30)
        self.vy = math.random(-30, 30)
        speed = math.sqrt(self.vx*self.vx + self.vy*self.vy)
        self.vx = (self.vx / speed) * 20
        self.vy = (self.vy / speed) * 20
    end]]
end

function Ball:render()
    love.graphics.setColor(1, 1, 1)
    --love.graphics.circle('fill', fixPositionX(self.x, screenWidth), fixPositionY(self.y, screenHeight), self.radius)
    love.graphics.circle('fill', self.x, self.y, self.radius)
end

function Ball:reset(x, y)
    self.x = x
    self.y = y
    --love.graphics.circle('fill', self.x, self.y, self.radius)
    speed = 300
    angle = math.random(math.pi / 3, 2*math.pi / 3)
    self.vx = speed * math.cos(angle)
    self.vy = speed * math.sin(angle)
--[[    while self.vx < 70 do
        self.vx = math.random(-30, 30)
        self.vy = math.random(-30, 30)
        speed = math.sqrt(self.vx*self.vx + self.vy*self.vy)
        self.vx = (self.vx / speed) * 20
        self.vy = (self.vy / speed) * 20
    end]]
end

function Ball:update(dt)
    ball.x = ball.x + ball.vx * dt
    ball.y = ball.y + ball.vy * dt
end

function Ball:collWall(wall)
    bx = self.x
    wx = wall.originX
    by = self.y
    wy = wall.originY
    relx = bx - wx
    rely = by - wy
    radx = wall.radx1
    rady = wall.rady
    radxx = radx + self.radius
    radyy = rady + self.radius
    dist = relx*relx + rely*rely
    mdist = rely*rely * (1 - (radxx*radxx) / (radyy*radyy)) + radxx*radxx
    if dist <= mdist then
        return true
    else
        return false
    end
end

function Ball:retWall(wall)
    relx = self.x - wall.originX
    rely = self.y - wall.originY
    a = wall.radx1
    b = wall.rady
    --speed = math.sqrt(self.vx*self.vx + self.vy*self.vy)
    m = - (relx * b*b) / (rely * a*a)
    bangle = math.atan2(self.vy, self.vx)
    --if m < 0 then
    angle = math.atan(m)
    relangle = bangle - angle
    vx1 = self.vx * math.cos(angle) + self.vy * math.sin(angle)
    vy1 = self.vy * math.cos(angle) - self.vx * math.sin(angle)
    vy1 = -vy1
    self.vx = vx1 * math.cos(angle) - vy1 * math.sin(angle)
    self.vy = vy1 * math.cos(angle) + vx1 * math.sin(angle)
end

function Ball:collPad(pad)
    bx = self.x
    wx = pad.originX
    by = self.y
    wy = pad.originY
    relx = bx - wx
    rely = by - wy
    radx = pad.length / 2
    rady = pad.height / 2
    radxx = radx + self.radius
    radyy = rady + self.radius
    dist = relx*relx + rely*rely
    mdist = rely*rely * (1 - (radxx*radxx) / (radyy*radyy)) + radxx*radxx
    if dist <= mdist then
        return true
    else
        return false
    end
end

function Ball:retPad(pad)
    relx = self.x - pad.originX
    rely = self.y - pad.originY
    a = pad.length / 2
    b = pad.height / 2
    --speed = math.sqrt(self.vx*self.vx + self.vy*self.vy)
    m = - (relx * b*b) / (rely * a*a)
    --bangle = math.atan2(self.vy, self.vx)
    --if m < 0 then
    angle = math.atan(m)
    --relangle = bangle - angle
    vx1 = self.vx - pad.vx
    vy1 = self.vy
    vx2 = vx1 * math.cos(angle) + vy1 * math.sin(angle)
    vy2 = vy1 * math.cos(angle) - vx1 * math.sin(angle)
    vy2 = -vy2
    vx3 = vx2 * math.cos(angle) - vy2 * math.sin(angle)
    vy3 = vy2 * math.cos(angle) + vx2 * math.sin(angle)
    self.vx = vx3 + pad.vx
    self.vy = vy3
end
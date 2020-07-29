Wall = Class{}

function Wall:init(scrWidth, scrHeight, orx)
    H = scrHeight / 7 * 5
    L = scrWidth / 50
    if orx == 0 then
        self.originX = 0
        self.left = - L
        self.right = L
        self.mode = 'L'
    else
        self.originX = scrWidth
        self.left = scrWidth - L
        self.right = scrWidth + L
        self.mode = 'R'
    end
    self.originY = scrHeight / 2
    self.top = scrHeight - H
    self.bottom = H
    self.radx1 = L
    self.radx2 = L / 3
    self.rady = H / 2
end

function Wall:render()
    love.graphics.ellipse('fill', self.originX, self.originY, self.radx1, self.rady, 20000)
end
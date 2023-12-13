Moeda = Classe:extend()

function Moeda:new()
    self.x = 10*0.15
    self.y = 56*TAM_BLOCO*0.15

    self.img = love.graphics.newImage("Sprites/background/moeda.png")
    self.largura = self.img:getWidth()
    self.altura = self.img:getHeight()
    self.largura_q = 230
    self.altura_q = 329
    
    local grid = anim.newGrid(230, 329, self.largura, self.altura)
    self.animation = anim.newAnimation(grid('1-4', 1, '1-4', 2, '1-4', 3, '1-4', 4), 0.1)

    self.quantidade = 60
end

function Moeda:update(dt)
    self.animation:update(dt)
end

function Moeda:draw ()
    love.graphics.push()
    love.graphics.scale(0.15, 0.15)
    self.animation:draw(self.img, 1* TAM_BLOCO * 0.15, 58*TAM_BLOCO*0.15)
    love.graphics.pop()

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("x"..self.quantidade, 50, 516)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("x"..self.quantidade, 48, 514)
end

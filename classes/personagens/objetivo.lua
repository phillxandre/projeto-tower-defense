Objetivo = Classe:extend()

function Objetivo:new()
    self.img = love.graphics.newImage("Sprites/personagens/objetivo.png")
    self.img_vida = love.graphics.newImage("Sprites/background/vida.png")
    self.vida = 100
    self.posicao = Vector(0, 4*TAM_BLOCO)

    local g_vida = anim.newGrid(230, 230, self.img_vida:getWidth(), self.img_vida:getHeight())
    self.anim_vida = anim.newAnimation(g_vida('1-3', 1, '1-3', 2, '1-1', 3), 0.1)
end

function Objetivo:update(dt)
    self.anim_vida:update(dt)

    if vida_bonus == 20 then
        self.vida = self.vida + 10
        vida_bonus = 0
    end
end

function Objetivo:draw()
    -- CASA
    love.graphics.push()
    love.graphics.scale(0.25, 0.25)
    love.graphics.draw(self.img, self.posicao.x, self.posicao.y)
    love.graphics.pop()

    -- VIDA
    love.graphics.push()
    love.graphics.scale(0.15, 0.15)
    self.anim_vida:draw(self.img_vida, 20*TAM_BLOCO*0.15, 58.5*TAM_BLOCO*0.15)
    love.graphics.pop()

    -- PONTOS DE VIDA
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("x"..self.vida, 222, 516)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("x"..self.vida, 220, 514)

end

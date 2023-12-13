Bomba = Classe:extend()

function Bomba:new(x, y)
    self.audio_explosion = love.audio.newSource("audio/musket-explosion-6383.mp3", "stream")

    self.img_explosaoBomba = love.graphics.newImage("Sprites/personagens/explosao.png")
    self.larg_explosao = self.img_explosaoBomba:getWidth()
    self.alt_explosao = self.img_explosaoBomba:getHeight()
    self.largF_explosao = self.larg_explosao/3
    self.altF_explosao = self.alt_explosao/3
    local grid_explosao = anim.newGrid(self.largF_explosao, self.altF_explosao, self.larg_explosao, self.alt_explosao)
    self.animation_explosao = anim.newAnimation(grid_explosao('1-3', 1, '1-3', 2, '1-3', 3), 0.1)

    self.posicao = Vector(x, y)
    self.raio = 150
    self.dano = 80
    self.explodiu = 0
    self.tempo_bomba = 0
end

function Bomba:update(dt)
    self.tempo_bomba = self.tempo_bomba + dt

    if self.explodiu == 0 then
        self:detecta_inimigos()
        self.explodiu = 1
    end
    
    self.animation_explosao:update(dt)
    self.audio_explosion:play()
end

function Bomba:draw()
    self.animation_explosao:draw(self.img_explosaoBomba, self.posicao.x, self.posicao.y+15)
end

function Bomba:detecta_inimigos()
    for i=1, #enemys do
        local dist = self.posicao.dist(enemys[i].posicao + Vector(-50, 50), self.posicao + Vector(50, 50))
        if  dist <= self.raio then
            enemys[i].vida =  enemys[i].vida - self.dano
            enemys[i].barra_vida = enemys[i].barra_vida * (enemys[i].vida/enemys[i].temp_vida)
        end
    end
end
Torre = Classe:extend()

function Torre:new(x, y)
    self.audio_shots = love.audio.newSource("audio/shotgun-firing-3-14483.mp3", "stream")

    self.img_torre = love.graphics.newImage("Sprites/personagens/torre1.png")
    self.larg_torre = self.img_torre:getWidth()
    self.alt_torre = self.img_torre:getHeight()
    self.largF_torre = self.larg_torre/8
    self.altF_torre = self.alt_torre/5
    local grid = anim.newGrid(self.largF_torre, self.altF_torre, self.larg_torre, self.alt_torre)
    self.animation_patrulhando = anim.newAnimation(grid('1-5', 1), 0.1)
    self.animation_atacando = anim.newAnimation(grid('6-8', 1, '1-8', 2), 0.1)

    self.posicao = Vector(x, y)
    self.raio = 150
    self.estado = "patrulhando"
    self.dano = 20

    self.delay = 0.21
end

function Torre:update(dt)
    if self.estado == "patrulhando" then
        self.animation_patrulhando:update(dt)
    else
        self.animation_atacando:update(dt)
        self.audio_shots:setVolume(0.1)
        self.audio_shots:setPitch(2)
        self.audio_shots:play()
    end

    local i = self:detecta_inimigos()

    if self.estado == 'atacando' then
        self.delay = self.delay + dt

        if self.delay > 0.80 then
            enemys[i].vida = enemys[i].vida - self.dano
            enemys[i].barra_vida = enemys[i].barra_vida * (enemys[i].vida/enemys[i].temp_vida)
            self.delay = 0
        end
    end
end

function Torre:draw()
    if self.estado == "patrulhando" then
        self.animation_patrulhando:draw(self.img_torre, self.posicao.x, self.posicao.y)
    else
        self.animation_atacando:draw(self.img_torre, self.posicao.x, self.posicao.y)
    end
end

function Torre:detecta_inimigos()
    for i=1, #enemys do
        local dist = self.posicao.dist(enemys[i].posicao + Vector(-50, 50), self.posicao + Vector(50, 50))
        if  dist <= self.raio then
            self.estado = "atacando"
            return i
        end
    end

    self.estado = "patrulhando"
    return -1
end
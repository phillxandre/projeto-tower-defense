Cenario = Classe:extend()

function Cenario:new()
    self.selecao = {x=0, y=0, cor = {0,0,1,0.4}}
    self.mouse = {}

    local img_terra = love.graphics.newImage("Sprites/background/sand_tile_1.png")
    local img_grama = love.graphics.newImage("Sprites/background/grass_tile_1.png")
    local img_madeira = love.graphics.newImage("Sprites/background/madeira.png")

    self.img = {img_grama, img_terra, img_madeira, img_madeira, img_madeira}

end

function Cenario:update()
    self.mouse.x = love.mouse.getX()
    self.mouse.y = love.mouse.getY()

    for i=1, 6 do
        for j=1, 8 do
            if (self.mouse.x > (j-1)*100 and self.mouse.x < j*100) then
                self.selecao.x = j-1
            end

            if (self.mouse.y > (i-1)*100 and self.mouse.y < i*100) then   
                self.selecao.y = i-1
            end

            if (mapa[self.selecao.y+1][self.selecao.x+1] == 1) then
                self.selecao.cor = {0,0,1,0.4}
            elseif (mapa[self.selecao.y+1][self.selecao.x+1] == 2) then
                self.selecao.cor = {1,0,0,0.4}
            else
                self.selecao.cor = {0,0,0,0}
            end
        end
    end
end

function Cenario:draw()
    love.graphics.push()
    love.graphics.scale(0.25, 0.25)   -- reduce everything by 50% in both X and Y coordinates
    for i=1, #mapa do
       for j=1, #mapa[i] do
            love.graphics.draw(self.img[mapa[i][j]], (j-1)*TAM_BLOCO, (i-1)*TAM_BLOCO)
        end
    end

    love.graphics.pop()

    love.graphics.setColor(self.selecao.cor)
    love.graphics.rectangle("fill", self.selecao.x*100, self.selecao.y*100, 100, 100)
    love.graphics.setColor(1, 1, 1, 1)
end
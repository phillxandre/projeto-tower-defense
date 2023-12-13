Gameover = Classe:extend()

function Gameover:new()
    self.img_fundo = love.graphics.newImage("Sprites/background/fundo_gameover.png")

    self.larg = 510
    self.alt = 310
    self.x = (LARGURA_TELA - self.larg)/2
    self.y = (ALTURA_TELA - self.alt)/2

end

function Gameover:update(dt)
    
end

function Gameover:draw()
    self.font = love.graphics.setNewFont("fontes/Pixeled.ttf", 30)
    self.txtGameOver = "FIM DE JOGO!"
    self.txtGameOverx = (LARGURA_TELA - self.font:getWidth(self.txtGameOver)) / 2
    self.txtGameOvery = (ALTURA_TELA - self.font:getHeight()) / 2
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.larg, self.alt)
    love.graphics.setColor(1, 1, 1)
    
    love.graphics.draw(self.img_fundo, self.x + 5, self.y +5)
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(self.txtGameOver, self.txtGameOverx+3, self.txtGameOvery - 80+3)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.txtGameOver, self.txtGameOverx, self.txtGameOvery - 80)

    love.graphics.setFont(fonte)

    love.graphics.setColor(0, 0, 0)
    love.graphics.print("ZUMBIS ELIMINADOS: ".. zumbisMortos, self.txtGameOverx - 17, self.txtGameOvery + 73)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("ZUMBIS ELIMINADOS: ".. zumbisMortos, self.txtGameOverx - 20, self.txtGameOvery + 70)

    love.graphics.setColor(0, 0, 0)
    love.graphics.print("ZUMBIS INVASORES: ".. zumbisEntrou, self.txtGameOverx - 17, self.txtGameOvery + 113)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("ZUMBIS INVASORES: ".. zumbisEntrou, self.txtGameOverx - 20, self.txtGameOvery + 110)
end
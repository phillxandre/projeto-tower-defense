LARGURA_TELA, ALTURA_TELA = love.graphics.getDimensions()
TAM_BLOCO = 400

mapa = { --6x8
    {1,1,1,1,1,1,1,1},
    {1,1,2,2,2,1,2,2},
    {1,1,2,1,2,1,2,1},
    {1,1,2,1,2,1,2,1},
    {3,2,2,1,2,2,2,1},
    {3,3,3,3,4,5,3,3}
}

tipos_inimigos = {{velocidade=80, dano=5, vida=100, qtd_moeda_gerada=2, op=1},
                 {velocidade=15, dano=20, vida=400, qtd_moeda_gerada=8, op=2},
                 {velocidade=40, dano=10, vida=200, qtd_moeda_gerada=4, op=3},
                 {velocidade=25, dano=15, vida=300, qtd_moeda_gerada=6, op=4}}

function love.load()
    Classe = require "classes/classic"
    Vector = require "classes/vector"
    anim = require "classes/anim8"
    moeda = require "classes/background/moeda"
    cenario = require "classes/background/cenario"
    objetivo = require "classes/personagens/objetivo"
    inimigo = require "classes/personagens/inimigo"
    gameover = require "classes/background/gameover"
    torre = require "classes/torres/torre"
    bomba = require "classes/torres/bomba"
    loja = require "classes/background/loja"
    conf = require "/conf"

    music_ambience = love.audio.newSource("audio/terror-ambience-7003.mp3", "stream")
    audio_zumbi = love.audio.newSource("audio/zombie-growl-3-6863.mp3", "stream")
    audio_morte = love.audio.newSource("audio/goresplat-7088.mp3", "static")

    music_ambience:setVolume(0.01)
    music_ambience:play()
 
    gameover = Gameover()
    moeda = Moeda()
    fundo = Cenario()
    casa = Objetivo()
    loja = Loja()

    enemys = {}
    tempo_gerar = 0
    torres = {} 
    bombas = {}

    zumbi_sorteado = love.math.random(1, 4)
    table.insert(enemys, Inimigo("inimigos", tipos_inimigos[zumbi_sorteado]))
    
    zumbisMortos = 0
    zumbisEntrou = 0
    vida_bonus = 0
    
    pontos = 0
    posicao_mouse = Vector(0, 0)
    pos_matriz = Vector(1, 1)
    tempo_mouse = 0

    mouse = {}
    pegouTorre = false

    fonte = love.graphics.setNewFont("fontes/Pixeled.ttf", 20)
end

function love.update(dt)
    fundo:update(dt)
    moeda:update(dt)
    casa:update(dt)
    loja:update(dt)

    -- habilita audio dos zumbis
    if #enemys >= 1 then
        audio_zumbi:setVolume(0.02)
        audio_zumbi:play()
    end

    mouse.x = love.mouse.getX()
    mouse.y = love.mouse.getY()

    if love.mouse.isDown(1) and tempo_mouse == 1 and pegouTorre == true then
        pos_matriz.x, pos_matriz.y = math.floor(posicao_mouse.y/100)+1, math.floor(posicao_mouse.x/100)+1

        local pos_valida
        local preco
        if loja.tipo_torre == 1 then
            pos_valida = 1
            preco = 20
        else
            pos_valida = 2
            preco = 10
        end

        if mapa[pos_matriz.x][pos_matriz.y] == pos_valida and moeda.quantidade >= preco and checa_espaco_livre() then
            posicao_mouse.x = math.floor(posicao_mouse.x / 100) * 100
            posicao_mouse.y = math.floor(posicao_mouse.y / 100) * 100 - 20

            if loja.tipo_torre == 1 then
                table.insert(torres, Torre(posicao_mouse.x, posicao_mouse.y))
            else
                table.insert(bombas, Bomba(posicao_mouse.x, posicao_mouse.y))
            end
            
            moeda.quantidade = moeda.quantidade - preco
            pegouTorre = false
        end 
        tempo_mouse = 0
    end

    for i=#torres, 1, -1 do
        torres[i]:update(dt)
    end

    for i=#bombas, 1, -1 do
        bombas[i]:update(dt)

        if bombas[i].tempo_bomba > 0.9 then
            table.remove(bombas, i)
        end
    end
        
    if casa.vida > 0 then
        if tempo_gerar > 0.8 then
            tempo_gerar = 0

            local gera = love.math.random(0, 3)

            if gera == 1 then
                zumbi_sorteado = love.math.random(1, 4)
                local enemy = Inimigo("inimigos", tipos_inimigos[zumbi_sorteado])

                table.insert(enemys, enemy)
            end
        else
            tempo_gerar = tempo_gerar + dt
        end

        atualiza_zumbi_casa(dt)
    end

end

function love.draw()
    fundo:draw()
    moeda:draw()
    casa:draw()

    --desenha filtro noite
    love.graphics.setColor(0, 0, 0.2, 0.6)
    love.graphics.rectangle("fill", 0, 0, 800, 500)
    love.graphics.setColor(1, 1, 1)

    for i=#torres, 1, -1 do
        torres[i]:draw()
    end
    
    for i=#enemys, 1, -1 do
        enemys[i]:draw() 
    end

    for i=#bombas, 1, -1 do
        bombas[i]:draw()
    end  
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Zumbis mortos: "..zumbisMortos, 12, 0) 
    love.graphics.setColor(1, 0, 0)
    love.graphics.print("Zumbis mortos: "..zumbisMortos, 10, -2)
    love.graphics.setColor(1, 1, 1)

    loja:draw()

    if casa.vida <=0 then
        for k in pairs(enemys) do
            enemys[k]=nil
        end
        gameover:draw()
    end

end

function atualiza_zumbi_casa(dt)
    -- Atualiza pontos da de vida da casa
    for i=#enemys, 1, -1 do
        enemys[i]:update(dt)
    
        if enemys[i].posicao.x < 150 then
            casa.vida = casa.vida - enemys[i].dano
            table.remove(enemys, i)
            zumbisEntrou = zumbisEntrou + 1
        end  
    end

    -- Verificar se o zumbi morreu
    for i=#enemys, 1, -1 do
        if enemys[i].vida <= 0 then
            local sortea_gera_moeda = love.math.random(0, 1)

            if sortea_gera_moeda == 1 then
                moeda.quantidade = moeda.quantidade + enemys[i].qtd_moeda_gerada
            end

            audio_morte:setVolume(0.05)
            audio_morte:play()
            table.remove(enemys, i)
            zumbisMortos = zumbisMortos + 1
            vida_bonus = vida_bonus + 1
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        posicao_mouse.x, posicao_mouse.y = x, y
        tempo_mouse = 1
    end
end

function checa_espaco_livre()
    -- Verifica se não contém uma torre naquela localização

    local tmp_x = math.floor(posicao_mouse.x / 100) * 100
    local tmp_y = math.floor(posicao_mouse.y / 100) * 100 - 20
    local tmp_vector = Vector(tmp_x, tmp_y)

    for i=#torres, 1, -1 do
        if torres[i].posicao == tmp_vector then
            return false
        end
    end

    return true
end
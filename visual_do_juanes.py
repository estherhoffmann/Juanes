import os
import sys
import ast
import pprint
import pygame

res = 1024

x_tam_mapa = int(input())
y_tam_mapa = int(input())
if x_tam_mapa > y_tam_mapa:
    scale = res // x_tam_mapa
else:
    scale = res // y_tam_mapa

pygame.init()
size = width, height = scale * x_tam_mapa, scale * y_tam_mapa
screen = pygame.display.set_mode(size)

robo_esquerda = pygame.image.load("sprites/Juan-ElGato-esquerda.png")
robo_direita = pygame.image.load("sprites/Juan-ElGato-direita.png")
sujeira = pygame.image.load("sprites/Taco.png")
power = pygame.image.load("sprites/Sombreiro.png")
elevador = pygame.image.load("sprites/Elevador.png")
lixeira = pygame.image.load("sprites/Mesa.png")
parede = pygame.image.load("sprites/Parede.png")
fundo = pygame.image.load("sprites/Fundo.png")

robo_lista = []
elevador_lista = []
lixeira_lista = []
sujeira_lista = []
parede_lista = []
power_lista = []

robo_esquerda = pygame.transform.scale(robo_esquerda, (scale, scale))
robo_direita = pygame.transform.scale(robo_direita, (scale, scale))
sujeira = pygame.transform.scale(sujeira, (scale, scale))
power = pygame.transform.scale(power, (scale, scale))
elevador = pygame.transform.scale(elevador, (scale, scale))
lixeira = pygame.transform.scale(lixeira, (scale, scale))
parede = pygame.transform.scale(parede, (scale, scale))
fundo = pygame.transform.scale(fundo, (scale, scale))

def verifica_saida():
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_q:
                pygame.quit()
                sys.exit()

def draw_element(elemento, mouse_x, mouse_y):
    screen.blit(elemento, pygame.Rect(mouse_x, mouse_y, scale, scale))

def draw_state(estado, PosicaoAnteriorRobo, DirecaoAnteriorRobo):
    verifica_saida()
    robo1 = estado[1]
    power1 = estado[3]
    parede1 = estado[4]
    sujeira1 = estado[5]
    lixeira1 = estado[6]
    elevador1 = estado[7]
    draw_bg()
    for p in parede1:
        draw_element(parede, p[0] * scale, p[1] * scale)
    for s in sujeira1:
        draw_element(sujeira, s[0] * scale, s[1] * scale)
    for l in lixeira1:
        draw_element(lixeira, l[0] * scale, l[1] * scale)
    for e in elevador1:
        draw_element(elevador, e[0] * scale, e[1] * scale)
    draw_element(power, power1[0] * scale, power1[1] * scale)
    if PosicaoAnteriorRobo < robo1[0]:
        draw_element(robo_direita, robo1[0] * scale, robo1[1] * scale)
        DirecaoAnteriorRobo = 1
    else:
        if PosicaoAnteriorRobo > robo1[0]:
            draw_element(robo_esquerda, robo1[0] * scale, robo1[1] * scale)
            DirecaoAnteriorRobo = -1
        else:
            if DirecaoAnteriorRobo is -1:
                draw_element(robo_esquerda, robo1[0] * scale, robo1[1] * scale)
            else:
                draw_element(robo_direita, robo1[0] * scale, robo1[1] * scale)

    pygame.time.wait(200)
    pygame.display.update()
    return robo1[0], DirecaoAnteriorRobo

def draw_bg():
    for i in range(0, x_tam_mapa):
        for j in range(0, y_tam_mapa):
            draw_element(fundo, i * scale, j * scale)

atual = None
aberto = True
draw_bg()
while aberto:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_p:
                atual = parede
            if event.key == pygame.K_s:
                atual = sujeira
            if event.key == pygame.K_l:
                atual = lixeira
            if event.key == pygame.K_e:
                atual = elevador
            if event.key == pygame.K_d:
                atual = power
            if event.key == pygame.K_r:
                atual = robo_direita
            if event.key == pygame.K_q:
                aberto = False

        if event.type == pygame.MOUSEBUTTONDOWN:
            mouse_x, mouse_y = pygame.mouse.get_pos()
            mouse_x = (mouse_x // scale)
            mouse_y = (mouse_y // scale)
            draw_element(atual, mouse_x * scale, mouse_y* scale)
            if atual == parede:
                parede_lista.append([mouse_x, mouse_y])
            if atual == sujeira:
                sujeira_lista.append([mouse_x, mouse_y])
            if atual == lixeira:
                lixeira_lista.append([mouse_x, mouse_y])
            if atual == elevador:
                elevador_lista.append([mouse_x, mouse_y])
            if atual == power:
                power_lista = [mouse_x, mouse_y]
            if atual == robo_direita:
                robo_lista = [mouse_x, mouse_y]

    pygame.display.flip()

comando = "swipl -s juanes.pl -g 'busca([[" + str(x_tam_mapa) + ", "  + str(y_tam_mapa) + "], "  + str(robo_lista) + ", 0, "+ str(power_lista) + ", " + str(parede_lista) + ", " + str(sujeira_lista) + ", " + str(lixeira_lista) + ", " + str(elevador_lista) + "], X), write(X), halt.' > resultado "
print(comando)
os.system(comando)

f = open("resultado", "r")
if os.stat("resultado").st_size == 0:
    print(" Não Existe Caminho :(")
    pygame.quit()
    sys.exit()

result = ast.literal_eval(f.read())


aberto = True
draw_bg()
while aberto:
    verifica_saida()
    PosicaoAnteriorRobo = robo_lista[0]
    DirecaoAnteriorRobo = 1
    for i in range(len(result)-1,-1,-1):
        PosicaoAnteriorRobo, DirecaoAnteriorRobo = draw_state(result[i], PosicaoAnteriorRobo, DirecaoAnteriorRobo)

    pygame.time.wait(5000)

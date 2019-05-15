import os
import ast
import pprint
import pygame

res = 1024

x_tam_mapa = int(input())
scale = res // x_tam_mapa

pygame.init()
size = width, height = scale * x_tam_mapa, scale * x_tam_mapa
screen = pygame.display.set_mode(size)

robo = pygame.image.load("sprites/juanes.png")
sujeira = pygame.image.load("sprites/tacos_lixo.png")
power = pygame.image.load("sprites/sombreiro_dock.png")
elevador = pygame.image.load("sprites/elevador.png")
lixeira = pygame.image.load("sprites/mesa_lixeira.png")
parede = pygame.image.load("sprites/parede.png")
fundo = pygame.image.load("sprites/fundo.png")

robo_lista = []
elevador_lista = []
lixeira_lista = []
sujeira_lista = []
parede_lista = []
power_lista = []

robo = pygame.transform.scale(robo, (scale, scale))
sujeira = pygame.transform.scale(sujeira, (scale, scale))
power = pygame.transform.scale(power, (scale, scale))
elevador = pygame.transform.scale(elevador, (scale, scale))
lixeira = pygame.transform.scale(lixeira, (scale, scale))
parede = pygame.transform.scale(parede, (scale, scale))
fundo = pygame.transform.scale(fundo, (scale, scale))


def draw_element(elemento, mouse_x, mouse_y):
    screen.blit(elemento, pygame.Rect(mouse_x, mouse_y, scale, scale))

def draw_state(estado):
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
    draw_element(robo, robo1[0] * scale, robo1[1] * scale)
    draw_element(power, power1[0] * scale, power1[1] * scale)
    pygame.time.wait(200)
    pygame.display.update()

def draw_bg():
    for i in range(0, x_tam_mapa):
        for j in range(0, x_tam_mapa):
            draw_element(fundo, i * scale, j * scale)

atual = None
aberto = True
draw_bg()
while aberto:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            print(initial_state.getState())
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
                atual = robo
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
            if atual == robo:
                robo_lista = [mouse_x, mouse_y]

    pygame.display.flip()

comando = "swipl -s juanes.pl -g 'solucao_bl([" + str(x_tam_mapa) + ", " + str(robo_lista) + ", 0, "+ str(power_lista) + ", " + str(parede_lista) + ", " + str(sujeira_lista) + ", " + str(lixeira_lista) + ", " + str(elevador_lista) + "], X), write(X), halt.' > resultado "

os.system(comando)

f = open("resultado", "r")
result = ast.literal_eval(f.read())

#pygame.init()
#screen = pygame.display.set_mode(size)

aberto = True
draw_bg()
while aberto:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            system.exit()
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_q:
                aberto = False

    for i in range(len(result)-1,-1,-1):
        draw_state(result[i])

    pygame.time.wait(5000)

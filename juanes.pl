% Trabalho da matéria Inteligência Artificial da Universidade Federal de São Carlos
% Professor: Murilo Naldi
% Desenvolvedoras:
%   Bruna Fernandes Prates   - RA: 743513
%   Esther Calderan Hoffmann - RA: 743529
% Código das buscas em largura e em profundidade cedidos pelo professor.

% Determinando qual busca utilizar: Se o problema for > 4x4, utiliza busca em profundidade,
% caso contrário, busca em largura
busca([[X_Limite_Mapa, Y_Limite_Mapa], Robo, Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores], Solucao) :-
  X_Limite_Mapa < 5,
  Y_Limite_Mapa < 5,
  solucao_bl([[X_Limite_Mapa, Y_Limite_Mapa], Robo, Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores], Solucao).

busca([[X_Limite_Mapa, Y_Limite_Mapa], Robo, Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores], Solucao) :-
  (X_Limite_Mapa > 4;
  Y_Limite_Mapa > 4),
  solucao_bp([[X_Limite_Mapa, Y_Limite_Mapa], Robo, Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores], Solucao).

% BUSCA EM LARGURA:
solucao_bl(Inicial,Solucao) :-
  bl([[Inicial]],Solucao).

%Se o primeiro estado de F for meta, então o retorna com o caminho
bl([[Estado|Caminho]|_],[Estado|Caminho])
  :- meta(Estado).

%falha ao encontrar a meta, então estende o primeiro estado até seus sucessores e os coloca no final da lista de fronteira
bl([Primeiro|Outros], Solucao) :-
  estende(Primeiro,Sucessores),
  concatena(Outros,Sucessores,NovaFronteira),
  bl(NovaFronteira,Solucao).

% BUSCA EM PROFUNDIDADE:
solucao_bp(Inicial,Solucao) :-
  bp([],Inicial,Solucao).

% Se o primeiro estado da lista é meta, retorna a meta
bp(Caminho,Estado,[Estado|Caminho]) :-
  meta(Estado).

% Se falha, coloca o no caminho e continua a busca
bp(Caminho,Estado,Solucao) :-
  s(Estado,Sucessor),
  not(pertence(Sucessor,[Estado|Caminho])),
  bp([Estado|Caminho],Sucessor,Solucao).


% Operações gerais:
%  "retorna" a lista de sucessores
estende([Estado|Caminho],ListaSucessores):-
  bagof([Sucessor,Estado|Caminho],
  (s(Estado,Sucessor),
  not(pertence(Sucessor,[Estado|Caminho]))),
  ListaSucessores),!.
estende( _ ,[]).

%  verifica se elem pertence à lista
pertence(Elem,[Elem|_ ]).
pertence(Elem,[ _| Cauda]) :-
  pertence(Elem,Cauda).

% concatena duas listas
concatena([ ],L,L).
concatena([Cab|Cauda],L2,[Cab|Resultado]) :-
  concatena(Cauda,L2,Resultado).

% retira elemento da lista
retirar_elemento(Elem,[Elem|Cauda],Cauda).
retirar_elemento(Elem,[Elem1|Cauda],[Elem1| Cauda1]) :-
  retirar_elemento(Elem,Cauda,Cauda1).

vazio(Lista) :-
  not(pertence(_, Lista)).


% ROBO
% Robo recolhe uma sujeira
s([Limite_Mapa, Robo, Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores], [Limite_Mapa, Robo, Saida_Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Saida_Lixos, Lixeiras, Elevadores]) :-
  pertence(Robo, Lixos),
  retirar_elemento(Robo, Lixos, Saida_Lixos),
  Qnt_Lixos_Robo < 2,
  Saida_Qnt_Lixos_Robo is Qnt_Lixos_Robo + 1.

% Robo chega em uma lixeira e joga sujeiras no lixo, caso ele não tenha 2 lixos em mãos
s([Limite_Mapa, Robo, Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores], [Limite_Mapa, Robo, Saida_Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores]) :-
  pertence(Robo, Lixeiras),
  Qnt_Lixos_Robo > 0,
  Saida_Qnt_Lixos_Robo is 0.

% Robo se move na horizontal PARA A DIREITA
s([[X_Limite_Mapa, Y_Limite_Mapa], [X_Robo, Y_Robo], Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores], [[X_Limite_Mapa, Y_Limite_Mapa], [X_Saida_Robo, Y_Robo], Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores]) :-
  X_Saida_Robo is X_Robo + 1,
  X_Saida_Robo < X_Limite_Mapa,
  not(pertence([X_Saida_Robo,Y_Robo], Paredes)).

% Robo se move na horizontal PARA A ESQUERDA
s([[X_Limite_Mapa, Y_Limite_Mapa], [X_Robo, Y_Robo], Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores], [[X_Limite_Mapa, Y_Limite_Mapa], [X_Saida_Robo, Y_Robo], Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores]) :-
  X_Saida_Robo is X_Robo - 1,
  X_Saida_Robo >= 0,
  not(pertence([X_Saida_Robo,Y_Robo], Paredes)).

% Robo sobe e desce nos elevadores
s([[X_Limite_Mapa, Y_Limite_Mapa], [X_Robo, Y_Robo], Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores], [[X_Limite_Mapa, Y_Limite_Mapa], [X_Robo, Y_Saida_Robo], Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores]) :-
  pertence([X_Robo, Y_Robo], Elevadores),
  ((Y_Saida_Robo is Y_Robo + 1,
  Y_Saida_Robo < Y_Limite_Mapa);
  (Y_Saida_Robo is Y_Robo - 1,
  Y_Saida_Robo >= 0)),
  pertence([X_Robo, Y_Saida_Robo], Elevadores).

% Objetivo do robo
meta([_, Robo, Qnt_Lixos_Robo, PosicaoDockStation, _, Lixos, _, _]) :-
    Robo = PosicaoDockStation,
    vazio(Lixos),
    Qnt_Lixos_Robo = 0.

writeall(Q) :-
  forall(Q,writeln(Q)).


% BUSCA EM LARGURA
solucao_bl(Inicial,Solucao) :-
  bl([[Inicial]],Solucao).

bl([[Estado|Caminho]|_],[Estado|Caminho])
  :- meta(Estado).

bl([Primeiro|Outros], Solucao) :-
  estende(Primeiro,Sucessores),
  concatena(Outros,Sucessores,NovaFronteira),
  bl(NovaFronteira,Solucao).

% funcao estende
estende( _ ,[]).
estende([Estado|Caminho],ListaSucessores):-
  bagof([Sucessor,Estado|Caminho],
  (s(Estado,Sucessor),
  not(pertence(Sucessor,[Estado|Caminho]))),
  ListaSucessores),!.

% função pertence
pertence(Elem,[Elem|_ ]).
pertence(Elem,[ _| Cauda]) :-
  pertence(Elem,Cauda).

% funcao concatena
concatena([ ],L,L).
concatena([Cab|Cauda],L2,[Cab|Resultado]) :-
  concatena(Cauda,L2,Resultado).

% funcao retirar elemento
retirar_elemento(Elem,[Elem|Cauda],Cauda).
retirar_elemento(Elem,[Elem1|Cauda],[Elem1| Cauda1]) :-
  retirar_elemento(Elem,Cauda,Cauda1).

vazio(Lista) :-
  not(pertence(_, Lista)).

% ROBO
s([Limite_Mapa, [X_Robo, Y_Robo], Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores], [Limite_Mapa, [X_Saida_Robo, Y_Robo], Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores]) :-
  (X_Saida_Robo is X_Robo + 1;
  X_Saida_Robo is X_Robo - 1),
  X_Robo < Limite_Mapa,
  X_Robo >= 0,
  not(pertence([X_Robo,Y_Robo], Paredes)).


s([Limite_Mapa, Robo, Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores], [Limite_Mapa, Robo, Saida_Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Saida_Lixos, Lixeiras, Elevadores]) :-
  pertence(Robo, Lixos),
  retirar_elemento(Robo, Lixos, Saida_Lixos),
  Qnt_Lixos_Robo < 2,
  Saida_Qnt_Lixos_Robo is Qnt_Lixos_Robo + 1.


s([Limite_Mapa, Robo, Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores], [Limite_Mapa, Robo, Saida_Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores]) :-
  pertence(Robo, Lixeiras),
  Qnt_Lixos_Robo > 0,
  Saida_Qnt_Lixos_Robo is 0.

s([Limite_Mapa, [X_Robo, Y_Robo], Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores], [Limite_Mapa, [X_Robo, Y_Saida_Robo], Qnt_Lixos_Robo, PosicaoDockStation, Paredes, Lixos, Lixeiras, Elevadores]) :-
  pertence([X_Robo, Y_Robo], Elevadores),
  ((Y_Saida_Robo is Y_Robo + 1,
  pertence([X_Robo, Y_Saida_Robo], Elevadores));
  (Y_Saida_Robo is Y_Robo - 1,
  pertence([X_Robo, Y_Saida_Robo], Elevadores))).


meta([_, Robo, Qnt_Lixos_Robo, DockStation, _, Lixos, _, _]) :-
    Robo = DockStation,
    vazio(Lixos),
    Qnt_Lixos_Robo = 0.

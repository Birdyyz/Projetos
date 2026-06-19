% processo da partida

% inicia uma partida
% gera o mundo do jogo
% guarda todos os jogadores
% recebe input
% chama player
% guarda estado


-module(match).
-export([start/2, input/4, tick/1, get_state/1, update/1]).


start(Group, SupervisorPid) -> % cria o estado inicial
    Width = 800.0,
    Height = 600.0,

    Players = found_players(Group),

    State = #{
        players => Players,
        player_pids => Group, % guarda os PIDs dos clientes para avisar no fim
        foods => objects:initial_foods(20, Width, Height), % máximo de 20 foods ao mesmo tempo no mapa
        poisons => objects:initial_poisons(20, Width, Height), % máximo de 20 poisons ao mesmo tempo no mapa
        width => Width,
        height => Height,
        supervisor => SupervisorPid
    },

    MatchPid = spawn(fun() -> update(State) end),

    erlang:send_after(120000, MatchPid, finish_match), % depois de 2 minutos termina automaticamente a partida

    MatchPid.


found_players(Group) ->
    found_players(Group, 0, #{}).

found_players([], _Index, Acc) ->
    Acc;

found_players([{_ClientPid, User} | Rest], Index, Acc) -> % procura jogadores
    X = 100.0 + Index * 100.0,
    Y = 100.0,
    Player = new_player(User, X, Y),
    found_players(Rest, Index + 1, Acc#{User => Player}).


new_player(User, X, Y) -> % reseta os dados dos jogadores para a partida
    #{
        user => User,
        x => X,
        y => Y,
        vx => 0.0,
        vy => 0.0,
        angle => 0.0,
        mass => 10.0,
        min_mass => 10.0,
        torque => 2.0,
        force => 6.7, % aumentar a velocidade
        score => 0,
        input => #{
            forward => false,
            left => false,
            right => false
        }
    }.


input(MatchPid, User, Key, Value) -> % envia mensagens de input
    MatchPid ! {input, User, Key, Value}.


tick(MatchPid) -> % envia mensagem de atualizar um passo
    MatchPid ! tick.


get_state(MatchPid) -> % pede o estado, para java saber o que desenhar
    MatchPid ! {get_state, self()},
    receive
        {state, State} ->
            {ok, State}
    after 100 ->
        finished
    end.


update(State) -> % ciclo de partida
    receive
        {input, User, Key, Value} ->
            NewState = set_player_input(State, User, Key, Value),
            update(NewState);

        tick -> % atualiza a partida a cada n tempo
            NewState = update_world(State),
            update(NewState);

        {get_state, From} -> % pedido do estado atual da partida
            From ! {state, State},
            update(State);

        finish_match -> % termina a partida
            finish(State)
    end.


set_player_input(State, User, Key, Value) -> % pega no jogador correspondente e atualiza os seus dados
    Players = maps:get(players, State),

    case maps:find(User, Players) of
        {ok, Player} ->
            NewPlayer = player:set_input(Player, Key, Value),
            NewPlayers = Players#{User := NewPlayer},
            State#{players := NewPlayers};

        error ->
            State
    end.


update_world(State) -> % atualiza o mapa da partida (todos os jogadores e objetos)
    Players = maps:get(players, State),
    Width = maps:get(width, State),
    Height = maps:get(height, State),

    NewPlayers =
        maps:map(
            fun(_User, PlayerState) ->
                player:move_player(PlayerState, Width, Height)
            end,
            Players
        ),

    State1 = State#{players := NewPlayers},

    State2 = collisions:handle_food(State1),
    State3 = collisions:handle_poison(State2),
    State4 = collisions:handle_players(State3),

    Foods4 = maps:get(foods, State4),
    Players4 = maps:get(players, State4),

    NewFoods = objects:ensure_small_food(Foods4, Players4, Width, Height),

    State4#{foods := NewFoods}.


finish(State) -> % termina a partida
    Players = maps:get(players, State),
    SupervisorPid = maps:get(supervisor, State),

    Scores = % extrai a pontuação dos jogadores
        maps:fold(
            fun(User, Player, Acc) ->
                [{User, maps:get(score, Player)} | Acc]
            end,
            [],
            Players
        ),

    case winner(Scores) of
        none -> % caso haver empates, não atualiza o ranking
            io:format("Match ended in a draw. Ignored for the leaderboard. ~n", []);
        {Winner, Score} -> % adiciona o vencedor ao ranking
            score:add_score(Winner, Score),
            io:format("Match ended. Winner: ~s with ~p points. ~n", [Winner, Score])
    end,

    SupervisorPid ! {match_ended, self()}, % avisa o termino da partida

    % Avisa os processos dos clientes que a partida acabou
    PlayerPids = maps:get(player_pids, State),
    lists:foreach(fun({Pid, _}) -> Pid ! match_ended end, PlayerPids),
    
    ok.


winner(Scores) -> % identifica o vencedor da partida
    Sorted = lists:sort(fun({_U1, S1}, {_U2, S2}) -> S1 >= S2 end, Scores),
    case Sorted of
        [{U, S}] ->
            {U, S};
        [{_U1, S}, {_U2, S} | _] ->
            none;
        [{U, S} | _] ->
            {U, S};
        [] ->
            none
    end.



-module(lobby_manager).
-export([start/1, join/3, leave/2, loop/3]).


-define(WAIT_TIME, 60000). % esperar um minuto por 4 jogadores


start(MatchSupPid) ->
    spawn(fun() -> loop([], MatchSupPid, false) end).


join(LobbyPid, ClientPid, Username) ->
    LobbyPid ! {join, ClientPid, Username}.

    
leave(LobbyPid, ClientPid) ->
    LobbyPid ! {leave, ClientPid}.


loop(Queue, MatchSupPid, TimerActive) ->
    receive
        {join, ClientPid, Username} ->
            % evita duplicar o mesmo client na queue
            QueueWithoutClient = lists:keydelete(ClientPid, 1, Queue),
            NewQueue = QueueWithoutClient ++ [{ClientPid, Username}],
            io:format("~s Entered the lobby. Total in queue: ~p~n", [Username, length(NewQueue)]),
            
            % envia o top atualizado para todos no lobby
            broadcast_top_scores(NewQueue),
 
            check_and_loop(NewQueue, MatchSupPid, TimerActive);

        {leave, ClientPid} ->
            NewQueue = lists:keydelete(ClientPid, 1, Queue),
            io:format("A player left the looby. Total in queue: ~p~n", [length(NewQueue)]),
            
            % atualiza o top para quem ficou no lobby
            broadcast_top_scores(NewQueue),
            
            loop(NewQueue, MatchSupPid, TimerActive);

        start_three_players -> % não encontrou 4ºjogador: começa a partida com 3 jogadores
            case length(Queue) of
                3 ->
                    io:format("1 minute passed. Starting match with 3 players.~n", []),
                    {Group, RestOfQueue} = lists:split(3, Queue),
                    start_match(Group, RestOfQueue, MatchSupPid);

                _ ->
                    loop(Queue, MatchSupPid, false)
            end;

        _ ->
            loop(Queue, MatchSupPid, TimerActive)
    end.


check_and_loop(Queue, MatchSupPid, TimerActive) ->
    Len = length(Queue),
    if
        Len >= 4 -> % encontrou 4 jogadores, inicia partida
            {Group, RestOfQueue} = lists:split(4, Queue),
            start_match(Group, RestOfQueue, MatchSupPid);

        Len =:= 3, TimerActive =:= false -> % só tem 3 jogadores, espera 1 min
            io:format("3 players waiting. Waiting 1 minute for a 4th player...~n", []),
            erlang:send_after(?WAIT_TIME, self(), start_three_players),
            loop(Queue, MatchSupPid, true);

        true ->
            loop(Queue, MatchSupPid, TimerActive) % espera enquanto não tem jogadores suficientes
    end.


start_match(Group, RestOfQueue, MatchSupPid) ->
    MatchSupPid ! {start_match, self(), Group},

    receive
        {MatchSupPid, {ok, MatchPid}} -> % inicia a partida
            io:format("Match created successfully! PID: ~p~n", [MatchPid]),
            notify_players(Group, MatchPid),
            loop(RestOfQueue, MatchSupPid, false); % continua a processar o resto da fila

        {MatchSupPid, max_matches_reached} -> % caso tenha 4 partidas ativas
            loop(Group ++ RestOfQueue, MatchSupPid, false) % volta para a queue e espera
    end.


notify_players([], _MatchPid) ->
    ok;

notify_players([{ClientPid, _Username} | Rest], MatchPid) ->
    ClientPid ! {match_started, MatchPid},
    notify_players(Rest, MatchPid).


broadcast_top_scores(Queue) -> % atualiza o top sempre que alguém sai ou entra no lobby
    TopScores = score:get_top_scores(),
    lists:foreach(
        fun({Pid, _Username}) ->
            Pid ! {top_scores, TopScores}
        end,
        Queue
    ).
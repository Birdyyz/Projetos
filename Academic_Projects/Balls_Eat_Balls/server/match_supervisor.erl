-module(match_supervisor).
-export([start/0, loop/1]).

start() ->
    spawn(fun() -> loop(0) end).


loop(ActiveCount) ->
    receive
        {start_match, LobbyPid, Group} ->
            if
                ActiveCount < 4 ->
                    MatchPid = match:start(Group, self()), % cria nova partida
                    LobbyPid ! {self(), {ok, MatchPid}},
                    io:format("MatchSupervisor: Match created. Total active matches: ~p~n", [ActiveCount + 1]),
                    loop(ActiveCount + 1);

                true ->
                    % se já temos 4 partidas ativas, recusa a criação de mais partidas
                    LobbyPid ! {self(), max_matches_reached},
                    io:format("MatchSupervisor: Maximum active matches reached (4/4)."),
                    loop(ActiveCount)

            end;

        {match_ended, MatchPid} ->
            NewCount = erlang:max(0, ActiveCount - 1), % liberta uma vaga quando uma partida termina
            io:format("MatchSupervisor: Match ended (~p). Total active matches: ~p/4~n", [MatchPid, NewCount]),
            loop(NewCount);

        _ ->
            loop(ActiveCount)
    
    end.



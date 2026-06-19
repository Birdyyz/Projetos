-module(serveTCP). % tem de ter o mesmo nome que ficheiro
-export([start/1, server/3, acceptor/3, client_auth/3, client_lobby/4, client_game/5, handle_msg/3]). % as funções que podem ser chamadas fora


start(Port) -> % função que arranca o servidor
    score:start(),
    AuthPid = auth_manager:start(),
    MatchSupPid = match_supervisor:start(),
    LobbyPid = lobby_manager:start(MatchSupPid),
    spawn(fun() -> server(Port, AuthPid, LobbyPid) end).


% stop(Server) -> Server ! stop.


server(Port, AuthPid, LobbyPid) ->
    {ok, ServerSocket} = gen_tcp:listen(Port, % cria o socket do servidor e põe a escutar nesse porto
        [binary,                              % os dados recebidos são em binário 
        {packet, line},                       % o socket vai tratar os dados por linha (cada msg termina com \n)
        {active, true},                       % é lido manualmente com gen_tcp:recv(...)
        {reuseaddr, true}]),                  % permite reutilizar o porto sem problemas qd reinicia o servidor
    io:format("Server listening on port ~p~n", [Port]),
    acceptor(ServerSocket, AuthPid, LobbyPid). % dps de criar o socket, o servidor entra no loop de aceitar clientes


acceptor(ServerSocket, AuthPid, LobbyPid) ->
    {ok, ClientSocket} = gen_tcp:accept(ServerSocket), % fica bloqueado até um cliente se ligar
    io:format("Processing client request... ~n", []),

    HandlerPid = spawn(fun() ->
        client_auth(ClientSocket, AuthPid, LobbyPid) % quando entra um cliente, criamos um provesso novo para o tratar
    end),

    ok = gen_tcp:controlling_process(ClientSocket, HandlerPid), % o processo que faz client_auth recebe {tcp, Sock, Data}
    inet:setopts(ClientSocket, [{active, true}]),

    acceptor(ServerSocket, AuthPid, LobbyPid).


client_auth(Sock, AuthPid, LobbyPid) ->
    receive
        {tcp, Sock, Data} ->
            Msg = string:trim(binary_to_list(Data)),
            case string:tokens(Msg, " ") of
                
                % comando: REGISTER user pass
                ["REGISTER", User, Pass] ->
                    case auth_manager:register(AuthPid, User, Pass) of
                        ok -> gen_tcp:send(Sock, <<"OK\n">>);
                        {error, _} -> gen_tcp:send(Sock, <<"ERROR\n">>)
                    end,
                    client_auth(Sock, AuthPid, LobbyPid); % continua na Auth até fazer Login
                
                % comando: UNREGISTER user pass
                ["UNREGISTER", User, Pass] ->
                    case auth_manager:cancel_registration(AuthPid, User, Pass) of
                        ok -> gen_tcp:send(Sock, <<"OK\n">>);
                        {error, _} -> gen_tcp:send(Sock, <<"ERROR\n">>)
                    end,
                    client_auth(Sock, AuthPid, LobbyPid);

                % comando: LOGIN user pass
                ["LOGIN", User, Pass] ->
                    case auth_manager:login(AuthPid, User, Pass) of
                        ok ->
                            gen_tcp:send(Sock, <<"OK\n">>),
                            % sucesso! Entra no Lobby e muda de estado
                            lobby_manager:join(LobbyPid, self(), User),
                            client_lobby(Sock, User, LobbyPid, AuthPid);
                        {error, _} ->
                            gen_tcp:send(Sock, <<"ERROR\n">>),
                            client_auth(Sock, AuthPid, LobbyPid)
                    end;
                
                _ ->
                    gen_tcp:send(Sock, <<"ERROR_UNKNOWN_CMD\n">>),
                    client_auth(Sock, AuthPid, LobbyPid)
            end;
            
        {tcp_closed, Sock} ->
            io:format("Client disconnected during authentication. ~n", []);
            
        {tcp_error, Sock, Reason} ->
            io:format("TCP error: ~p~n", [Reason])
    end.


client_lobby(Sock, User, LobbyPid, AuthPid) ->
    receive
        % rede (Comandos do Java)
        {tcp, Sock, Data} ->
            Msg = string:trim(binary_to_list(Data)),
            case string:tokens(Msg, " ") of
                % comando: CANCEL
                ["CANCEL"] ->
                    lobby_manager:leave(LobbyPid, self()),
                    gen_tcp:send(Sock, <<"OK\n">>),
                    % volta para a fase de autenticação
                    client_auth(Sock, AuthPid, LobbyPid);
                _ ->
                    gen_tcp:send(Sock, <<"WAITING\n">>),
                    client_lobby(Sock, User, LobbyPid, AuthPid)
            end;
            
        % aviso do lobby_manager que a partida começou
        {match_started, MatchPid} ->
            gen_tcp:send(Sock, <<"START\n">>),
            % avança para o Estado 3: Jogo!
            client_game(Sock, User, MatchPid, LobbyPid, AuthPid);

        % erlang (Top scores vindo do lobby_manager)
        {top_scores, Scores} ->
            % Formata: TOP {user}:{score} {user}:{score} ...
            Formatted = lists:map(fun({U, S}) -> io_lib:format("~s:~p", [U, S]) end, Scores),
            TopMsg = io_lib:format("TOP ~s\n", [string:join(Formatted, " ")]),
            gen_tcp:send(Sock, list_to_binary(TopMsg)),
            client_lobby(Sock, User, LobbyPid, AuthPid);
            
        {tcp_closed, Sock} ->
            % se a ligação cair, avisa o Lobby para o tirar da fila
            lobby_manager:leave(LobbyPid, self()),
            io:format("Client ~s disconnected from the lobby. ~n", [User])
    end.


client_game(Sock, User, MatchPid, LobbyPid, AuthPid) ->
    receive
        {tcp, Sock, Data} ->
            Msg = string:trim(binary_to_list(Data)),
            handle_msg(Msg, Sock, MatchPid),
            client_game(Sock, User, MatchPid, LobbyPid, AuthPid);
            
        {tcp_closed, Sock} ->
            io:format("Client ~s disconnected in the middle of the game. ~n", [User]);

        % erlang (Aviso que a partida terminou - ex: após 2 minutos)
        match_ended -> 
            gen_tcp:send(Sock, <<"FINISH\n">>),
            % Volta para o lobby para ver o ranking atualizado
            lobby_manager:join(LobbyPid, self(), User),
            client_lobby(Sock, User, LobbyPid, AuthPid)
    end.


handle_msg(Msg, Sock, MatchPid) ->
    case string:tokens(Msg, " ") of

        ["INPUT", User, KeyStr, ValueStr] ->
            Key = list_to_atom(KeyStr),

            Value =
                case ValueStr of
                    "true" -> true;
                    "false" -> false;
                    _ -> false
                end,

            match:input(MatchPid, User, Key, Value),
            gen_tcp:send(Sock, <<"OK\n">>);

        ["TICK"] ->
            match:tick(MatchPid),
            gen_tcp:send(Sock, <<"OK\n">>);

        ["GET"] ->
            case match:get_state(MatchPid) of
                {ok, State} ->
                    Reply = format_state(State),
                    gen_tcp:send(Sock, Reply);

                finished ->
                    gen_tcp:send(Sock, <<"FINISH\n">>)
            end;

        _ ->
            gen_tcp:send(Sock, <<"ERROR\n">>)
    end.


format_state(State) ->
    Players = maps:get(players, State),
    Foods = maps:get(foods, State),
    Poisons = maps:get(poisons, State),

    PlayerLines =
        maps:fold(
            fun(User, P, Acc) ->
                X = maps:get(x, P),
                Y = maps:get(y, P),
                Mass = maps:get(mass, P),
                Angle = maps:get(angle, P),
                Score = maps:get(score, P, 0),

                Acc ++ io_lib:format(
                    "PLAYER ~s ~p ~p ~p ~p ~p~n",
                    [User, X, Y, Mass, Angle, Score]
                )
            end,
            [],
            Players
        ),

    FoodLines =
        lists:map(
            fun(F) ->
                X = maps:get(x, F),
                Y = maps:get(y, F),
                Mass = maps:get(mass, F),

                io_lib:format("FOOD ~p ~p ~p~n", [X, Y, Mass])
            end,
            Foods
        ),

    PoisonLines =
        lists:map(
            fun(P) ->
                X = maps:get(x, P),
                Y = maps:get(y, P),
                Mass = maps:get(mass, P),

                io_lib:format("POISON ~p ~p ~p~n", [X, Y, Mass])
            end,
            Poisons
        ),

    Width = maps:get(width, State),
    Height = maps:get(height, State),

    lists:flatten([
        io_lib:format("MAP ~p ~p~n", [Width, Height]),
        "STATE_BEGIN\n",
        PlayerLines,
        FoodLines,
        PoisonLines,
        "STATE_END\n"
    ]).

    

% COMO TESTAR O NOVO SERVIDOR (COM AUTH E LOBBY):
% 
% 1. NO TERMINAL DO ERLANG (O Servidor)
% erl                           <- abre a shell do erlang e compila todos os ficheiros 
%
% c(auth_manager).           
% c(collisions).
% c(lobby_manager).
% c(match_supervisor).
% c(match).
% c(objects).
% c(player).
% c(score).
% c(serveTCP).
% 
% serveTCP:start(12345).        <- arranca os managers e escuta na porta 12345
% 
% 
% 2. NOS TERMINAIS DO JAVA (Os Clientes)
% javac TestClient.java         <- compilar o cliente
% 
% ATENÇÃO: Para a partida começar, tens de abrir 3 TERMINAIS DIFERENTES
% e correr `java TestClient` em cada um deles!
% 
% 
% 3. COMANDOS DO CLIENTE (Por ordem de fases):
% 
% --- FASE 1: AUTENTICAÇÃO ---
% REGISTER user pass            <- Regista uma nova conta (ex: REGISTER joao 123)
% LOGIN user pass               <- Faz login e entra no lobby (ex: LOGIN joao 123)
% 
% --- FASE 2: LOBBY (ESPERA) ---
% (Ficas aqui até 3 clientes fazerem LOGIN)
% CANCEL                        <- Sai da fila de espera e volta à fase de autenticação
% 
% --- FASE 3: EM JOGO ---
% (Apenas funciona depois de receberes a mensagem "START")
% get                           <- ver estado atual (posições, comida, veneno)
% up                            <- acelerar para a frente
% left                          <- virar à esquerda
% right                         <- virar à direita
% tick                          <- atualiza a simulação (passo de tempo)
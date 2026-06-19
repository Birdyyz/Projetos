-module(auth_manager).
-export([start/0, register/3, login/3, cancel_registration/3, loop/1]).


start() ->
    spawn(fun() -> loop(#{}) end).


register(AuthPid, User, Pass) ->
    AuthPid ! {register, self(), User, Pass},
    receive
        {AuthPid, Result} -> Result
    end.


login(AuthPid, User, Pass) ->
    AuthPid ! {login, self(), User, Pass},
    receive
        {AuthPid, Result} -> Result
    end.


cancel_registration(AuthPid, User, Pass) ->
    AuthPid ! {cancel, self(), User, Pass},
    receive
        {AuthPid, Res} -> Res
    end.


loop(Users) ->
    receive
        {register, From, User, Pass} -> % regista um novo utilizador
            case maps:is_key(User, Users) of
                true ->
                    From ! {self(), {error, user_exists}},
                    loop(Users);
                false ->
                    NewUsers = maps:put(User, Pass, Users),
                    From ! {self(), ok},
                    loop(NewUsers)
            end;

        {login, From, User, Pass} -> % verifica as credenciais do utilizador
            case maps:find(User, Users) of
                {ok, Pass} ->
                    From ! {self(), ok},
                    loop(Users);
                {ok, _WrongPass} ->
                    From ! {self(), {error, invalid_credentials}},
                    loop(Users);
                error ->
                    From ! {self(), {error, user_not_found}},
                    loop(Users)
            end;

        {cancel, From, User, Pass} ->
            case maps:find(User, Users) of
                {ok, Pass} ->
                    % Utilizador validado, remove do mapa
                    NewUsers = maps:remove(User, Users),
                    From ! {self(), ok},
                    loop(NewUsers);
                _ ->
                    % Tebta cancelar com credenciais inválidas
                    From ! {self(), {error, auth_failed}},
                    loop(Users)
            end;

        _ ->
            % Ignora mensagens desconhecidas
            loop(Users)
    end.



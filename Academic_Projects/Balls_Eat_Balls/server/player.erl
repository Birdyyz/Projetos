% trata dos movimentos/fisico
% recebe um jogador → devolve o jogador atualizado


-module(player).
-export([set_input/3, move_player/3]).


set_input(Player, Key, Value) -> % atualiza as teclas pressionadas pelo jogador
    Input = maps:get(input, Player),
    NewInput = Input#{Key := Value},
    Player#{input := NewInput}.


move_player(Player, Width, Height) -> % move o jogador conforme as atualizações 
    Input = maps:get(input, Player),

    Player1 = direction(Player, Input),
    Player2 = accelerate(Player1, Input),
    Player3 = apply_velocity(Player2),
    limit_to_map(Player3, Width, Height).


direction(Player, Input) -> % altera a direção que o jogador aponta
    Left = maps:get(left, Input),
    Right = maps:get(right, Input),

    Angle = maps:get(angle, Player),
    Mass = maps:get(mass, Player),
    Torque = maps:get(torque, Player),

    AngularAcc = Torque / Mass, % aceleração angular e linear ... de acordo com a massa corrente do jogador

    case {Left, Right} of
        {true, false} ->
            NewAngle = Angle + AngularAcc,
            rotate_velocity(Player, NewAngle);

        {false, true} ->
            NewAngle = Angle - AngularAcc,
            rotate_velocity(Player, NewAngle);

    _ ->
        Player
    end.


rotate_velocity(Player, NewAngle) ->
    Vx = maps:get(vx, Player),
    Vy = maps:get(vy, Player),

    Speed = math:sqrt(Vx * Vx + Vy * Vy),

    Player#{
        angle := NewAngle,
        vx := math:cos(NewAngle) * Speed,
        vy := -math:sin(NewAngle) * Speed
    }.


accelerate(Player, Input) -> % velocidade
    Forward = maps:get(forward, Input),

    case Forward of
        true ->
            Angle = maps:get(angle, Player),
            Mass = maps:get(mass, Player),
            Force = maps:get(force, Player),

            Speed = Force / Mass,

            Player#{
                vx := math:cos(Angle) * Speed,
                vy := -math:sin(Angle) * Speed
            };

        false ->
            Player#{
                vx := 0.0,
                vy := 0.0
            }
    end.


apply_velocity(Player) -> % atualiza a posição do jogador conforme a velocidade
    X = maps:get(x, Player),
    Y = maps:get(y, Player),
    Vx = maps:get(vx, Player),
    Vy = maps:get(vy, Player),

    Player#{
        x := X + Vx,
        y := Y + Vy
    }.


limit_to_map(Player, Width, Height) -> % impede sair do mapa
    X = maps:get(x, Player),
    Y = maps:get(y, Player),
    Vx = maps:get(vx, Player),
    Vy = maps:get(vy, Player),
    Radius = radius(Player),

    {NewX, NewVx} =
        if
            X - Radius < 0 ->
                {Radius, 0.0};

            X + Radius > Width ->
                {Width - Radius, 0.0};

            true ->
                {X, Vx}
        end,

    {NewY, NewVy} =
        if
            Y - Radius < 0 ->
                {Radius, 0.0};

            Y + Radius > Height ->
                {Height - Radius, 0.0};

            true ->
                {Y, Vy}
        end,

    Player#{
        x := NewX,
        y := NewY,
        vx := NewVx,
        vy := NewVy
    }.


radius(Player) ->
    Mass = maps:get(mass, Player),
    math:sqrt(Mass) * 4.



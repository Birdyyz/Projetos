% colisões/capturas

% distância entre círculos
% sobreposição
% captura completa
% colisão jogador-comida
% colisão jogador-veneno
% colisão jogador-jogador


-module(collisions).
-export([distance/2, overlaps/2, contains/2, handle_food/1, handle_poison/1, handle_players/1]).


distance(A, B) ->
    X1 = maps:get(x, A),
    Y1 = maps:get(y, A),
    X2 = maps:get(x, B),
    Y2 = maps:get(y, B),

    DX = X1 - X2,
    DY = Y1 - Y2,

    math:sqrt(DX * DX + DY * DY).


overlaps(A, B) ->
    Dist = distance(A, B),
    R1 = maps:get(radius, A, objects:radius(maps:get(mass, A))),
    R2 = maps:get(radius, B, objects:radius(maps:get(mass, B))),

    Dist < R1 + R2.


contains(A, B) ->
    Dist = distance(A, B),
    R1 = maps:get(radius, A, objects:radius(maps:get(mass, A))),
    R2 = maps:get(radius, B, objects:radius(maps:get(mass, B))),

    Dist + R2 =< R1.


handle_food(State) ->
    Players = maps:get(players, State),
    Foods = maps:get(foods, State),
    Width = maps:get(width, State),
    Height = maps:get(height, State),

    {NewPlayers, NewFoods} = handle_food_players(maps:to_list(Players), Players, Foods, Width, Height),

    State#{
        players := NewPlayers,
        foods := NewFoods
    }.


handle_food_players([], Players, Foods, _Width, _Height) ->
    {Players, Foods};

handle_food_players([{User, Player} | Rest], Players, Foods, Width, Height) ->
    {NewPlayer, NewFoods} = eat_food(Player, Foods, Width, Height),
    NewPlayers = Players#{User := NewPlayer},
    handle_food_players(Rest, NewPlayers, NewFoods, Width, Height).


eat_food(Player, [], _Width, _Height) ->
    {Player, []};

eat_food(Player, [Food | Rest], Width, Height) ->
    case contains(Player, Food) of
        true ->
            Mass = maps:get(mass, Player),
            FoodMass = maps:get(mass, Food),
            NewMass = Mass + FoodMass,

            NewPlayer = Player#{
                mass := NewMass,
                radius => objects:radius(NewMass)
            },

            NewFood = objects:new_random_food(Width, Height),
            {NewPlayer, [NewFood | Rest]};

        false ->
            {NewPlayer, NewRest} = eat_food(Player, Rest, Width, Height),
            {NewPlayer, [Food | NewRest]}
    end.


handle_poison(State) ->
    Players = maps:get(players, State),
    Poisons = maps:get(poisons, State),
    Width = maps:get(width, State),
    Height = maps:get(height, State),

    {NewPlayers, NewPoisons} = handle_poison_players(maps:to_list(Players), Players, Poisons, Width, Height),

    State#{
        players := NewPlayers,
        poisons := NewPoisons
    }.


handle_poison_players([], Players, Poisons, _Width, _Height) ->
    {Players, Poisons};

handle_poison_players([{User, Player} | Rest], Players, Poisons, Width, Height) ->
    {NewPlayer, NewPoisons} = touch_poison(Player, Poisons, Width, Height),
    NewPlayers = Players#{User := NewPlayer},
    handle_poison_players(Rest, NewPlayers, NewPoisons, Width, Height).


touch_poison(Player, [], _Width, _Height) ->
    {Player, []};

touch_poison(Player, [Poison | Rest], Width, Height) ->
    case overlaps(Player, Poison) of
        true ->
            Mass = maps:get(mass, Player),
            PoisonMass = maps:get(mass, Poison),

            MinMass = maps:get(min_mass, Player),
            NewMass = max(MinMass, Mass - PoisonMass),

            NewPlayer = Player#{
                mass := NewMass,
                radius => objects:radius(NewMass)
            },

            NewPoison = objects:new_random_poison(Width, Height),
            {NewPlayer, [NewPoison | Rest]};

        false ->
            {NewPlayer, NewRest} = touch_poison(Player, Rest, Width, Height),
            {NewPlayer, [Poison | NewRest]}
    end.


handle_players(State) ->
    Players = maps:get(players, State),
    Width = maps:get(width, State),
    Height = maps:get(height, State),

    PlayerList = maps:to_list(Players),
    NewPlayers = handle_player_collisions(PlayerList, Players, Width, Height),

    State#{players := NewPlayers}.


handle_player_collisions([], Players, _Width, _Height) ->
    Players;

handle_player_collisions([{User, Player} | Rest], Players, Width, Height) ->
    NewPlayers = check_against_others(User, Player, maps:to_list(Players), Players, Width, Height),
    handle_player_collisions(Rest, NewPlayers, Width, Height).


check_against_others(_User, _Player, [], Players, _Width, _Height) ->
    Players;

check_against_others(User, Player, [{OtherUser, OtherPlayer} | Rest], Players, Width, Height) ->
    case User =:= OtherUser of
        true ->
            check_against_others(User, Player, Rest, Players, Width, Height);

        false ->
            PlayerMass = maps:get(mass, Player),
            OtherMass = maps:get(mass, OtherPlayer),

            case PlayerMass > OtherMass andalso contains(Player, OtherPlayer) of
                true ->
                    Gain = OtherMass / 4,
                    NewPlayerMass = PlayerMass + Gain,
                    OtherMinMass = maps:get(min_mass, OtherPlayer, 10.0),
                    NewOtherMass = max(OtherMinMass, OtherMass - Gain),

                    Score = maps:get(score, Player, 0),

                    NewPlayer = Player#{
                        mass := NewPlayerMass,
                        radius => objects:radius(NewPlayerMass),
                        score := Score + 1
                    },

                    NewOtherPlayer = respawn_player(
                        OtherPlayer#{
                            mass := NewOtherMass,
                            radius => objects:radius(NewOtherMass)
                        },
                        Width,
                        Height
                    ),

                    NewPlayers = Players#{
                        User := NewPlayer,
                        OtherUser := NewOtherPlayer
                    },

                    check_against_others(User, NewPlayer, Rest, NewPlayers, Width, Height);

                false ->
                    check_against_others(User, Player, Rest, Players, Width, Height)
            end
    end.


respawn_player(Player, Width, Height) ->
    X = rand:uniform(round(Width)),
    Y = rand:uniform(round(Height)),

    Player#{
        x := X * 1.0,
        y := Y * 1.0,
        vx := 0.0,
        vy := 0.0
    }.



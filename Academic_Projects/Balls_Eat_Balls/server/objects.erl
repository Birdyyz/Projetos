% gerar comida/veneno

% criar comida inicial
% criar veneno inicial
% criar objeto aleatório
% repor objetos removidos
% garantir comida menor que o menor jogador


-module(objects).
-export([initial_foods/3, initial_poisons/3, new_food/3, new_random_food/2, new_random_poison/2, ensure_small_food/4, radius/1]).


initial_foods(0, _Width, _Height) ->
    [];

initial_foods(N, Width, Height) ->
    [new_random_food(Width, Height) | initial_foods(N - 1, Width, Height)].


initial_poisons(0, _Width, _Height) ->
    [];

initial_poisons(N, Width, Height) ->
    [new_random_poison(Width, Height) | initial_poisons(N - 1, Width, Height)].


new_food(Width, Height, Mass) ->
    X = rand:uniform(round(Width)),
    Y = rand:uniform(round(Height)),

    #{
        type => food,
        x => X * 1.0,
        y => Y * 1.0,
        mass => Mass,
        radius => radius(Mass)
    }.


new_random_food(Width, Height) -> % criar comidade menores e maiores que o jogador
    Mass =
        case rand:uniform(4) of
            1 ->
                12.0 + rand:uniform() * 8.0;
            _ ->
                0.2 + rand:uniform() * 1.5
        end,
    new_food(Width, Height, Mass).


new_random_poison(Width, Height) ->
    X = rand:uniform(round(Width)),
    Y = rand:uniform(round(Height)),
    Mass = 0.2 + rand:uniform() * 1.5,

    #{
        type => poison,
        x => X * 1.0,
        y => Y * 1.0,
        mass => Mass,
        radius => radius(Mass)
    }.


ensure_small_food(Foods, Players, Width, Height) ->
    PlayerList = maps:values(Players),

    case PlayerList of
        [] ->
            Foods;

        _ ->
            MinPlayerMass = lists:min([maps:get(mass, P) || P <- PlayerList]),

            HasSmallFood =
                lists:any(
                    fun(Food) ->
                        maps:get(mass, Food) < MinPlayerMass
                    end,
                    Foods
                ),

            case HasSmallFood of
                true ->
                    Foods;

                false ->
                    SmallMass = MinPlayerMass / 4,
                    [new_food(Width, Height, SmallMass) | Foods]
            end
    end.


radius(Mass) ->
    math:sqrt(Mass) * 4.



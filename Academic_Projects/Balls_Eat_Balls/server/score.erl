% pontuação/top


-module(score).
-export([start/0, add_score/2, get_top_scores/0]).


start() -> % cria tabela ETS para guardar scores em memória
    case ets:info(scores) of
        undefined ->
            ets:new(scores, [named_table, public, set]),
            ok;
        _ ->
            ok
    end.


add_score(User, Score) -> % guarda score de um vencedor
    case ets:lookup(scores, User) of

        [{User, OldScore}] when OldScore >= Score -> % já tem memória: mantém a pontuação maior
            ok;

        _ -> % primeira vez: insere
            ets:insert(scores, {User, Score})
    end.


get_top_scores() -> % devolve o ranking ordenado
    Scores = ets:tab2list(scores),

    Sorted =
        lists:sort(
            fun({_, S1}, {_, S2}) ->
                S1 >= S2
            end,
            Scores
        ),

    lists:sublist(Sorted, 10).


    
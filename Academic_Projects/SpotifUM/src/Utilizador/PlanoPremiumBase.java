package Utilizador;
import Musica.Musica;

import java.io.Serializable;

public class PlanoPremiumBase implements PlanoSubscricao, Serializable {

    private static final long serialVersionUID = 1L;

    public int atualizaPontos(Utilizador u, Musica m) {
        return u.getPontos() + 10;
    }

}
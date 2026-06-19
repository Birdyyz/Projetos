package Utilizador;
import Musica.Musica;

import java.io.Serializable;

public class PlanoPremiumTop implements PlanoSubscricao, Serializable {

    private static final long serialVersionUID = 1L;

    public int atualizaPontos(Utilizador u, Musica m) {

        // verifica se é a primeira reprodução da música
        boolean primeiraVez = (u.getHistoricoRep().get(m) == null || u.getHistoricoRep().get(m).isEmpty());

        if (primeiraVez) {
            int pontos = u.getPontos();
            long bonus = Math.round(pontos * 0.025); // soma 2.5% e arredonda corretamente
            return pontos + (int) bonus;
        }

        return u.getPontos(); // caso não ser a primeira vez que reproduz
    }

    public int pontosAdesao(Utilizador u) {
        return u.getPontos() + 100;
    }

}
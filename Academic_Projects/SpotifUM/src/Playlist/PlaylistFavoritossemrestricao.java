package Playlist;

import Musica.Musica;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class PlaylistFavoritossemrestricao extends PlaylistFavoritos {

    public PlaylistFavoritossemrestricao() {
        super();
    }

    public PlaylistFavoritossemrestricao(PlaylistFavoritossemrestricao favorito) {
        super(favorito);
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Playlist Favoritos sem Restrição:\n");
        sb.append(super.toString());
        return sb.toString();
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || this.getClass() != o.getClass()) return false;
        PlaylistFavoritossemrestricao p = (PlaylistFavoritossemrestricao) o;
        return super.equals(p);
    }

    public PlaylistFavoritossemrestricao clone(){
        return new PlaylistFavoritossemrestricao(this);
    }

    // retorna a lista das musicas q ouviu mais vezes
    public List<Musica> criaPlaylistFavoritossemrestricao(Map<Musica, Integer> numeReproducoes) {
        List<Musica> lista = new ArrayList<>(numeReproducoes.keySet());
        lista.sort((m1, m2) -> Integer.compare(numeReproducoes.get(m2), numeReproducoes.get(m1)));
        setMusicas(lista);
        return lista;
    }
    public void reproduzfavoritossemrestricao(Map<Musica, Integer> numeReproducoes,boolean manualmente) {
        List<Musica> favoritwithoutrestr = criaPlaylistFavoritossemrestricao(numeReproducoes);
        List<Musica> temp = new ArrayList<>();
        for (Musica musica : favoritwithoutrestr) {
            if(musica.getNumeroReproducoes() > 1){
                temp.add(musica);
            }
        }
        super.setMusicasReproduzidas(temp);
        setMusicas(temp);
        PlaylistPremium p = new PlaylistPremium(0, this.getAleatorio(), temp, numeReproducoes, false, false);
        if(!manualmente) {
            p.reproduzirPlaylistPremium();
        }
    }

}
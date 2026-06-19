package Playlist;

import Musica.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class PlaylistFavoritoscMusicaExplicita extends PlaylistFavoritos {

    public PlaylistFavoritoscMusicaExplicita() {
        super();
    }

    public PlaylistFavoritoscMusicaExplicita(PlaylistFavoritoscMusicaExplicita favorito) {
        super(favorito);
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Playlist Favoritos com Musica Explicita:\n");
        sb.append("Músicas:\n");
        sb.append(super.toString());
        return sb.toString();
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || this.getClass() != o.getClass()) return false;
        PlaylistFavoritoscMusicaExplicita p = (PlaylistFavoritoscMusicaExplicita) o;
        return super.equals(p);
    }

    public PlaylistFavoritoscMusicaExplicita clone() {
        return new PlaylistFavoritoscMusicaExplicita(this);
    }

    public List<Musica> criaPlaylistFavoritoscMusicaExplicita(Map<Musica, Integer> numeReproducoes) {
        List<Musica> lista = new ArrayList<>(numeReproducoes.keySet());
        lista.sort((m1, m2) -> Integer.compare(numeReproducoes.get(m2), numeReproducoes.get(m1)));
        setMusicas(lista);
        return lista;
    }

    public void reproduzfavoritoscMusicaExplicita(Map<Musica, Integer> numeReproducoes, boolean manualmente) {
        List<Musica> favoritoscMusicaExplicita = criaPlaylistFavoritoscMusicaExplicita(numeReproducoes);
        List<Musica> temp = new ArrayList<>();
        for (Musica musica : favoritoscMusicaExplicita) {
            if (musica instanceof MusicaExplicita && musica.getNumeroReproducoes() > 1) {
                temp.add(musica);
            }
        }
        setMusicas(temp);
        super.setMusicasReproduzidas(temp);
        PlaylistPremium p = new PlaylistPremium(0, this.getAleatorio(), temp, numeReproducoes, false, false);
        if(!manualmente) {
            //System.out.println("Reproduzindo playlist premium");
            p.reproduzirPlaylistPremium();
        }
    }

}
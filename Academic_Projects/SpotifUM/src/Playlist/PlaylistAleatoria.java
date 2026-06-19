package Playlist;
import Musica.Musica;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class PlaylistAleatoria extends Playlist {

    public PlaylistAleatoria() {
        super();
    }

    public PlaylistAleatoria(String nome, List<Musica> musicas) {
        super(nome,musicas);
    }

    public PlaylistAleatoria(PlaylistAleatoria aleatoria) {
        super(aleatoria);
    }

    public String toString() {
        return "Playlist Aleatória:\n" + super.toString();
    }

    public boolean equals(Object o) {
        if (this == o) return true;

        if (o == null || this.getClass() != o.getClass()) return false;

        PlaylistAleatoria p = (PlaylistAleatoria) o;
        return getMusicas().equals(p.getMusicas());
    }

    public PlaylistAleatoria clone() {
        return new PlaylistAleatoria(this);
    }

    public List<Musica> criaPlaylistAleatoria(List<Musica> musicasGlobais) {
        List<Musica> copia = new ArrayList<>(musicasGlobais);
        Collections.shuffle(copia);

        List<Musica> aleatoria = new ArrayList<>();
        for (int i = 0; i < 20; i++) {
            aleatoria.add(copia.get(i));
        }
        return aleatoria;
    }

    public void reproduzirAleatoria(List<Musica> musicas) {
        if (musicas.isEmpty()) return;
        super.reproduzirPlaylistNormal();
    }

}
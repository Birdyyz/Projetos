package Utilizador;
import Musica.*;
import Playlist.*;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Biblioteca implements Serializable {
    private static final long serialVersionUID = 2L;
    public List<Playlist> playlists;
    public List<Album> albuns;
    public List<Musica> musicas;

    // construtor padrão
    public Biblioteca() {
        this.playlists = new ArrayList<>();
        this.albuns = new ArrayList<>();
        this.musicas = new ArrayList<>();
    }

    // construtor cópia
    public Biblioteca(Biblioteca b) {
        this.albuns = new ArrayList<>(b.albuns);
        this.playlists = new ArrayList<>(b.playlists);
        this.musicas = new ArrayList<>(b.musicas);
    }

    // Getters
    public List<Playlist> getPlaylists() {
        return playlists;
    }
    public List<Album> getAlbuns() {
        return albuns;
    }
    public List<Musica> getMusicas() {
        return musicas;
    }

    public String toString() {
        return "\nÁlbuns: " + albuns + "\nPlaylists: " + playlists;
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Biblioteca b = (Biblioteca) o;
        return albuns.equals(b.albuns) && playlists.equals(b.playlists);
    }

    public Biblioteca clone() {
        return new Biblioteca(this);
    }

    private boolean playlistsSaoIguais(Playlist p1, Playlist p2) {
        List<Musica> m1 = p1.getMusicas();
        List<Musica> m2 = p2.getMusicas();

        if (m1.size() != m2.size()) return false;

        for (int i = 0; i < m1.size(); i++) {
            Musica a = m1.get(i);
            Musica b = m2.get(i);
            if (!a.getNome().equalsIgnoreCase(b.getNome()) ||
                    !a.getInterprete().equalsIgnoreCase(b.getInterprete())) {
                return false;
            }
        }
        return true;
    }

    // adiciona uma nova playlist na biblioteca (evita duplicatas por nome + conteúdo)
    public boolean adicionarPlaylist(Playlist p) {
        for (Playlist pl : playlists) {
            if (pl.getNome().equalsIgnoreCase(p.getNome()) &&
                    playlistsSaoIguais(pl, p)) {
                return false; // Já existe
            }
        }
        playlists.add(p);
        return true; // Adicionada com sucesso
    }

    // adiciona um novo album na biblioteca (evita duplicatas por nome + intérprete)
    public boolean adicionarAlbum(Album a) {
        for (Album al : albuns) {
            if (al.getNome().equalsIgnoreCase(a.getNome()) &&
                    al.getInterprete().equalsIgnoreCase(a.getInterprete())) {
                return false; // já existe
            }
        }
        albuns.add(a);
        return true;
    }

    // adiciona uma nova música na biblioteca (evita duplicatas por nome + intérprete)
    public boolean adicionarMusica(Musica m) {
        for (Musica mb : musicas) {
            if (mb.getNome().equalsIgnoreCase(m.getNome()) &&
                    mb.getInterprete().equalsIgnoreCase(m.getInterprete())) {
                return false; // já existe
            }
        }
        musicas.add(m);
        return true;
    }


}
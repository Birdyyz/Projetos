package Playlist;
import Musica.*;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Playlist implements Serializable {

    private static final long serialVersionUID = 1L;

    private String nome;
    private List<Musica> musicas;

    public Playlist() {
        this.nome = "Desconhecido";
        this.musicas = new ArrayList<>();
    }

    public Playlist(String nome, List<Musica> musicas) {
        this.nome = nome;
        this.musicas = musicas;
    }

    public Playlist(Playlist p) {
        this.nome = p.getNome();
        this.musicas = new ArrayList<>(p.getMusicas());
    }

    public String getNome() {
        return this.nome;
    }
    public List<Musica> getMusicas() {
        return this.musicas;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }
    public void setMusicas(List<Musica> musicas) {
        this.musicas = musicas;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();

        sb.append(nome).append("\n");

        if (this.getMusicas() == null || this.getMusicas().isEmpty()) {
            sb.append("(sem músicas)\n");
        } else {
            sb.append("Músicas:\n");
            for (Musica m : this.getMusicas()) {
                sb.append(m.toString());
            }
        }
        return sb.toString();
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || this.getClass() != o.getClass()) return false;
        Playlist p = (Playlist) o;
        return this.getMusicas().equals(p.getMusicas());
    }

    public Playlist clone() {
        return new Playlist(this);
    }

    public void reproduzirPlaylistNormal() {
        for (Musica musica : getMusicas()) {
            musica.reproduzir();
        }
    }

}
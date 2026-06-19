package Playlist;
import Musica.Musica;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PlaylistGeneroMusical extends Playlist{
    private int duracaoplaylist;
    private String generomusical;
    private boolean aleatorio;
    private Map<Musica, Integer> numReproducoes;

    public PlaylistGeneroMusical() {
        super();
        this.generomusical = "Desconhecido";
        this.duracaoplaylist = 0;
        this.aleatorio = false;
        this.numReproducoes = new HashMap<>();
    }

    public PlaylistGeneroMusical(PlaylistGeneroMusical outroPlaylistGeneroMusical) {
        super(outroPlaylistGeneroMusical.getNome(), new ArrayList<>(outroPlaylistGeneroMusical.getMusicas()));
        this.duracaoplaylist = outroPlaylistGeneroMusical.getDuracaoPlaylist();
        this.generomusical = outroPlaylistGeneroMusical.getGeneroMusical();
        this.aleatorio = outroPlaylistGeneroMusical.getAleatorio();
        for (Map.Entry<Musica, Integer> entry : outroPlaylistGeneroMusical.getNumReproducoes().entrySet()) {
            this.numReproducoes.put(entry.getKey(), entry.getValue());
        }

    }

    public int getDuracaoPlaylist() {
        return duracaoplaylist;
    }
    public String getGeneroMusical() {
        return generomusical;
    }
    public boolean getAleatorio() {
        return aleatorio;
    }
    public Map<Musica, Integer> getNumReproducoes() {
        return numReproducoes;
    }

    public void setDuracaoPlaylist(int duracaoplaylist) {
        this.duracaoplaylist = duracaoplaylist;
    }
    public void setGeneroMusical(String generomusical) {
        this.generomusical = generomusical;
    }
    public void setAleatorio(boolean aleatorio) {
        this.aleatorio = aleatorio;
    }
    public void setNumReproducoes(Map<Musica, Integer> numReproducoes) {
        this.numReproducoes = numReproducoes;
    }

    public String toString(){
        StringBuilder sb = new StringBuilder();
        sb.append("Duracao da playlist: " + duracaoplaylist + "\n");
        sb.append("Genero musical:" + generomusical + "\n");
        sb.append(super.toString());
        return sb.toString();
    }

    public boolean equals(Object o){
        if(this == o) return true;
        if(o == null || this.getClass() != o.getClass()) return false;
        PlaylistGeneroMusical a = (PlaylistGeneroMusical) o;
        return this.getMusicas().equals(a.getMusicas()) && this.duracaoplaylist == a.getDuracaoPlaylist() && this.generomusical.equals(a.getGeneroMusical())
                && this.aleatorio == a.getAleatorio() && this.numReproducoes.equals(a.getNumReproducoes());
    }

    public PlaylistGeneroMusical clone(){
        return new PlaylistGeneroMusical(this);
    }

    public int passarparasegundos(int duracaominutos) {
        return duracaominutos * 60;
    }

    public List<Musica> criarPlaylistPorGenero(List<Musica> musicas) {
        int duracaoEsperada = passarparasegundos(getDuracaoPlaylist());
        setDuracaoPlaylist(duracaoEsperada);

        int duracaoAtual = 0;
        List<Musica> playlistGenero = new ArrayList<>();

        for (Musica musica : musicas) {
            if (musica.getGenero().equals(this.generomusical) && (duracaoAtual + musica.getDuracao()) <= duracaoEsperada) {
                playlistGenero.add(musica);
                duracaoAtual += musica.getDuracao();
            }
        }

        // não pode ter a comparação se não retorna null na reprodução

        setDuracaoPlaylist(duracaoAtual);
        return playlistGenero;
    }

    public PlaylistPremium reproduzirmusicasGeneroMusical(List<Musica> musicas, boolean manualmente) {

        List<Musica> playlistGenero = criarPlaylistPorGenero(musicas);

        if (playlistGenero == null || playlistGenero.isEmpty()) {
            // System.out.println("Playlist vazia ou não foi possível criar a playlist.");
            setMusicas(new ArrayList<>());
            return null;
        }
        setMusicas(playlistGenero);

        PlaylistPremium pa = new PlaylistPremium(0, getAleatorio(), playlistGenero, getNumReproducoes(), false, false);

        if (!manualmente) {
            pa.reproduzirPlaylistPremium();
        }

        return pa;
    }

}
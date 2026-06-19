package Playlist;
import Musica.Musica;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class PlaylistPremium extends Playlist {
    private int posicaoatual;
    private boolean modoaleatorio;
    private List<Musica> playlistAtual;
    private Map<Musica, Integer> numReproducoes;
    private boolean jaEmbaralhada;
    private boolean publica;


    public PlaylistPremium(int posicaoatual, boolean modoaleatorio, List<Musica> playlistAtual,Map<Musica, Integer> numReproducoes, boolean jaEmbaralhada, boolean publica) {
        this.posicaoatual = posicaoatual;
        this.modoaleatorio = modoaleatorio;
        this.playlistAtual = playlistAtual;
        this.numReproducoes = numReproducoes;
        this.jaEmbaralhada = jaEmbaralhada;
        this.publica = publica;
    }

    public PlaylistPremium(PlaylistPremium playlist) {
        this.posicaoatual = playlist.getPosicaoatual();
        this.modoaleatorio = playlist.getModoaleatorio();
        this.playlistAtual = playlist.getPlaylistAtual();
        this.numReproducoes = playlist.getNumReproducoes();
        this.jaEmbaralhada = false;
        this.publica = true;
    }

    public PlaylistPremium(){
        super();
        this.posicaoatual = 0;
        this.modoaleatorio = false;
        this.playlistAtual = new ArrayList<>();
        this.numReproducoes = new java.util.HashMap<>();
    }

    public int getPosicaoatual() {
        return posicaoatual;
    }
    public boolean getModoaleatorio() {
        return modoaleatorio;
    }
    public List<Musica> getPlaylistAtual() {
        return playlistAtual;
    }
    public Map<Musica, Integer> getNumReproducoes() {
        return numReproducoes;
    }

    public boolean getJaEmbaralhada() {
        return jaEmbaralhada;
    }
    public boolean getPublica() {
        return publica;
    }

    public void setPublica(boolean publica) {
        this.publica = publica;
    }

    public void setPosicaoatual(int posicaoatual) {
        this.posicaoatual = posicaoatual;
    }
    public void setModoaleatorio(boolean modoaleatorio) {
        this.modoaleatorio = modoaleatorio;
    }

    public void setPlaylistAtual(List<Musica> playlistAtual) {
        this.playlistAtual = playlistAtual;
    }

    public void setNumReproducoes(Map<Musica, Integer> numReproducoes) {
        this.numReproducoes = numReproducoes;
    }
    public String toString(){
        StringBuilder sb = new StringBuilder();
        sb.append("modo aleatorio: " + modoaleatorio + "\n");
        sb.append("posicao atual: " + posicaoatual + "\n");
        sb.append("Músicas:\n");

        for (Musica m : playlistAtual) {
            sb.append(m.toString()).append("\n");
        }

        return sb.toString();
    }

    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || this.getClass() != o.getClass()) return false;
        PlaylistPremium s = (PlaylistPremium) o;
        return this.posicaoatual == s.getPosicaoatual() &&
                this.modoaleatorio == s.getModoaleatorio() &&
                this.playlistAtual.equals(s.getPlaylistAtual())&&
                this.numReproducoes.equals(s.getNumReproducoes()) && this.jaEmbaralhada == s.getJaEmbaralhada();
    }

    public PlaylistPremium clone() {
        return new PlaylistPremium(this);
    }

    public void reproduzirPlaylistPremium(){
        if (getModoaleatorio()) {
            Collections.shuffle(getPlaylistAtual());
        }
        //System.out.println("Reproduzir playlist premium");
        //System.out.println("Tamanho da playlist: " + getPlaylistAtual().size());
        for (Musica musica : getPlaylistAtual()) {
            musica.reproduzir();
            int count = getNumReproducoes().getOrDefault(musica, 0);
            //System.out.println(count);
            getNumReproducoes().put(musica, count + 1);
            //System.out.println(getNumReproducoes());
        }
        setMusicas(getPlaylistAtual());
    }
}
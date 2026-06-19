package Playlist;
import Musica.Musica;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class PlaylistFavoritos extends Playlist {
    private boolean aleatorio;
    private Map<Musica, Integer> numReproducoes;
    private int duracaoplaylist;
    private List<Musica> musicasReproduzidas; // para imprimir as musicas da playlist resultante

    public PlaylistFavoritos() {
        super();
        this.aleatorio = false;
        this.numReproducoes = new HashMap<>();
        this.duracaoplaylist = 0;
    }

    public PlaylistFavoritos(String nome, List<Musica> musicas, boolean aleatorio, Map<Musica, Integer> numReproducoes, int duracaoplaylist, List<Musica> musicasReproduzidas) {
        super(nome, musicas);
        this.aleatorio = aleatorio;
        this.numReproducoes = numReproducoes;
        this.duracaoplaylist = duracaoplaylist;
        this.musicasReproduzidas = musicasReproduzidas;
    }

    public PlaylistFavoritos(PlaylistFavoritos favorito) {
        super(favorito.getNome(), new ArrayList<>(favorito.getMusicas()));
        this.aleatorio = favorito.getAleatorio();
        this.numReproducoes = favorito.getNumReproducoes();
        this.duracaoplaylist = favorito.getDuracaoplaylist();
        this.musicasReproduzidas = new ArrayList<>(favorito.getMusicasReproduzidas());
    }

    public boolean getAleatorio() {
        return aleatorio;
    }
    public Map<Musica, Integer> getNumReproducoes() {
        return numReproducoes;
    }
    public int getDuracaoplaylist() {
        return duracaoplaylist;
    }
    public List<Musica> getMusicasReproduzidas() {
        return musicasReproduzidas;
    }

    public void setAleatorio(boolean aleatorio) {
        this.aleatorio = aleatorio;
    }
    public void setDuracaoplaylist(int duracaoplaylist) {
        this.duracaoplaylist = duracaoplaylist;
    }
    public void setMusicasReproduzidas(List<Musica> musicasReproduzidas) {
        this.musicasReproduzidas = musicasReproduzidas;
    }
    public void setNumReproducoes(Map<Musica, Integer> numReproducoes) {
        this.numReproducoes = numReproducoes;
    }


    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Playlist Favoritos:\n");
        sb.append("Duracao da playlist: ").append(duracaoplaylist).append("\n");

        if (musicasReproduzidas == null || musicasReproduzidas.isEmpty()) {
            sb.append("(sem músicas)\n");
        } else {
            sb.append("Músicas:\n");
            for (Musica m : musicasReproduzidas) {
                sb.append(" - ").append(m.getNome()).append(" | ").append(m.getInterprete()).append("\n");
            }
        }

        return sb.toString();
    }

    public boolean equals(Object o) {
        if (this == o) return true;

        if (o == null || this.getClass() != o.getClass()) return false;

        PlaylistFavoritos p = (PlaylistFavoritos) o;
        return this.getMusicas().equals(p.getMusicas()) && this.aleatorio == p.getAleatorio()
                && this.numReproducoes.equals(p.getNumReproducoes()) && this.duracaoplaylist == p.getDuracaoplaylist()
                && this.musicasReproduzidas.equals(p.getMusicasReproduzidas());
    }

    public PlaylistFavoritos clone() {
        return new PlaylistFavoritos(this);
    }

    public int passarparasegundos(int duracaominutos) {
        return duracaominutos * 60;
    }

    public List<Musica> criaPlaylistFavoritos(Map<Musica, Integer> reproducoes) {
        //System.out.println("Número de entradas em reproducoes: " + getNumReproducoes().size());
        if (reproducoes != null && !reproducoes.isEmpty()) {
            return reproducoes.entrySet()
                    .stream()
                    .sorted((e1, e2) -> Integer.compare(e2.getValue(), e1.getValue()))
                    .map(Map.Entry::getKey)
                    .collect(Collectors.toList());
        } else {
            return new ArrayList<>();
        }
    }

    public void reproduzirfavoritos(Map<Musica, Integer> numeReproducoes, boolean manualmente) {

        List<Musica> favorit = criaPlaylistFavoritos(numeReproducoes);// Ordena decrescentemente
        //System.out.println("Número total de músicas nos favoritos: " + favorit.size());
        List<Musica> temp = new ArrayList<>();
        // a duracao da playlist esta em minutos
        this.setDuracaoplaylist(passarparasegundos(getDuracaoplaylist()));
        //System.out.println("Duração da playlist (segundos): " + this.getDuracaoplaylist());

        int duracaoatual = 0;
        for (Musica musica : favorit) {
            //System.out.println("Música: " + musica.getNome() + " - Duração: " + musica.getDuracao());

            if (duracaoatual + musica.getDuracao() <= getDuracaoplaylist()) {
                temp.add(musica);
                duracaoatual += musica.getDuracao();
                //System.out.println("Música adicionada");
            }
        }

        //System.out.println("Tamanho da temp antes de criar PlaylistPremium: " + temp.size());

        setMusicasReproduzidas(temp);
        setMusicas(temp);
        setDuracaoplaylist(duracaoatual);
        ///System.out.println("Tamanho da temp antes de criar PlaylistPremium: " + temp.size());
        PlaylistPremium p = new PlaylistPremium(0, this.getAleatorio(), temp, numeReproducoes, false, false);
        if (!manualmente) {
            p.reproduzirPlaylistPremium();
        }
    }

}
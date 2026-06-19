package Musica;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Album implements Reproducao, Serializable {
    private String nome;
    private String interprete;
    private int duracao;
    private List<Musica> musicas;
    private static final long serialVersionUID = 1L;
    // construtor padrão
    public Album() {
        this.nome = "Desconhecido";
        this.interprete = "Desconhecido";
        this.duracao = 0;
        this.musicas = new ArrayList<>();
    }

    // construtor parametrizado
    public Album(String nome, String interprete, int duracao, List<Musica> musicas){
        this.nome = nome;
        this.interprete = interprete;
        this.duracao = duracao;
        this.musicas = new ArrayList<Musica>(musicas);
    }

    // construtor de cópia
    public Album(Album outroAlbum) {
        this.nome = outroAlbum.getNome();
        this.interprete = outroAlbum.getInterprete();
        this.duracao = outroAlbum.getDuracao();
        this.musicas = outroAlbum.getMusicas();
    }

    // getters
    public String getNome() {
        return this.nome;
    }
    public String getInterprete() {
        return this.interprete;
    }
    public int getDuracao() {
        return this.duracao;
    }
    public List<Musica> getMusicas() {
        return new ArrayList<Musica>(this.musicas);
    }

    // setters
    public void setNome(String nome) {
        this.nome = nome;
    }
    public void setMusicas(List<Musica> musicas) {
        this.musicas = new ArrayList<Musica>(musicas);
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();

        sb.append("Nome: ").append(this.nome);
        sb.append("     Intérprete: ").append(this.interprete);
        sb.append("     Duração: ").append(this.duracao);
        sb.append("     Número de músicas: ").append(this.musicas != null ? this.musicas.size() : 0);
        sb.append("\n");

        sb.append("Álbum: " + this.nome + ", " + this.interprete + ".\n");

        return sb.toString();
    }

    public boolean equals(Object o) {
        if(this == o) return true;
        if(o == null || this.getClass() != o.getClass()) return false;

        Album a = (Album) o;
        return this.nome.equals(a.nome) && this.interprete.equals(a.interprete) && this.duracao == a.duracao && this.musicas.equals(a.musicas);

    }

    public Album clone() {
        return new Album(this);
    }

    public void adicionarMusica(Musica musica){
        musicas.add(musica);
    }

    @Override
    public void reproduzir(){
        for(Musica musica : musicas){
            musica.reproduzir();
        }
    }

    @Override
    public int getNumeroReproducoes() {
        return musicas.stream().mapToInt(Musica::getNumeroReproducoes).sum();
    }

}
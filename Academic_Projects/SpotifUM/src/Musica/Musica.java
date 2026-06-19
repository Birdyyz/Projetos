package Musica;

import java.io.Serializable;
import java.util.Arrays;

public class Musica implements Reproducao, Serializable {

    private static final long serialVersionUID = 1L;

    private String nome;
    private String interprete;
    private String editora;
    private String[] letra;
    private String[] musica;
    private int duracao;
    private String genero;
    private int numeroRep;
    private Album album;

    //construtor padrão
    public Musica() {
        this.nome = "Desconhecido";
        this.interprete = "Desconhecido";
        this.editora = "Desconhecido";
        this.letra = new String[0];
        this.musica = new String[0];
        this.duracao = 0;
        this.genero = "Desconhecido";
        this.numeroRep = 0;
        this.album = new Album();
    }

    //construtor parametrizado
    public Musica(String nome, String interprete, String editora, String[] letra, String[] musica, int duracao, String genero, int numeroRep, Album album) {
        this.nome = nome;
        this.interprete = interprete;
        this.editora = editora;
        this.letra = letra;
        this.musica = musica;
        this.duracao = duracao;
        this.genero = genero;
        this.numeroRep = numeroRep;
        this.album = album;
    }

    //construtor de cópia
    public Musica(Musica outraMusica) {
        this.nome = outraMusica.getNome();
        this.interprete = outraMusica.getInterprete();
        this.editora = outraMusica.getEditora();
        this.letra = outraMusica.getLetra();
        this.musica = outraMusica.getMusica();
        this.duracao = outraMusica.getDuracao();
        this.genero = outraMusica.getGenero();
        this.numeroRep = outraMusica.getNumeroReproducoes();
        this.album = outraMusica.getAlbum();
    }

    //getters
    public String getNome() {
        return this.nome;
    }
    public String getInterprete() {
        return this.interprete;
    }
    public String getEditora() {
        return this.editora;
    }
    public String[] getLetra() {
        return this.letra.clone();
    }
    public String[] getMusica() {
        return this.musica.clone();
    }
    public int getDuracao() {
        return this.duracao;
    }
    public String getGenero() {
        return genero;
    }
    public int getNumeroRep() {
        return this.numeroRep;
    }
    public Album getAlbum() {
        return this.album;
    }

    // setters
    public void setNome(String nome) {
        this.nome = nome;
    }
    public void setMusica(String[] musica) {
        this.musica = musica.clone();
    }
    public void setNumeroRep(int numeroRep) {
        this.numeroRep = numeroRep;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Nome: ").append(this.nome);
        sb.append("     Intérprete: ").append(this.interprete);
        sb.append("     Editora: ").append(this.editora);
        sb.append("     Género Musical: ").append(this.genero);
        sb.append("     Duração: ").append(this.duracao);
        sb.append("     Número de Reproduções: ").append(this.numeroRep);
        //sb.append("\nReproduções: ").append(this.numeroReproducoes);
        sb.append("     Álbum: ").append(this.album != null ? this.album.getNome() : "Sem álbum");
        sb.append("\n");
        return sb.toString();
    }

    public boolean equals(Object o) {
        if (this == o) return true;

        if (o == null || this.getClass() != o.getClass()) return false;

        Musica m = (Musica) o;

        return this.nome.equals(m.nome) && this.interprete.equals(m.interprete) &&
                this.editora.equals(m.editora) && Arrays.equals(this.letra, m.letra) && Arrays.equals(this.musica, m.musica) &&
                this.duracao == m.duracao && this.genero.equals(m.genero) && this.numeroRep == m.numeroRep && this.album.equals(m.album);
    }

    public Musica clone() {
        return new Musica(this);
    }

    @Override
    public void reproduzir(){
        numeroRep++;
        System.out.println("A reproduzir '" + this.nome + "' por " + this.interprete);
        for(String linha : letra){
            System.out.println(linha);
        }
        System.out.println();
    }

    @Override
    public int getNumeroReproducoes(){
        return this.numeroRep;
    }

}
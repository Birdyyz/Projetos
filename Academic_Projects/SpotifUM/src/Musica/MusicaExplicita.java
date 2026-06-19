package Musica;

public class MusicaExplicita extends Musica implements Explicita {
    private static final long serialVersionUID = 1L;

    public MusicaExplicita(String nome, String interprete, String editora, String[] letra, String[] musica, int duracao, String genero, int numeroRep, Album album) {
        super(nome, interprete, editora, letra, musica, duracao, genero, numeroRep, album);
    }

    public boolean isExplicita() {
        return true;
    }
}
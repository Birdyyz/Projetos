package Musica;

public class MusicaMultimedia extends Musica implements Multimedia {
    private static final long serialVersionUID = 1L;

    public MusicaMultimedia(String nome, String interprete, String editora, String[] letra, String[] musica, int duracao, String genero, int numeroRep, Album album) {
        super(nome, interprete, editora, letra, musica, duracao, genero, numeroRep, album);
    }

    public boolean isMultimedia() {
        return true;
    }
}
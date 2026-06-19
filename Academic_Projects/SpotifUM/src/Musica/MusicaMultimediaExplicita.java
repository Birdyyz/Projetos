package Musica;

public class MusicaMultimediaExplicita extends Musica implements Explicita, Multimedia {
    private static final long serialVersionUID = 1L;

    public MusicaMultimediaExplicita(String nome, String interprete, String editora, String[] letra, String[] musica, int duracao, String genero, int numeroRep, Album album) {
        super(nome, interprete, editora, letra, musica, duracao, genero, numeroRep, album);
    }

    public boolean isMultimedia() {
        return true;
    }

    public boolean isExplicita() {
        return true;
    }

}
package Utilizador;

public class ConteudoJaExisteException extends RuntimeException {
    public ConteudoJaExisteException(){
        super();
    }

    public ConteudoJaExisteException(String message) {
        super(message);
    }
}
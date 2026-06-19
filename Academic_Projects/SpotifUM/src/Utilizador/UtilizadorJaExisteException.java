package Utilizador;

public class UtilizadorJaExisteException extends Exception{
    public UtilizadorJaExisteException(){
        super();
    }

    public UtilizadorJaExisteException(String msg){
        super(msg);
    }
}
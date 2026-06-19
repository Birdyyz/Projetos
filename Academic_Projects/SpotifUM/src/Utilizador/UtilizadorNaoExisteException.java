package Utilizador;

public class UtilizadorNaoExisteException extends Exception{
    public UtilizadorNaoExisteException(){
        super();
    }

    public UtilizadorNaoExisteException(String msg){
        super(msg);
    }
}
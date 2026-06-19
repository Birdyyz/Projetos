/*esta interface serve para receber as mensagens do servidor, 
para separar a camada de rede da lógica do cliente*/

public interface MessageHandler {
    void message(String msg);          //chamado quando o servidor envia uma linha de texto
    void disconnection(Exception e);   //quando a ligação é perdida ou occore um erro
}

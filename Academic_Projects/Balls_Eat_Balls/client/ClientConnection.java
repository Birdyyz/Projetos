import java.io.*;
import java.net.Socket;


public class ClientConnection{
    private ServerReader reader;
    private Socket con;
    private PrintWriter out;
    private BufferedReader in;

    public void connect(String host, int port, MessageHandler handler) throws IOException{
        con = new Socket(host, port);

        in = new BufferedReader(new InputStreamReader(con.getInputStream()));
        out = new PrintWriter(con.getOutputStream(), true);

        reader = new ServerReader(in, handler);
        new Thread(reader).start();
    }

    public void write(String msg){
        if(out != null){
            out.println(msg);
        }
    }

    public void close(){
        try{
            if(reader != null) reader.stop();
            if(con != null) con.close();
        }
        catch(IOException e){}
    }
}

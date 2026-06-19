import java.io.*;

public class ServerReader implements Runnable{
    private final BufferedReader in;
    private final MessageHandler handler;
    private volatile boolean running = true;

    public ServerReader(BufferedReader in, MessageHandler handler){
        this.in = in;
        this.handler = handler;
    }

    @Override
    public void run(){
        try{
            String line;

            while(running && (line = in.readLine()) != null){
                handler.message(line);
            }
        }
        catch(IOException e){
            handler.disconnection(e);
        }
    }

    public void stop(){
        running = false;
        try{
            in.close();
        }
        catch(IOException e){}
    }
}

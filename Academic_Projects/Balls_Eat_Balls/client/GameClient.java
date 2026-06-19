import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Timer;
import java.util.TimerTask;


public class GameClient {

    private final GameState gameState = new GameState();
    private Socket socket;
    private PrintWriter out;
    private BufferedReader in;
    private ServerReader reader;
    private Timer tickTimer;
    private final String user;

    private boolean gameStarted = false;

    public GameClient(String host, int port, String user) throws Exception{
        this.user = user;

        socket = new Socket(host, port);
        out = new PrintWriter(socket.getOutputStream(), true);
        in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

        ProtocolMessageHandler handler = new ProtocolMessageHandler(gameState, in);
        reader = new ServerReader(in, handler);
        new Thread(reader).start();

        new Thread(() -> {
            while(!handler.started){
                try{
                    Thread.sleep(100);
                } catch(Exception ignored){}
            }

            System.out.println("Starting game loop");
            startGame();
        
        }).start();

        // startTickLoop();
    }

    //enviar o input
    public void setForward(boolean value){
        send("INPUT " + user + " forward " + value);
    }

    public void setLeft(boolean value){
        send("INPUT " + user + " left " + value);
    }

    public void setRight(boolean value){
        send("INPUT " + user + " right " + value);
    }

    private void send(String msg){
        System.out.println("SEND: " + msg);
        out.println(msg);
    }

    public void register(String pass){
        send("REGISTER " + user + " " + pass);
    }

    public void login(String pass){
        send("LOGIN " + user + " " + pass);
    }
    
    public void unregister(String pass){
        send("UNREGISTER " + user + " " + pass);
    }

    public void startGame(){
        if(!gameStarted){
            gameStarted = true;
            startTickLoop();
        }
    }

    private void startTickLoop(){
        tickTimer = new Timer(true);
        tickTimer.scheduleAtFixedRate(new TimerTask(){
            @Override
            public void run() {
                out.println("TICK");
                out.println("GET");
            }
        }, 0, 33);
    }

    public GameState getState(){
        return gameState;
    }

    public void close(){
        try {
            tickTimer.cancel();
            socket.close();
        } catch (Exception ignored) {}
    }
}

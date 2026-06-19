import java.io.BufferedReader;
import java.util.ArrayList;
import java.util.List;

public class ProtocolMessageHandler implements MessageHandler{
    private final GameState gameState;
    private final BufferedReader in;

    public boolean started = false;

    public ProtocolMessageHandler(GameState gameState, BufferedReader in){
        this.gameState = gameState;
        this.in = in;
    }

    @Override
    public void message(String msg){

        System.out.println("Server: " + msg);

        try{
          
            if(msg.equals("FINISH")){
                gameState.finished = true;
                return;
            }
                      
            if(msg.equals("OK")){
                gameState.loggedIn = true;
                return;
            }
            
            if(msg.equals("ERROR")){
                gameState.loggedIn = false;
                return;
            }
          
            if(msg.startsWith("TOP")){
                gameState.topScores = msg.substring(3).trim();
                return;
            }

            if(msg.equals("START")){
                System.out.println("Game Started");
                started = true;
                return;
            }    

            if(msg.startsWith("MAP")){
                String[] m = msg.split(" ");
                gameState.width = Double.parseDouble(m[1]);
                gameState.height = Double.parseDouble(m[2]);
            }

            else if(msg.startsWith("STATE_BEGIN")){

                List<String> lines = new ArrayList<>();

                String line;
                while((line = in.readLine()) != null){

                    if(line.equals("STATE_END")){
                        break;
                    }
                    lines.add(line);
                }

                gameState.updateState(lines);
            }
        }
        catch (Exception e){
            disconnection(e);
        }
    }


    @Override
    public void disconnection(Exception e) {
        System.out.println("Connection to server lost: " + e.getMessage());
    }
}

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GameState {
    public double width;
    public double height;
    
    public boolean loggedIn = false; // para verificar se o login é válido
    public String topScores = ""; // para mostrar o top de ranking
    public boolean finished = false; // verifica se o jogo acabou

    public Map<String, PlayerState> players = new HashMap<>();
    public List<ObjectState> foods = new ArrayList<>();
    public List<ObjectState> poisons = new ArrayList<>();

    public synchronized void updateState(List<String> lines){
        players.clear();
        foods.clear();
        poisons.clear();

        for(String line : lines){
            if(line.startsWith("PLAYER")){
                String[] p = line.split(" ");
                String nome = p[1];
                double posx = Double.parseDouble(p[2]);
                double posy = Double.parseDouble(p[3]);
                double mass = Double.parseDouble(p[4]);
                double angle = Double.parseDouble(p[5]);
                int score = Integer.parseInt(p[6]);

                players.put(nome, new PlayerState(nome, posx, posy, angle, mass,score));
            }

            else if(line.startsWith("FOOD")){
                String[] f = line.split(" ");
                double posx = Double.parseDouble(f[1]);
                double posy = Double.parseDouble(f[2]);
                double mass = Double.parseDouble(f[3]);

                foods.add(new ObjectState(posx, posy, mass));
            }

            else if(line.startsWith("POISON")){
                String[] p = line.split(" ");
                double posx = Double.parseDouble(p[1]);
                double posy = Double.parseDouble(p[2]);
                double mass = Double.parseDouble(p[3]);

                poisons.add(new ObjectState(posx, posy, mass));
            }

            else if(line.startsWith("MAP")){
                String[] m = line.split(" ");
                width = Double.parseDouble(m[1]);
                height = Double.parseDouble(m[2]);
            }
        }
    }
    
    public synchronized ArrayList<PlayerState> getPlayersCopy(){
        return new ArrayList<PlayerState>(players.values());
    }
    
    public synchronized ArrayList<ObjectState> getFoodsCopy(){
        return new ArrayList<ObjectState>(foods);
    }
    
    public synchronized ArrayList<ObjectState> getPoisonsCopy(){
        return new ArrayList<ObjectState>(poisons);
    }
}

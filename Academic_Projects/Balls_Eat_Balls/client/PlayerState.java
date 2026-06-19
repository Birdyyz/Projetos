public class PlayerState {
    public String name;
    public double posx;
    public double posy;
    public double angle;
    public double mass;
    public int kills;

    public PlayerState(String name, double posx, double posy, double angle, double mass, int kills){
        this.name = name;
        this.posx = posx;
        this.posy = posy;
        this.angle = angle;
        this.mass = mass;
        this.kills = kills;
    }
}

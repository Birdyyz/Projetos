import java.util.ArrayList;
import java.util.Map;

GameClient client;

boolean up, left, right;
// TIME
int gameStartTime = 0;
int gameDuration = 120000; // 2 minutos em ms
boolean timerStarted = false;
int endScreenStartTime = 0; // variável para quando terminar voltar ao lobby

int state = 0;
// 0 = login
// 1 = lobby
// 2 = game
// 3 = end screen

String usernameInput = "";
String passwordInput = "";
String username = "";

String loginMessage = "";

boolean typingUsername = true;
boolean typingPassword = false;

PFont font;

ArrayList<PlayerState> finalPlayers =
  new ArrayList<PlayerState>();

// =========================
// SETUP
// =========================

void setup(){

  size(800, 600);

  font = createFont("SansSerif", 18);
  textFont(font);
}


// =========================
// DRAW
// =========================

void draw(){

  background(0);

  // atualização automática de estado
  if (client != null && state != 2 && state != 3) {
  
    GameState gs = client.getState();
  
    if (gs.players.size() > 0) {
  
      state = 2;
  
      if (!timerStarted) {
        gameStartTime = millis();
        timerStarted = true;
      }
    }
  }

  if(state == 0){
    drawLogin();
  }

  else if(state == 1){
    drawLobby();
  }

  else if(state == 2){
    drawGame();
  }
  else if(state == 3){
    drawEndScreen();
  }
}


// =========================
// LOGIN SCREEN
// =========================

void drawLogin(){

  background(40);

  textAlign(CENTER, CENTER);

  fill(255);
  textSize(42);

  text("Balls Eat Balls", width/2, 100);

  rectMode(CENTER);

  // USERNAME
  fill(255);
  rect(width/2, 220, 300, 50);

  fill(0);
  textSize(18);

  text(usernameInput, width/2, 220);

  // PASSWORD
  fill(255);
  rect(width/2, 320, 300, 50);

  String hidden = "";

  for(int i = 0; i < passwordInput.length(); i++){
    hidden += "*";
  }

  fill(0);
  text(hidden, width/2, 320);

  // LOGIN BUTTON
  fill(100, 200, 100);
  rect(width/2 - 100, 430, 150, 60);

  fill(0);
  text("LOGIN", width/2 - 100, 430);

  // REGISTER BUTTON
  fill(100, 100, 255);
  rect(width/2 + 100, 430, 150, 60);

  fill(255);
  text("REGISTER", width/2 + 100, 430);
  
  // UNREGISTER BUTTON
  fill(220, 80, 80);
  rect(width/2, 500, 220, 50);
  
  fill(255);
  text("CANCEL REGISTER", width/2, 500);

  // MESSAGE
  fill(255, 200, 200);
  textSize(16);

  text(loginMessage, width/2, 560);
}


// =========================
// LOBBY
// =========================

void drawLobby(){

  background(30);

  fill(255);

  textAlign(CENTER, CENTER);

  textSize(30);
  text("LOBBY", width/2, height/2);

  textSize(16);
  text(loginMessage, width/2, height/2 + 50);
  
  if(client != null){ // mostrar o top enquanto procura jogadores
    String top = client.getState().topScores;
  
    textSize(20);
    text("TOP SCORES", width/2, height/2 + 100);
  
    textSize(16);
  
    if(top.length() == 0){
      text("No scores yet", width/2, height/2 + 130);
    } else {
      text(top, width/2, height/2 + 130);
    }
  }
}


// =========================
// GAME
// =========================

void drawGame(){
  background(200);

  if(client == null) return;

  GameState gs = client.getState();

  int remaining =
    max(0, gameDuration - (millis() - gameStartTime));

  // =========================
  // FIM DO JOGO
  // =========================

  if (gs.finished || remaining <= 0) {

    // guarda snapshot final dos players
    finalPlayers = new ArrayList<PlayerState>();

    for (PlayerState p : gs.getPlayersCopy()) {
      finalPlayers.add(p);
    }

    endScreenStartTime = millis();
    state = 3;
    return;
  }

  // MAPA
  noFill();

  stroke(0);
  strokeWeight(4);

  rectMode(CORNER);

  rect(
    0,
    0,
    (float)gs.width,
    (float)gs.height
  );

  strokeWeight(1);

  // =========================
  // FOODS
  // =========================

  for(ObjectState food : gs.getFoodsCopy()){
    
    fill(0, 255, 0);

    float r = sqrt((float)food.mass) * 4;
    
    ellipse(
        (float)food.posx,
        (float)food.posy,
        r * 2,
        r * 2
    );
  }

  // =========================
  // POISONS
  // =========================

  for(ObjectState poison : gs.getPoisonsCopy()){
    
    fill(255, 0, 0);

    float r = sqrt((float)poison.mass) * 4;
    
    ellipse(
        (float)poison.posx,
        (float)poison.posy,
        r * 2,
        r * 2
    );
  }

  // =========================
  // PLAYERS
  // =========================
  
  ArrayList<PlayerState> players = gs.getPlayersCopy();
  
  // 1 desenha primeiro os OUTROS jogadores
  for (PlayerState p : players) {
  
    if (p.name.equals(username)) continue;
  
    float r = sqrt((float)p.mass) * 4;
  
    stroke(255, 0, 0); // vermelho para outros
    strokeWeight(4);
    fill(0);
  
    ellipse(
      (float)p.posx,
      (float)p.posy,
      r * 2,
      r * 2
    );
  
    strokeWeight(2);
    stroke(255);
  
    line(
      (float)p.posx,
      (float)p.posy,
      (float)(p.posx + Math.cos(p.angle) * r),
      (float)(p.posy - Math.sin(p.angle) * r)
    );
  
    noStroke();
    fill(255);
    textAlign(CENTER);
    textSize(16);
  
    text(
      p.name,
      (float)p.posx,
      (float)(p.posy - r - 10)
    );
  }
  
  // 2 desenha o MEU jogador no fim, por cima dos outros
  for (PlayerState p : players) {
  
    if (!p.name.equals(username)) continue;
  
    float r = sqrt((float)p.mass) * 4;
  
    stroke(0, 0, 255); // azul para mim
    strokeWeight(4);
    fill(0);
  
    ellipse(
      (float)p.posx,
      (float)p.posy,
      r * 2,
      r * 2
    );
  
    strokeWeight(2);
    stroke(255);
  
    line(
      (float)p.posx,
      (float)p.posy,
      (float)(p.posx + Math.cos(p.angle) * r),
      (float)(p.posy - Math.sin(p.angle) * r)
    );
  
    noStroke();
    fill(255);
    textAlign(CENTER);
    textSize(16);
  
    text(
      p.name,
      (float)p.posx,
      (float)(p.posy - r - 10)
    );
  }

// =========================
// TIMER
// =========================

  int seconds = remaining / 1000;
  int minutesPart = seconds / 60;
  int secondsPart = seconds % 60;
  
  String timerText =
    nf(minutesPart, 2) + ":" +
    nf(secondsPart, 2);
  
  fill(255);
  textSize(28);
  textAlign(RIGHT, TOP);
  
  text(timerText, width - 20, 20);
}


void drawEndScreen() {

  background(0);


  fill(255);
  noStroke();
  textAlign(CENTER, CENTER);

  textSize(40);
  text("GAME OVER", width/2, 80);

  textSize(24);

  // ordena ranking final
  for (int i = 0; i < finalPlayers.size(); i++) {
  
    for (int j = i + 1; j < finalPlayers.size(); j++) {
  
      if (finalPlayers.get(i).kills <
        finalPlayers.get(j).kills) {
  
        PlayerState temp = finalPlayers.get(i);
  
        finalPlayers.set(i, finalPlayers.get(j));
  
        finalPlayers.set(j, temp);
      }
    }
  }
  
  int limit = min(4, finalPlayers.size());
  
  for (int i = 0; i < limit; i++) {
    PlayerState p = finalPlayers.get(i);
    String medal;

    if (i == 0) medal = "1. ";
    else if (i == 1) medal = "2. ";
    else if (i == 2) medal = "3. ";
    else medal = (i + 1) + ". ";

    text(
      medal + p.name + " - " + p.kills,
      width/2,
      160 + i * 40
    );
  }

  textSize(16);
  text("Returning to lobby...", width/2, height - 60);
  
  if (millis() - endScreenStartTime > 5000) {
  
    // limpa estado antigo
    if (client != null) {
      client.getState().finished = false;
      client.getState().players.clear();
      client.getState().foods.clear();
      client.getState().poisons.clear();
    }
  
    timerStarted = false;
    gameStartTime = 0;
    state = 1;
  }
}


// =========================
// MOUSE
// =========================

void mousePressed(){

  if(state != 0) return;

  // =========================
  // USERNAME FIELD
  // =========================

  if(mouseX > width/2 - 150 &&
     mouseX < width/2 + 150 &&
     mouseY > 220 - 25 &&
     mouseY < 220 + 25){

    typingUsername = true;
    typingPassword = false;
  }

  // =========================
  // PASSWORD FIELD
  // =========================

  else if(mouseX > width/2 - 150 &&
          mouseX < width/2 + 150 &&
          mouseY > 320 - 25 &&
          mouseY < 320 + 25){

    typingUsername = false;
    typingPassword = true;
  }

  // =========================
  // LOGIN BUTTON
  // =========================

  else if(mouseX > (width/2 - 100) - 75 &&
          mouseX < (width/2 - 100) + 75 &&
          mouseY > 430 - 30 &&
          mouseY < 430 + 30){

    loginMessage = "Logging in...";
    timerStarted = false;
    gameStartTime = 0;
    
    try {

      // fecha conexão antiga
      if(client != null){
        client.close();
      }

      username = usernameInput;

      new Thread(new Runnable() {
        public void run() {
          try {
     
            username = usernameInput;
            
            // para localhost
            client = new GameClient("192.168.43.35", 12345, username);
      
            client.login(passwordInput);
      
            Thread.sleep(300);

            if(client.getState().loggedIn){
              state = 1;
              loginMessage = "Login OK";
            } else {
              client.close();
              client = null;
              state = 0;
              loginMessage = "Login failed";
            }
                  
          } catch(Exception e) {
            loginMessage = "Connection failed";
            println(e);
          }
        }
      }).start();

    } catch(Exception e){

      loginMessage = "Connection failed";
      println(e);
    }
  }

  // =========================
  // REGISTER BUTTON
  // =========================

  else if(mouseX > (width/2 + 100) - 75 &&
          mouseX < (width/2 + 100) + 75 &&
          mouseY > 430 - 30 &&
          mouseY < 430 + 30){

    loginMessage = "Creating account...";
    timerStarted = false;
    gameStartTime = 0;
    
    try {

      // fecha conexão antiga
      if(client != null){
        client.close();
      }

      username = usernameInput;

      new Thread(new Runnable() {
        public void run() {
          try {
      
            username = usernameInput;

            // para testar localhost
            client = new GameClient("192.168.43.35", 12345, username);

            client.register(passwordInput);
      
            loginMessage = "Account created, login now";
      
          } catch(Exception e) {
            loginMessage = "Connection failed";
            println(e);
          }
        }
      }).start();
      
    } catch(Exception e){

      loginMessage = "Connection failed";
      println(e);
    }
  }
  // =========================
  // UNREGISTER BUTTON
  // =========================
    
  else if(mouseX > width/2 - 110 &&
            mouseX < width/2 + 110 &&
            mouseY > 500 - 25 &&
            mouseY < 500 + 25){
    
    loginMessage = "Cancelling registration...";
    timerStarted = false;
    gameStartTime = 0;
    
    try {
    
      if(client != null){
          client.close();
      }
    
      username = usernameInput;
    
      new Thread(new Runnable() {
        public void run() {
          try {
    
            username = usernameInput;

            // para testar no localhist
            client = new GameClient("127.0.0.1", 12345, username);
    
            client.unregister(passwordInput);
    
            loginMessage = "Registration cancelled";
    
          } catch(Exception e) {
            loginMessage = "Connection failed";
            println(e);
          }
        }
      }).start();
    
    } catch(Exception e){
      loginMessage = "Connection failed";
      println(e);
    }
  }
}


// =========================
// KEY PRESSED
// =========================

void keyPressed(){

  // =========================
  // LOGIN INPUT
  // =========================

  if(state == 0){

    // USERNAME
    if(typingUsername){

      if(key == BACKSPACE &&
         usernameInput.length() > 0){

        usernameInput =
          usernameInput.substring(
            0,
            usernameInput.length() - 1
          );
      }

      else if(key != ENTER &&
              key != CODED){

        usernameInput += key;
      }
    }

    // PASSWORD
    if(typingPassword){

      if(key == BACKSPACE &&
         passwordInput.length() > 0){

        passwordInput =
          passwordInput.substring(
            0,
            passwordInput.length() - 1
          );
      }

      else if(key != ENTER &&
              key != CODED){

        passwordInput += key;
      }
    }
  }

  // =========================
  // GAME INPUT
  // =========================

  if(state == 2 && client != null){

    if(keyCode == UP){
      client.setForward(true);
    }

    if(keyCode == LEFT){
      client.setLeft(true);
    }

    if(keyCode == RIGHT){
      client.setRight(true);
    }
  }
}


// =========================
// KEY RELEASED
// =========================

void keyReleased(){

  if(state == 2 && client != null){

    if(keyCode == UP){
      client.setForward(false);
    }

    if(keyCode == LEFT){
      client.setLeft(false);
    }

    if(keyCode == RIGHT){
      client.setRight(false);
    }
  }
}

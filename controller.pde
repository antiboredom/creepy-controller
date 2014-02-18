// We need a few java libraries to do the authenticated HTTP request
import java.net.Authenticator;
import java.net.PasswordAuthentication;
import java.net.URL;
import java.net.URLConnection;
import java.io.InputStreamReader;

// Remember to change the CAMERA_IP and the USERNAME/PASSWORD values
String baseURL = "http://IPADDRESS";
String username = "";
String password = "";
String videoStream = baseURL + "/mjpg/video.mjpg";
String axisCamControlUrl = baseURL + "/axis-cgi/com/ptz.cgi?";

public static final int LEFT = 1;
public static final int RIGHT = 2;
public static final int UP = 3;
public static final int DOWN = 4;
public static final int TOPLEFT = 5;
public static final int TOPRIGHT = 6;
public static final int BOTTOMLEFT = 7;
public static final int BOTTOMRIGHT = 8;
public static final int ZOOMIN = 9;
public static final int ZOOMOUT = 10;

public static final int WIDTH = 800;
public static final int HEIGHT = 450;

int speed = 50;

MJPEGParser parser;
PImage currentFrame;

// We'll call the moveCamera method with LEFT or RIGHT to actually trigger the movement.
void moveCamera(int direction) 
{
  String command = "speed=" + speed;
  if (direction == LEFT) 
  {
    // Move left, at speed 50 and zoom into 10%
    command += "&move=left";
  }
  else if (direction == RIGHT) 
  {
    // Move right, at speed 50 and zoom all the way out
    command += "&move=right";
  }   
  else if (direction == UP) 
  {
    // Move right, at speed 50 and zoom all the way out
    command += "&move=up";
  }

  else if (direction == DOWN) 
  {
    // Move right, at speed 50 and zoom all the way out
    command += "&move=down";
  }

  else if (direction == TOPLEFT) 
  {
    // Move right, at speed 50 and zoom all the way out
    command += "&move=upleft";
  }

  else if (direction == TOPRIGHT) 
  {
    // Move right, at speed 50 and zoom all the way out
    command += "&move=upright";
  }

  else if (direction == BOTTOMLEFT) 
  {
    // Move right, at speed 50 and zoom all the way out
    command += "&move=downleft";
  }

  else if (direction == BOTTOMRIGHT) 
  {
    // Move right, at speed 50 and zoom all the way out
    command += "&move=downright";
  }

  else if (direction == ZOOMIN) 
  {
    // Move right, at speed 50 and zoom all the way out
    command += "&rzoom=" + speed * 10;
  }

  else if (direction == ZOOMOUT) 
  {
    // Move right, at speed 50 and zoom all the way out
    command += "&rzoom=" + speed * -10;
  }

  authHTTPRequest(username, password, axisCamControlUrl + command);
}

void setup() {
  // Move it right away to make sure it works 
  size(WIDTH, HEIGHT);  
  parser = new MJPEGParser(videoStream, WIDTH, HEIGHT, username, password, this); 
  currentFrame = createImage(WIDTH, HEIGHT, RGB);
}

// newFrame is called by the MJPEGParser each time there is a new frame available.
void newFrame(PImage newPimage) {
  currentFrame = newPimage;
}

void draw() {
  image(currentFrame, 0, 0);
  fill(255);
  text("Speed: " + speed, 10, 10);
}
// We are going to move on pressing the r or l keys
void keyPressed() {
  println(keyCode);
  if (keyCode == 68) {
    moveCamera(RIGHT);
  } 
  else if (keyCode == 65) {
    moveCamera(LEFT);
  }
  else if (keyCode == 87) {
    moveCamera(UP);
  }
  else if (keyCode == 83) {
    moveCamera(DOWN);
  }

  else if (keyCode == 81) {
    moveCamera(TOPLEFT);
  }
  else if (keyCode == 69) {
    moveCamera(TOPRIGHT);
  }
  else if (keyCode == 90) {
    moveCamera(BOTTOMLEFT);
  }
  else if (keyCode == 67) {
    moveCamera(BOTTOMRIGHT);
  }
  else if (keyCode == 91) {
    speed --;
  } 
  else if (keyCode == 93) {
    speed ++;
  }

  else if (keyCode == 38) {
    moveCamera(ZOOMIN);
  }

  else if (keyCode == 40) {
    moveCamera(ZOOMOUT);
  }
  //topleft = 81
  //topright = 69
  //bottomleft = 90
  //bottomright = 67 
  speed = constrain(speed, 1, 500);
}

// This is the authenticated HTTP request
void authHTTPRequest(String username, String password, String url) {
  try 
  {
    Authenticator.setDefault(new HTTPAuthenticator(username, password));

    URL urlObject = new URL(url);
    URLConnection urlConnection = urlObject.openConnection();

    BufferedReader in = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
    String inputLine;
    while ( (inputLine = in.readLine ()) != null) 
      println(inputLine);
    in.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}

class HTTPAuthenticator extends Authenticator {
  private String username, password;

  public HTTPAuthenticator(String user, String pass) {
    username = user;
    password = pass;
  }

  protected PasswordAuthentication getPasswordAuthentication() {
    System.out.println("Requesting Host  : " + getRequestingHost());
    System.out.println("Requesting Port  : " + getRequestingPort());
    System.out.println("Requesting Prompt : " + getRequestingPrompt());
    System.out.println("Requesting Protocol: "
      + getRequestingProtocol());
    System.out.println("Requesting Scheme : " + getRequestingScheme());
    System.out.println("Requesting Site  : " + getRequestingSite());
    return new PasswordAuthentication(username, password.toCharArray());
  }
}  


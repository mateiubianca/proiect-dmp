import processing.serial.*;

int startButX, startButY1, startButY2, startButY3;
int rWidth = 120;
int rHeight = 40;
int offset = 50;
int lvl1 = 200;
int lvl2 = 120;
int lvl3 = 80;
int speed = lvl1;

color buttonColor;
color buttonHighlight;

boolean hover1 = false, hover2 = false, hover3 = false;
boolean gameStarted = false;
boolean gameOver = false;
boolean ate = false;

String boardCommand = "";
char direction = 'r';
int score = 0;

int snakeLength = 3;
int cols = 50;
int rows = 30;
float cellSize = 10.0;

Cell[] snake;
Cell[][] grid;
Cell food;

Serial myPort;

PFont f;

void setup() {
  size(600, 400);
  f = createFont("Arial", 16, true);
  buttonColor = color(0);
  buttonHighlight = color(51);

  startButX = width / 2 - rWidth/2;
  startButY1 = height / 3 - rHeight / 2; 
  startButY2 = height / 2 - rHeight / 2;
  startButY3 = 2 * height / 3 - rHeight / 2;

  grid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if ((i == 0 || i == cols - 1) || (j == 0 || j == rows - 1)) {
        grid[i][j] = new Cell(i*cellSize + offset, j*cellSize + offset, cellSize, cellSize, #000000, 'n');
      } else {
        grid[i][j] = new Cell(i*cellSize + offset, j*cellSize + offset, cellSize, cellSize, #E5E5E5, 'n');
      }
    }
  }

  snake = new Cell[100];


  float snakeStartX = width / 2.0;
  float snakeStartY = height / 2.0;

  for (int i = 0; i < snakeLength; i++) {
    snake[i] = new Cell(snakeStartX + i * cellSize, snakeStartY, cellSize, cellSize, #00cd00, 'r');
  }  
  food = generateFood();

  printArray(Serial.list());
  //myPort = new Serial(this, Serial.list()[Serial.list().length - 1], 9600);
  myPort = new Serial(this, Serial.list()[0], 9600);
}

void draw() {
  if (gameOver) {
    textFont(f, 25);                  
    fill(0);       
    text("Game over!", 220, 200);
  } else {
    if (!gameStarted) {
      updateMousePosition();
      displayButtons();
    } else {
      background(125);
      displayGrid();
      food.display();
      for (int i = 0; i < snakeLength; i++) {
        snake[i].display();
        println(snakeLength);
        //println(snake[i].y);
      }
      readCommands();
      checkFood();
      if (!ate) {
        moveSnake();
      }
      textFont(f, 16);                  
      fill(0);       
      text("Score: " + score, 250, 25);
      gameOver = checkGameOver();
      delay(speed);
    }
  }
}

void displayButtons() {
  if (hover1) {
    fill(buttonHighlight);
  } else {
    fill(buttonColor);
  }
  stroke(255);
  rect(startButX, startButY1, rWidth, rHeight);
  fill(255);
  text("Level 1", startButX + rHeight + 5, startButY1 + rHeight / 2 + 5);

  if (hover2) {
    fill(buttonHighlight);
  } else {
    fill(buttonColor);
  }
  stroke(255);
  rect(startButX, startButY2, rWidth, rHeight);
  fill(255);
  text("Level 2", startButX + rHeight + 5, startButY2 + rHeight / 2 + 5);

  if (hover3) {
    fill(buttonHighlight);
  } else {
    fill(buttonColor);
  }
  stroke(255);
  rect(startButX, startButY3, rWidth, rHeight);
  fill(255);
  text("Level 3", startButX + rHeight + 5, startButY3 + rHeight / 2 + 5);
}

void displayGrid() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].display();
    }
  }
}

void turnSnake() {
  snake[snakeLength - 1].dir = direction;
};

boolean checkGameOver() {
  Cell head = snake[snakeLength - 1];
  if (head.getSquareX() == 0 || head.getSquareX() == (cols - 1) || head.getSquareY() == 0 || head.getSquareY() == (rows - 1)) {
    return true;
  } else {
    for (int i = 0; i < snakeLength - 1; i++) {
      if (head.getSquareX() == snake[i].getSquareX() && head.getSquareY() == snake[i].getSquareY()) {
        return true;
      }
    }
  }
  return false;
}

void readCommands() {
  while (myPort.available() > 0) {
    boardCommand = myPort.readString();
    if (boardCommand.startsWith("up") && direction != 'd') {
      direction = 'u';
    }
    if (boardCommand.startsWith("down") && direction != 'u') {
      direction = 'd';
    }
    if (boardCommand.startsWith("left") && direction != 'r') {
      direction = 'l';
    }
    if (boardCommand.startsWith("right") && direction != 'l') {
      direction = 'r';
    }
    turnSnake();
  }
}

void moveSnake() {
  for (int i = 0; i < snakeLength; i++) {
    if (snake[i].dir == 'u') {
      snake[i].moveUp();
    } else if (snake[i].dir == 'd') {
      snake[i].moveDown();
    } else if (snake[i].dir == 'l') {
      snake[i].moveLeft();
    } else if (snake[i].dir == 'r') {
      snake[i].moveRight();
    }
  }
  for (int i = 0; i <= snakeLength - 2; i++) {
    snake[i].dir = snake[i + 1].dir;
  }
}

void checkFood() {
  Cell head = snake[snakeLength - 1];
  if (head.x == food.x && head.y == food.y) {
    snakeLength++; 
    if (head.dir == 'r') {
      snake[snakeLength - 1] = new Cell(head.x + cellSize, head.y, cellSize, cellSize, #00cd00, head.dir);
    }
    if (head.dir == 'l') {
      snake[snakeLength - 1] = new Cell(head.x - cellSize, head.y, cellSize, cellSize, #00cd00, head.dir);
    }
    if (head.dir == 'u') {
      snake[snakeLength - 1] = new Cell(head.x, head.y - cellSize, cellSize, cellSize, #00cd00, head.dir);
    }
    if (head.dir == 'd') {
      snake[snakeLength - 1] = new Cell(head.x, head.y + cellSize, cellSize, cellSize, #00cd00, head.dir);
    }

    food = generateFood();
    score++; 
    ate = true;
  } else {
    ate = false;
  }
}

Cell generateFood() {
  float x = random(0, 50);
  float y = random(0, 30);
  float newX = x;
  float newY = y;
  do {
    for (int i = 0; i < snakeLength; i++) {
      if (snake[i].x == x && snake[i].y == y) {
        newX = random(0, 50);
        newY = random(0, 30);
      }
    }
  } while (newX != x || newY != y);
  //println(newX);
  //println(newY);
  return new Cell((float)(offset + Math.floor(newX) * cellSize), (float)(offset + Math.floor(newY) * cellSize), cellSize, cellSize, #ff0000, 'n');
}

void updateMousePosition() {
  hover1 = overRect(startButX, startButY1, rWidth, rHeight);
  hover2 = overRect(startButX, startButY2, rWidth, rHeight);
  hover3 = overRect(startButX, startButY3, rWidth, rHeight);
}

void mousePressed() {
  if (hover1) {
    speed = lvl1;
    gameStarted = true;
  }
  if (hover2) {
    speed = lvl2;
    gameStarted = true;
  }
  if (hover3) {
    speed = lvl3;
    gameStarted = true;
  }
}

boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x + width &&
    mouseY >= y && mouseY <= y + height) {
    return true;
  } else {
    return false;
  }
}

class Cell {
  // A cell object knows about its location in the grid 
  // as well as its size with the variables x,y,w,h
  float x, y;   // x,y location
  float w, h;   // width and height
  color c;     //color
  char dir;

  // Cell Constructor
  Cell(float tempX, float tempY, float tempW, float tempH, int tempC, char tempDir) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    c = tempC;
    dir = tempDir;
  } 

  void display() {
    stroke(c);
    fill(c);
    rect(x, y, w, h);
  }

  void moveUp() {
    this.y -= h;
  }

  void moveDown() {
    this.y += h;
  }

  void moveRight() {
    this.x += w;
  }

  void moveLeft() {
    this.x -= w;
  }

  int getSquareX() {
    return (int)((x - offset)/cellSize);
  }

  int getSquareY() {
    return (int)((y - offset)/cellSize);
  }
}

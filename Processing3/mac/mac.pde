int rgFootAngle = 0, lfFootAngle = 0, rgArmAngle = 30, lfArmAngle = 30, headAngle = 0, mouthState = 0, windmillAngle = 0;
int sadMovement = 0, happyMovement = 0, armSeparation = 0;
int emotion;
boolean headRight = true, armsDown = true, startEmotion = false, happyMovementDir = false;
int posX = 1280/2+50, posY = 2*720/3;

PImage farm, windmill;

color skin, jacket, shirt, shoes, shorts, lowerHat, upperHat, tie;

void setup() {
  size(1280, 720);
  background(255);
  
  emotion = 0;
  
  farm = loadImage("happy-farm-bg.png");
  windmill = loadImage("windmill.png");
  
  skin = color(242, 189, 150);
  jacket = color(237, 218, 190);
  shirt = color(255);
  shoes = color(80, 50, 10);
  shorts = color(115, 70, 10);
  lowerHat = color(80, 50, 10);
  upperHat = color(70, 42, 5);
  tie = color(0);
}

void draw() {
  calculateMovement();
  background(190, 150, 235);
  image(farm, 0, 0);
  
  pushMatrix();
    translate(1005, 115);
    rotate(radians(windmillAngle));
    image(windmill, -79, -65);
  popMatrix();

  // **** NO MODIFICAR TRASLACIONES DESPUÉS DE ESTE PUNTO *** (diseño del personaje)
  pushMatrix();
  // posición inicial del personaje
  translate(posX, posY);

  // dibujar una pierna 80 para abajo y 25 para la izquierda con respecto a la posición central
  translate(-25, 80);
  if (emotion == 1)
    translate(0, (happyMovement*1.15));
  rotate(radians(lfFootAngle));
  drawLeg();
  rotate(radians(-lfFootAngle));
  // dibujar pierna derecha 50 px a la derecha de la otra
  translate(50, 0);
  rotate(radians(-rgFootAngle));
  drawLeg();
  rotate(radians(rgFootAngle));
  translate(-25, 0);
  translate(0, -(happyMovement*0.15));
  
  // if arm angle is bigger than or equal to 30, draw arm under body. 
  if (rgArmAngle >= 30) {
    pushMatrix();
    // dibujar brazo derecho 15 px a la derecha de la pierna y 70 para arriba y con rotación del angulo predeterminado
    translate(40, -75+sadMovement+armSeparation);
    rotate(radians(-rgArmAngle));
    drawArm();
    rotate(radians(rgArmAngle));
    popMatrix();
  }
  if (lfArmAngle >= 30) {
    pushMatrix();
    // dibujar brazo izquierdo 80 px a la izq del otro brazo y lo rota al ángulo predeterminado
    translate(-40, -75+sadMovement+armSeparation);
    rotate(radians(lfArmAngle));
    drawArm();
    rotate(radians(-lfArmAngle));
    popMatrix();
  }

  drawBody();
  
  // if arm angle is smaller than 30, draw arm over body
  if (rgArmAngle < 30) {
    pushMatrix();
    // dibujar brazo derecho 15 px a la derecha de la pierna y 70 para arriba y con rotación del angulo predeterminado
    translate(40, -75+sadMovement+armSeparation);
    rotate(radians(-rgArmAngle));
    drawArm();
    rotate(radians(rgArmAngle));
    popMatrix();
  }
  if (lfArmAngle < 30) {
    pushMatrix();
    // dibujar brazo izquierdo 80 px a la izq del otro brazo y lo rota al ángulo predeterminado
    translate(-40, -75+sadMovement+armSeparation);
    rotate(radians(lfArmAngle));
    drawArm();
    rotate(radians(-lfArmAngle));
    popMatrix();
  }
  
  translate(0, -92 + (sadMovement/2));
  rotate(radians(headAngle));
  drawHatBehind();
  drawHead();
  drawHat();
  rotate(radians(-headAngle));
  popMatrix();
}

void keyPressed() {
    if (key == '1') {
      emotion = 1;
    } else if (key == '2') {
      emotion = 2;
    } else if (key == '3') {
      emotion = 3;
    } else {
      emotion = 0;
    }
    startEmotion = true;
}

void calculateMovement() {
  if (windmillAngle >=360)
    windmillAngle = 0;
  else
    windmillAngle += 1;
  
  if (emotion == 0) {
  // neutral emotion
    startEmotion = false;
    if (headAngle > 0)
      headAngle -= 1;
    if (headAngle < 0)
      headAngle += 1;
    
    if (rgArmAngle > 31)
      rgArmAngle -= 2;
    if (rgArmAngle < 30)
      rgArmAngle += 2;
    
    if (lfArmAngle > 31)
      lfArmAngle -= 2;
    if (lfArmAngle < 30)
      lfArmAngle += 2;
  
    if (mouthState > 0)
      mouthState -= 1;
    if (mouthState < 0)
      mouthState += 1;
  } else if (emotion == 1) {
  // variables when happy
    if (startEmotion) {
      startEmotion = false;
    }
    if (headAngle < -10)
      headRight = true;
    if (headAngle > 10)
      headRight = false;
    
    if (headRight)
      headAngle += 1;
    else
      headAngle -= 1;
    
    if (rgArmAngle < 95) {
      armsDown = false;
    } if (rgArmAngle > 110)
      armsDown = true;
    
    if (armsDown) {
      rgArmAngle -= 1;
      lfArmAngle -= 1;
    } else {
      rgArmAngle += 1;
      lfArmAngle += 1;
    }
    
    if (mouthState < 18)
      mouthState += 1;
      
    if (happyMovementDir)
      happyMovement += 1;
    else
      happyMovement -= 1;
      
    if (happyMovement < -8)
      happyMovementDir = true;
    if (happyMovement > 7)
      happyMovementDir = false;
  } else if(emotion == 2) {
  // variables when sad
    if (mouthState > -18)
      mouthState -= 1;
    
    if (sadMovement < 10)
      sadMovement += 1;
    
    if (headAngle < 10)
      headAngle += 1;
    if (headAngle > 10)
      headAngle -= 1;
      
    if (rgArmAngle > 0)
      rgArmAngle -= 2;
    if (rgArmAngle < 0)
      rgArmAngle += 2;
    if (lfArmAngle > 0)
      lfArmAngle -= 2;
    if (lfArmAngle < 0)
      lfArmAngle += 2;
  } else if (emotion == 3) {
  // variables when mad
    if (mouthState > -4)
      mouthState -= 1;
    else if (mouthState < -4)
      mouthState += 1;
    
    if (headAngle < -3)
      headAngle += 1;
    if (headAngle > -3)
      headAngle -= 1;
      
    if (armSeparation != 12)
      armSeparation += 1;
      
    if (rgArmAngle > -100)
      rgArmAngle -= 2;
    if (rgArmAngle < -99)
      rgArmAngle += 2;
      
    if (lfArmAngle > -100)
      lfArmAngle -= 2;
    if (lfArmAngle < -99)
      lfArmAngle += 2;
  }
  
  if (emotion != 1) {
  // when not happy
    if (happyMovement > -8)
      happyMovement -= 1;
  }
  if (emotion != 2) {
  // when not sad
    if (sadMovement > 0)
      sadMovement -= 1;
  }
  
  if (emotion != 3) {
    if (armSeparation > 0)
      armSeparation -= 1;
  }
}

void drawLeg() {
  strokeWeight(1.5);
  // shoe idea 1
  //fill(shoes);
  //arc(0, 53, 46, 25, 0, PI);
  //fill(shoes + color(80,80,80));
  //arc(0, 53, 15, 18, 0, PI);
  
  // leg
  fill(skin);
  //rect(-23, 20, 46, 34);
  rect(-23, 20, 46, 34, 0, 0, 120, 120);
  
  // shoe idea 2
  //fill(shoes);
  //rect(-23, 45, 46, 9, 0, 0, 120, 120);

  // shorts
  fill(shorts);
  rect(-24.5, -20, 49, 50, 50, 50, 0, 0);
}

void drawArm() {
  //arm
  fill(skin);
  rect(-15, -12, 30, 90, 40, 40, 40, 40);
  // sleeves
  fill(jacket);
  rect(-15, -12, 30, 70, 40, 40, 0, 0);
}

void drawBody() {
  // jacket
  strokeWeight(1.5);
  fill(jacket);
  rect(-50, 0, 100, -90, 5, 5, 0, 0);

  // under shirt and tie
  noStroke();
  //fill(235, 215, 130);
  fill(skin);
  triangle(-15, -88, 15, -88, 0, -70);
  // white shirt
  stroke(0);
  strokeWeight(1);
  fill(shirt);
  beginShape();
  vertex(-15, -88);
  vertex(0, -30);
  vertex(15, -88);
  vertex(0, -70);
  endShape();
  beginShape();
  vertex(-15, -88);
  vertex(-6, -65);
  vertex(0, -70);
  vertex(6, -65);
  vertex(15, -88);
  vertex(0, -70);
  vertex(-15, -88);
  endShape();
  line(0, -30, 0, -70);
  
  // tie
  fill(tie);
  beginShape();
  vertex(0, -70);
  vertex(-3, -67);
  vertex(0, -64);
  vertex(-4, -45);
  vertex(0, -30);
  vertex(4, -45);
  vertex(0, -64);
  vertex(3, -67);
  endShape();

  // shirt details
  strokeWeight(1.5);
  noFill();

  beginShape();
  vertex(15, -88);
  vertex(0, -30);
  vertex(-5, 0);
  endShape();
  line(-15, -88, 0, -30);

  // buttons
  ellipse(1, -5, 1, 1);
  ellipse(2, -12, 1, 1);
  ellipse(3, -19, 1, 1);

  // pocket
  fill(0, 8);
  strokeWeight(1);
  stroke(105, 83, 55);
  rect(-36, -70, 16, 5, 2, 2, 0, 0);
  beginShape();
  vertex(-36, -65);
  vertex(-36, -54);
  vertex(-28, -50);
  vertex(-20, -54);
  vertex(-20, -65);
  endShape();
  stroke(0);

  // neck
  noStroke();
  fill(skin);
  rect(-13, -108, 26, 20);
  stroke(0);
  strokeWeight(1.5);
  line(-13, -108, -13, -90);
  line(13, -108, 13, -90);
}

void drawHead() {
  // head shape
  strokeWeight(1.5);
  fill(skin);
  rect(-100, -100, 200, 100, 10, 10, 50, 50);

  // eyes
  strokeWeight(1);
  fill(0);
  if (emotion == 2 || emotion == 3) {
    // sad or mad eyes (the rotation determines the difference)
    // right eye
    pushMatrix();
      translate(-45, -55);
      if (emotion == 2) // if sad
        rotate(radians(-45));
      arc(0, 0, 15, 15, 0, radians(220), CHORD);
    popMatrix();
    pushMatrix();
      translate(+45, -55);
      if (emotion == 2) // if sad
        rotate(radians(45));
      scale(-1, 1);
      arc(0, 0, 15, 15, 0, radians(220), CHORD);
    popMatrix();
  } else {
    // normal eyes
    ellipse(-45, -55, 15, 15);
    ellipse(+45, -55, 15, 15);
  }

  // mouth
  noFill();
  strokeWeight(3);
  if (mouthState >= 0)
    arc(0, -35, 15, mouthState, 0, PI);
  else 
    arc(0, -35, 15, -mouthState, PI, 2*PI);
}

void drawHat() {
  // shaping and filling in the top part of the hat
  strokeWeight(1);
  fill(upperHat);
  beginShape();
    vertex(-90, -100);
    bezierVertex(-50, -140, -55, -170, -25, -175);
    bezierVertex(-15, -175, -10, -165, 0, -165);
    bezierVertex(+10, -165, +15, -175, +25, -175);
    bezierVertex(+55, -170, +50, -140, +90, -90);
  endShape();

  // filling the front of the hat
  noStroke();
  fill(lowerHat);
  beginShape();
    vertex(-140, -78);
    bezierVertex(-120, -140, -50, -105, 0, -105);
    bezierVertex(+50, -105, +120, -140, +140, -78);
    vertex(+100, -75);
    bezierVertex(+90, -100, -90, -100, -100, -75);
  endShape();
  stroke(0);
  
  // stroke on front of head
  strokeWeight(1);
  noFill();
  beginShape();
    vertex(+100, -75);
    bezierVertex(+90, -100, -90, -100, -100, -75);
  endShape();

  // stroke on the front of hat
  beginShape();
    vertex(-140, -78);
    bezierVertex(-120, -140, -50, -105, 0, -105);
    bezierVertex(+50, -105, +120, -140, +140, -78);
  endShape();
}

void drawHatBehind() {
  strokeWeight(1);
  fill(lowerHat);
  ellipse(0, -75, 280, 80);
}
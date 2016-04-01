int rgFootAngle = 0, lfFootAngle = 0, rgArmAngle = 0, lfArmAngle = 0, headAngle = 0, mouthState = 0;
int sadMovement = 0, happyMovement = 0, armSeparation = 0;
int emotion;
boolean headRight = true, armsDown = true, startEmotion = false, happyMovementDir = false;
int posX = 1080/4, posY = 720/2;

void setup() {
  size(1080, 720);
  background(255);
  
  emotion = 0;
}

void draw() {
  calculateMovement();
  background(190, 150, 235);
  
  // **** NO MODIFICAR TRASLACIONES DESPUÉS DE ESTE PUNTO ***
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
  if (emotion == 0) {
  // neutral emotion
    startEmotion = false;
    headAngle = 0;
    rgArmAngle = 30;
    lfArmAngle = 30;
    rgFootAngle = 0;
    lfFootAngle = 0;
    mouthState = 0;
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
    if (mouthState > -18) {
      mouthState -= 1;
    }
    
    if (sadMovement < 10)
      sadMovement += 1;
    
    if (headAngle < 10)
      headAngle += 1;
    if (headAngle > 10)
      headAngle -= 1;
      
    if (rgArmAngle > 0)
      rgArmAngle -= 2;
    if (lfArmAngle > 0)
      lfArmAngle -= 2;

  } else if (emotion == 3) {
  // variables when mad
    if (mouthState > 0) {
      mouthState -= 1;
    } else if (mouthState < 0) {
      mouthState += 1;
    }
    
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
  // leg
  fill(235, 215, 130);
  rect(-23, 20, 46, 45, 0, 0, 40, 40);

  // shorts
  fill(115, 70, 10);
  rect(-24.5, -20, 49, 50, 50, 50, 0, 0);
}

void drawArm() {
  fill(235, 215, 130);
  rect(-15, -12, 30, 90, 40, 40, 40, 40);
  fill(237, 218, 190);
  rect(-15, -12, 30, 70, 40, 40, 0, 0);
}

void drawBody() {
  // shirt
  strokeWeight(1.5);
  fill(237, 218, 190);
  rect(-50, 0, 100, -90, 5, 5, 0, 0);

  // under shirt and tie
  noStroke();
  fill(235, 215, 130);
  triangle(-15, -88, 15, -88, 0, -70);
  // white shirt
  stroke(0);
  strokeWeight(1);
  fill(255);
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
  
  // tie
  fill(0);
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
  fill(235, 215, 130);
  rect(-13, -108, 26, 20);
  stroke(0);
  strokeWeight(1.5);
  line(-13, -108, -13, -90);
  line(13, -108, 13, -90);
}

void drawHead() {
  // head shape
  strokeWeight(1.5);
  fill(235, 215, 130);
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
  fill(70, 42, 5);
  beginShape();
  vertex(-90, -100);
  bezierVertex(-50, -140, -55, -170, -25, -175);
  bezierVertex(-15, -175, -10, -165, 0, -165);
  bezierVertex(+10, -165, +15, -175, +25, -175);
  bezierVertex(+55, -170, +50, -140, +90, -90);
  endShape();

  // filling the front of the hat
  noStroke();
  fill(80, 50, 10);
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
  fill(80, 50, 10);
  ellipse(0, -75, 280, 80);
}


void nameTag() {
  
}
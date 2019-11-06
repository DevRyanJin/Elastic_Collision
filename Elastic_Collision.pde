/*
 Comp3490 Assignment 3 Question 1
 
 Name: Sijin Lee 
 ID: 7822352 
 Email: lees3436@myumanitoba.ca 
*/


//update motion every 0.1 sec. 

ArrayList<PVector> particles = new ArrayList<PVector>(); 
ArrayList<PVector> velocities = new ArrayList<PVector>(); 
ArrayList<Integer> cirSize = new ArrayList<Integer>(); 

int numOfCircles =10;  // how many particles?  

color[] cirColor = new color[numOfCircles]; // give different color 

float posX;
float posY;
float radius = 30; 

PVector selectVelStart;
PVector selectVelEnd;
boolean hit = false;
int selectedP =-1; 

final float perTime = 0.1; //interval 

//calculate real time
boolean t0 = true; 
int prevTime; 
float currTime =0 ;

void setup(){
 size(640,640,P3D); 
 
 ArrayList<PVector> iniPosSet = new ArrayList<PVector>();
 
 //initial position for the particles without overlapping 
  int i=0; 
  while(i<numOfCircles){
   boolean isConflict = false; 
   posX = random(radius, width-radius); 
   posY = random(radius, height-radius);
   iniPosSet.add(new PVector(posX, posY));
      
     for(int j=0; j<iniPosSet.size()-1 ; j++){
         if(dist(iniPosSet.get(j).x, iniPosSet.get(j).y, 
                 iniPosSet.get(iniPosSet.size()-1).x, iniPosSet.get(iniPosSet.size()-1).y) < radius*2){
           
             iniPosSet.remove(iniPosSet.size()-1);
             isConflict = true; 
             break; 
          }      
      }//for  
      
  
   if(!isConflict){
     i++; 
     particles.add(new PVector(posX,posY));  
     velocities.add(new PVector(random(-30,30),random(-30,30)));
     cirColor[i-1] = color(random(255),random(255),random(255));
     cirSize.add((int)random(30,40));
   }
  
 }//while 
 

}//setup
void draw(){

  if(t0){
     prevTime = millis();

  }//if
  
  background(0);
  //draw, move, and check all the possible collision for each particle 
  for(int i=0; i<particles.size(); i++){
    pushMatrix();
    translate(particles.get(i).x, particles.get(i).y);
    drawParticles(i);
    moveParticles(i,t0);
    bounceOffWall(i,t0);
    collision(i,t0);
    popMatrix();
    bounceOffNet(i,t0);
  }
  
  currTime = (millis()-prevTime)/1000.0;
  
  //update every 0.1 sec 
  if(currTime>perTime){
     t0 = true;
     currTime= 0;
    
  } else{
     t0= false; 
  }


 }//draw
 
 void drawParticles(int i){
  float x = 0; 
  float y = 0; 
  float inc = 0.05;
   
  noStroke();
  fill(cirColor[i]);
  beginShape(TRIANGLE_FAN);
  for (float t = 0.0f; t <= 1; t += inc) {
    x = (float)(cirSize.get(i) * Math.cos(t * 2 * PI));
    y = (float)(cirSize.get(i) * Math.sin(t * 2 * PI));
    vertex(x, y);
  }
  endShape();
}//drawParticles

void moveParticles(int i,boolean isSec){
  
  if(isSec){
    particles.get(i).add(velocities.get(i));
  }
}//moveParticles
  
  
void bounceOffWall(int i,boolean isSec){      
  if(isSec){
    
  if (particles.get(i).y>=height-cirSize.get(i) || particles.get(i).y <= cirSize.get(i))      
      velocities.get(i).y = -velocities.get(i).y;
  
   if (particles.get(i).x>=width-cirSize.get(i) ||particles.get(i).x<=cirSize.get(i))
        velocities.get(i).x = -velocities.get(i).x;

  
  if(particles.get(i).y>=height-cirSize.get(i))
       particles.get(i).y -= cirSize.get(i); 
  if(particles.get(i).y <= cirSize.get(i))
       particles.get(i).y += cirSize.get(i);     
   if(particles.get(i).x>=width-cirSize.get(i))
       particles.get(i).x -= cirSize.get(i);    
  if(particles.get(i).x<=cirSize.get(i))
       particles.get(i).x += cirSize.get(i);
       
  }   

}//bounceOffWall


void bounceOffNet(int i, boolean isSec){
 
  fill(255);
  beginShape(QUADS);
  vertex(width/2-20, height/2);
  vertex(width/2-20, height );
  vertex(width/2+20, height );
  vertex(width/2+20,  height/2);
  endShape();
  
  for(int k=0; k<20; k++){
  beginShape(LINE_STRIP);
  stroke(0);
  vertex(width/2-20,height/2 +(k*20));
  vertex(width/2+20,height/2 +(k*20));
  endShape();
  }
  
  int netWidth = 40; 
  int netHeight = height/2; 
  float NetX = width/2-20; 
  float NetY =  height/2; 


  boolean isCollide = false;

  float tempX = particles.get(i).x;
  float tempY = particles.get(i).y;
  

if(isSec){

   if (particles.get(i).x < NetX)
       tempX = NetX; 
   else if(particles.get(i).x > NetX+netWidth)
       tempX = NetX+netWidth;
  
   if(particles.get(i).y < NetY)
       tempY= NetY;
   else if(particles.get(i).y >NetY + netHeight)
       tempY= NetY+netHeight;

    float distX =  particles.get(i).x-tempX;
    float distY =  particles.get(i).y-tempY;
    float distance = sqrt(sq(distX)+sq(distY));
    
    if(distance <= cirSize.get(i)){
        isCollide= true; 
    }
    
    if(isCollide){
       if (particles.get(i).x < NetX){
           particles.get(i).x -= cirSize.get(i)-velocities.get(i).x;
           velocities.get(i).x = -velocities.get(i).x;
       }
      
       if (particles.get(i).x > NetX+netWidth){
           particles.get(i).x += cirSize.get(i)+velocities.get(i).x;
           velocities.get(i).x =-velocities.get(i).x;
       }
      
       if (particles.get(i).y < NetY){
           particles.get(i).y -= cirSize.get(i)-velocities.get(i).y;
           velocities.get(i).y = -velocities.get(i).y;
       }
      
       if (particles.get(i).y > NetY+netHeight){
           particles.get(i).y += cirSize.get(i)+velocities.get(i).y;
           velocities.get(i).y =-velocities.get(i).y;
       }
      
          
    }
 }  

}//bounceOffNet 
  

void collision(int i,boolean isSec){

  if(isSec){
  for(int j=0; j<particles.size(); j++){
    if (i != j && dist(particles.get(i).x,particles.get(i).y,particles.get(j).x,particles.get(j).y) <= cirSize.get(i)+cirSize.get(j)){        
        updateParticles(i, j); 
     }//if
   }//for
  }//if
  
}//collision

void updateParticles(int object1, int object2){

  PVector currOb1 = particles.get(object1);  
  PVector currOb2 = particles.get(object2); 
  
  PVector lastOb1 = PVector.sub(particles.get(object1),velocities.get(object1)); 
  PVector lastOb2 = PVector.sub(particles.get(object2),velocities.get(object2)); 

  PVector velocityOb1 = PVector.sub(currOb1,lastOb1);
  PVector velocityOb2 = PVector.sub(currOb2,lastOb2);
  
  float xDist = currOb2.x - currOb1.x; 
  float yDist = currOb2.y - currOb1.y; 
  float disT = sq(xDist)+sq(yDist);
  float xVelocity = velocityOb2.x - velocityOb1.x; 
  float yVelocity = velocityOb2.y - velocityOb1.y;
  float dot =xDist * xVelocity + yDist * yVelocity; 
 
  float colliScale = dot/disT;
  float xColli = xDist *colliScale ;
  float yColli = yDist *colliScale ;
  
  float MassAB = cirSize.get(object1) + cirSize.get(object2);
  float collisionA = 2 * cirSize.get(object2) / MassAB;
  float collisionB = 2 * cirSize.get(object1) / MassAB;
  
  if(dot<=0) {
    velocities.get(object1).x += collisionA * xColli;   
    velocities.get(object1).y += collisionA * yColli;   
 
    velocities.get(object2).x -= collisionB * xColli;   
    velocities.get(object2).y -= collisionB * yColli;   
    }
}//updateParticles




 

  
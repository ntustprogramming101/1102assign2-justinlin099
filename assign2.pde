PImage backImg,titleImg,gameOverImg,startBtn,startBtnH,resetBtn,resetBtnH,soilImg,heartImg,hogImg,hogDImg,hogRImg,hogLImg,soldierImg,cabImg; //Declare img type
float soldierX,soldierY,hogX,hogY,cabX,cabY;
final int HOG_IDLE=0,HOG_DOWN=1,HOG_LEFT=2,HOG_RIGHT=3;//Hog status finals
final int GAME_START=0,GAME_RUN=1,GAME_OVER=2;
final int BTN_WIDTH=144,BTN_HEIGHT=60;
final int BLOCK=80;
boolean cabStat;
int lifeCount,timer,gameStat,hogStat;

void setup() {
	size(640, 480, P2D);

  //Load Images
  backImg = loadImage("img/bg.jpg");//Background
  titleImg = loadImage("img/title.jpg");//titleimg
  gameOverImg = loadImage("img/gameover.jpg");//Gameover
  startBtn = loadImage("img/startNormal.png");//startBtn
  startBtnH = loadImage("img/startHovered.png");//hovered
  resetBtn = loadImage("img/restartNormal.png");//resetBtn
  resetBtnH = loadImage("img/restartHovered.png");//hovered
  soilImg = loadImage("img/soil.png");//soil
  heartImg = loadImage("img/life.png");//heart
  hogImg = loadImage("img/groundhogIdle.png");//hog
  hogDImg = loadImage("img/groundhogDown.png");//hog
  hogLImg = loadImage("img/groundhogLeft.png");//hog
  hogRImg = loadImage("img/groundhogRight.png");//hog
  soldierImg = loadImage("img/soldier.png");//soldier
  cabImg = loadImage("img/cabbage.png");//cabbage
  
  gameStat=GAME_START;//set game stat
  
}

void draw() {
	// Switch Game State
  switch(gameStat){
    case GAME_START:// Game Start
      image(titleImg,0,0);//draw titlebg
      
      if(mouseX>248&&mouseX<248+BTN_WIDTH&&mouseY>360&&mouseY<360+BTN_HEIGHT){//if hovered
        image(startBtnH,248,360);
      }else{
        image(startBtn,248,360);
      }
      
      break;
		case GAME_RUN:// Game Run
        //Draw Background
        image(backImg,0,0);
        
        //Draw Soil
        image(soilImg,0,160);
        
        //Draw Grass
        noStroke();
        fill(124,204,25);//green
        rect(0,160,640,-15);//grass
        
        //Draw Heart
        for(int i=0;i<lifeCount;i++)
        {
          image(heartImg,10+i*70,10);
        }
        
        //Draw Sun
        stroke(255,255,0);//set Stroke color
        strokeWeight(5);//set Stroke Weight to 5
        fill(253,184,19);//set Sun color
        ellipse(590,50,120,120);//Draw Sun
        
        //check timer
        if(timer==15){
          hogStat=HOG_IDLE;
          if(hogY%BLOCK<30){
            hogY=hogY-hogY%BLOCK;
          }else{
            hogY=hogY-hogY%BLOCK+BLOCK;
          }
          if(hogX%BLOCK<30){
            hogX=hogX-hogX%BLOCK;
          }else{
            hogX=hogX-hogX%BLOCK+BLOCK;
          }
          println(hogX);
          println(hogY);
          timer=0;
        }
        
        //Draw hog
        switch(hogStat){
          case HOG_IDLE:
            image(hogImg,hogX,hogY);
            break;
          case HOG_DOWN:
            image(hogDImg,hogX,hogY);
            timer+=1;
            hogY+=80.0/15;
            break;
          case HOG_RIGHT:
            image(hogRImg,hogX,hogY);
            timer+=1;
            hogX+=80.0/15;
            break;
          case HOG_LEFT:
            image(hogLImg,hogX,hogY);
            timer+=1;
            hogX-=80.0/15;
            break;
        }
        

        //Draw Soldier
        image(soldierImg,soldierX-80,soldierY);//Draw Soldier
        soldierX+=3;//Move Soldier
        soldierX%=720;
        
        //Draw Cab
        if(cabStat){
          image(cabImg,cabX,cabY);
        
          //Cab collision detect
          if(hogX==cabX&&hogY==cabY){
            cabStat=false;
            lifeCount++;
          }
        }
        
        //soldier collision detect
        if(hogX<soldierX-80+BLOCK&&hogX+BLOCK>soldierX-80&&hogY<soldierY+BLOCK&&hogY+BLOCK>soldierY){
          lifeCount--;
          hogStat=HOG_IDLE;
          
          //Set hog pos
          hogX=4*BLOCK;
          hogY=BLOCK;
        }
        
        
        //if game over
        if(lifeCount==0){
          gameStat=GAME_OVER;
        }
        
        break;
		case GAME_OVER:// Game Lose
      image(gameOverImg,0,0);//draw OVERbg
      
      if(mouseX>248&&mouseX<248+BTN_WIDTH&&mouseY>360&&mouseY<360+BTN_HEIGHT){//if hovered
        image(resetBtnH,248,360);
      }else{
        image(resetBtn,248,360);
      }
      break;
  }
}

void keyPressed(){
  if(key ==CODED){
    switch(keyCode){
      case DOWN:
        if(hogY+BLOCK<height&&hogStat==HOG_IDLE){
          hogStat=HOG_DOWN;
          timer=0;
        }
        break;
      case RIGHT:
        if(hogX+BLOCK<width&&hogStat==HOG_IDLE){
          hogStat=HOG_RIGHT;
          timer=0;
        }
        break;
      case LEFT:
        if(hogX>0&&hogStat==HOG_IDLE){
          hogStat=HOG_LEFT;
          timer=0;
        }
        break;
    }
  }
      
}

void keyReleased(){
}

void mouseClicked(){
  if(mouseX>248&&mouseX<248+BTN_WIDTH&&mouseY>360&&mouseY<360+BTN_HEIGHT&&(gameStat==GAME_START||gameStat==GAME_OVER)){//if hovered
    //get soldier coordinate
    soldierX=0;
    soldierY=BLOCK*(int(random(4)+2));
    
    //get Cabbage coordinate
    cabX=BLOCK*int(random(8));
    cabY=BLOCK*(int(random(4))+2);
    
    //Set Cabbage Stat
    cabStat=true;
    
    //set Life count
    lifeCount=2;
    
    //Set hog pos
    hogX=4*BLOCK;
    hogY=BLOCK;
    
    //Set hog stat
    hogStat=HOG_IDLE;
    
    //START GAME
    gameStat=GAME_RUN;
  }
}

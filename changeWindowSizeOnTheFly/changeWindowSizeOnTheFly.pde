/*******************************************
This sketch is to demonstrate how to change frame size on the fly

 Author: Shen, Sheng-Po (http://shengpo.github.com)
 Date:   2013.01.31
 License: CC BY-SA 3.0
*******************************************/

int curW = 400;            //current width
int curH = 300;            //current height
int finalW = 500;          //final width
int finalH = 200;           //final height
int increaseW = 0;        //increasement on width
int increaseH = 0;        //increasement on height

boolean isStartResize = false;    //check if start to do resize


void setup(){
    size(curW, curH);                //original size
    frame.setResizable(true);    //make frame is resizable
}

void draw(){
    background(0);
    
    if(isStartResize && abs(curW-finalW)>0 && abs(curH-finalH)>0){
        curW = curW + increaseW;
        curH = curH + increaseH;
        frame.setSize(curW, curH);
    }

    println("width:" +width);
    println("height: "+height);
}

void mousePressed(){
    if(!isStartResize){
        isStartResize = true;

         //set increase value    
        if(curW < finalW){
            increaseW = 1;
        }else if(curW > finalW){
            increaseW = -1;
        }else{
            increaseW = 0;
        }
        
        if(curH < finalH){
            increaseH = 1;
        }else if(curH > finalH){
            increaseH = -1;
        }else{
            increaseH = 0;
        }
   }
}

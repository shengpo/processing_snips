/*
此程式用來測試讀取三軸加速器的數值，並做一個簡易的轉換

touchOSC在手機上的設定：
 - 開啟 Stay connected 
 - 開啟 Accelerometer
 - 開啟 Send Z messages
 
 touchOSC 的 message如下：
 
 - 三軸加速器
 ### addrpattern    /accxyz
 ### typetag    fff

 Author: Shen, Sheng-Po (http://shengpo.github.io)
 Test Environment: Processing 2.0.1
 Date:   2013.07.11
 License: CC BY-SA 3.0
*/


import oscP5.*;
import netP5.*;

OscP5 oscP5;


//for Accelerometer values
float degreeX = 0;    //沿著x軸旋轉的角度
float degreeZ = 0;    //沿著z軸旋轉的角度
float tdegreeX = 0;   
float tdegreeZ = 0;
float transX = 0;    //沿著x軸移動的距離
float ttransX = 0;

float curX = 0;
float curY = 0;
float curZ = 0;
float preX = 0;
float preY = 0;
float preZ = 0;
boolean isGetFirst = false;


void setup() {
    size(400, 400, P3D);

    oscP5 = new OscP5(this, 12000);

    oscP5.plug(this, "accxyz", "/accxyz");
    
    ttransX = width/2;
}


void draw() {
    background(38, 41, 44);

    //update rotate degree on x-axis and z-axis
    degreeX = degreeX + (tdegreeX-degreeX)/30;
    degreeZ = degreeZ + (tdegreeZ-degreeZ)/30;

    //update shift location on x-axis
    transX = transX + (ttransX-transX)/30;
    
    pushMatrix();
    translate(transX, height/2);
    rotateX(radians(degreeX));
    rotateZ(radians(degreeZ));
    drawSimplePhone();
    popMatrix();
}

void drawSimplePhone(){
    strokeWeight(1);
    stroke(0);
    fill(255);
    box(65, 10, 140);

    strokeWeight(3);
    stroke(255, 0, 0);
    line(0, -10, -30, 0, -10, -80);
    line(0, -10, -80, -10, -10, -60);
    line(0, -10, -80, 10, -10, -60);
}


public void accxyz(float x, float y, float z) {
//    println("三軸加速器原數值 (x, y, z) = (" + x + ", " + y + ", " + z + ")" );    //x, y, z數值從-10~10

    if(!isGetFirst){
        curX = x;
        curY = y;
        curZ = z;
        isGetFirst = true;
    }else{
        preX = curX;
        preY = curY;
        preZ = curZ;
        curX = x;
        curY = y;
        curZ = z;
    }

    if(dist(curX, curY, curZ, preX, preY, preZ) < 1){
        return;    //前後數值差距不夠大則return, 差距夠大則進行下列算
    }

    //把速度轉換成角度
    tdegreeX = constrain(y*-9, -90, 90);    //抓直立傾斜的角度, 範圍為-90 ~ 90

    transX = ttransX + x*-9;   //抓瞬間速度 
    
    if(abs(tdegreeX) < 80){    //僅在手機非直立時作用
        tdegreeZ = constrain(z*9 - 90, -180, 0);    //抓覆蓋手機的角度, 範圍為-180 ~ 0
    }else{
        tdegreeZ = z*9;
    }
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {

    //check unknow OSC message from touchOSC app    
    if (theOscMessage.isPlugged()==false) {
        /* print the address pattern and the typetag of the received OscMessage */
        println("### received an osc message.");
        println("### addrpattern\t"+theOscMessage.addrPattern());
        println("### typetag\t"+theOscMessage.typetag());
    }
}


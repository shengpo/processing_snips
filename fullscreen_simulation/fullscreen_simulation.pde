/*
 這個程式示範如何去除視窗的外在裝飾邊框，以達到程式模擬全螢幕的效果
  - 這個方式跟使用fullscreen api (http://www.superduper.org/processing/fullscreen_api/) 不同
  - 這個方式是將視窗外圍的裝飾(decoration，例如：放大、縮小、關閉、工具列…)去除
  - 將裝飾去除後，同時將程式視窗大小設成跟螢幕同大小，以達到模擬全螢幕的效果
  - 這個方式同時也可以指定視窗呈現的位置 (例如：指定程式開啟時，直接在延伸螢幕呈現)
  - size()的render必須是OpenGL-based, 也就是P2D或P3D  (Java2D不行!)

 Author: Shen, Sheng-Po (http://shengpo.github.io)
 Test Environment: Processing 2.0.2
 Date:   2013.08.16
 License: CC BY-SA 3.0
*/


//set frame undecorated to emulate full screen
void init(){
  frame.dispose();  //must call!
  frame.setUndecorated(true);  //set true to remove decoration!
  super.init();    //must call!
}


void setup(){
    size(400, 300, P3D);    //render must be OpenGL-based
//    size(400, 300, P2D);    //render must be OpenGL-based
//    size(400, 300);    //not work!! because this render is Java2D
    frameRate(5);

    frame.setLocation(100, 300);    //set location on the screen of application
}

void draw(){
    background(random(256), random(256), random(256));
}

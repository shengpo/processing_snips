/*
 EZCam 操作：
    . SHIFT + 滑鼠上下 : zoom in/out
    . CONTROL + 滑鼠 : rotate
    . ALT + 滑鼠 : pan
    . dot (.) : reset zoom/rotate/pan

*/

EZCam ezCam = null;
boolean isZoom = false;
boolean isRotate = false;
boolean isPan = false;



void setup(){
    size(400, 400, P3D);

    ezCam = new EZCam();
    ezCam.resetZoom();
    ezCam.resetRotate();
    ezCam.resetPan();
}

void draw(){
    background(0);
    
    ezCam.beginCam();
    
    pushMatrix();
    translate(width/2, height/2);
    stroke(255, 0, 0);
    fill(255);
    box(100);
    popMatrix();
    
    ezCam.endCam();
}


void keyPressed() {
    //for EZCam
    if(key == CODED){
        if(keyCode == SHIFT){
            isZoom = true;
            isRotate = false;
            isPan = false;
            println("EZCam zoom mode ...");
        }
        if(keyCode == CONTROL){
            isZoom = false;
            isRotate = true;
            isPan = false;
            println("EZCam rotate mode ...");
        }
        if(keyCode == ALT){
            isZoom = false;
            isRotate = false;
            isPan = true;
            println("EZCam pan mode ...");
        }
    }
    
    if(key == '.'){
        ezCam.resetZoom();
        ezCam.resetRotate();
        ezCam.resetPan();
        isZoom = false;
        isRotate = false;
        isPan = false;
    }
}



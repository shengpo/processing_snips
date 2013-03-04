 /*******************************************
Gaol:
sometimes the system's screensaver can not be stopped by using setting panel.
sometimes you can not disable screensaver even though you had disabled it on system setting panel.
ususally this situation is happened in Ubuntu.

if you want to keep screensaver disabled to let your art work run without screensaver's disturbance,
you can try this snippet.


 Author: Shen, Sheng-Po (http://shengpo.github.com)
 Test Environment: Processing 2.0b8
 Date:   2013.03.04
 License: CC BY-SA 3.0
 *******************************************/


import java.awt.*;

Robot robot = null;

void setup() {
        size(200, 200);
        background(0);
        frameRate(10);

        try {
                robot = new Robot();
        }
        catch(AWTException e) {
                e.printStackTrace();
        }
}

void draw() {
        if (frameCount%1800 == 0) {        //every 3 minutes
                robot.mouseMove((int)random(50, 150), (int)random(50, 150));
                println("mouse move!");
        }
}


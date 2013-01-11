/*
Intro:
---------
This is a very simple example for demostrating how to use java.awt.TextField in Processing sketch

Because of using other GUI libraries for Processing, you can not input any CJK characters in their textfield.
But in java.awt.TextField, you can input CJK characters without problem.

so sometimes, you may need this.

ps. this example does not show that how to layout TexField controller


references:
--------------------
- http://docs.oracle.com/javase/7/docs/api/
- http://processing.org/discourse/alpha/board_Programs_action_display_num_1083715240_start_6.html


Info:
------
Developed and tested on Processing IDE     : Processing 2.0b7
Author                                                      : Shen, Sheng-Po (shengpo.githug.com)
Date of first version                                   : 2013.01.10
License                                                    : CC BY-SA 3.0
*/

import java.awt.*;

TextField  textfield1 = null;
TextField  textfield2 = null;
TextField  textfield3 = null;
TextField  textfield4 = null;


void setup(){
    size(400, 400);

    textfield1 = new TextField("HELLO");    //default text is defined ; the size of textfield (columns) is not defined
    textfield2 = new TextField("你好 もしもし 안녕하세요.", 30); //default text is defined ; the size of textfield (columns) is defined
    textfield3 = new TextField();    //default text is not defined ; the size of textfield (columns) is not defined
    textfield4 = new TextField(50); //default text is defined ; the size of textfield (columns) is defined
    add(textfield1);
    add(textfield2);
    add(textfield3);
    add(textfield4);
}

void draw(){
    background(255);
}

void mousePressed(){
        println("textfield1 : " + textfield1.getText());
        println("textfield2 : " + textfield2.getText());
        println("textfield3 : " + textfield3.getText());
        println("textfield4 : " + textfield4.getText());
}

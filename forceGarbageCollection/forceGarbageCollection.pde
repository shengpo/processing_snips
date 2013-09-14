/*******************************************
 Gaol:
 force JVM system to do garbage collection to improve performance in some situations,
 especially while a program will run all day in an exhibition.
 
 by experience, this is a very useful way on releasing unused RAMs to improve program's performance
 
 
 NOTE:
 GarbageCollector class is also a thread
 it will auto do the GC (Garbage Collection) after use start() method!
 
 
 
 Author: Shen, Sheng-Po (http://shengpo.github.com)
 Test Environment: Processing 2.0b8
 Date:   2013.03.03
 License: CC BY-SA 3.0
 *******************************************/

//for garbage collector
GarbageCollector gc = null;
float gcPeriodMinute = 0.5;    //設定幾分鐘做一次gc


void setup() {
    size(200, 200);
    background(38, 41, 44);

    //for garbage collector
    gc = new GarbageCollector(gcPeriodMinute);
    gc.start();
}

void draw() {
}


//if you want to quit GarbageCollector thread
void keyPressed(){
    if(key == 'q'){
        gc.quit();
    }
}

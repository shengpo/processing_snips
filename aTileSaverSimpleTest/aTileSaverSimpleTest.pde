/*************************************************
 about sketch: aTileSaverSimpleTest.pde
 
 [purpose]
 - Basic demo of the aTileSaver class
 
 [Original version]
 - source : http://workshop.evolutionzone.com/2007/03/24/code-tilesaverpde/
 - version: v0.1 2007.0325
 - author: Marius Watz - http://workshop.evolutionzone.com
 
 [modified]
 - by Shen, Sheng-Po (shengpo.github.com) and Wu, Kuan-Ying (www.mutienliao.tw)
 - tested on Processing 2.0b7 (other version of PDE should work fine.)
 - date: 2013.1.22
 
 - add the function of saving file to the place you want (2013.07.15)
 - tested on Processing 2.0.1 (2013.07.15)
 *************************************************/

aTileSaver tiler;  


void setup() {  
    size(500, 500, P3D);  
    noStroke();  
    tiler=new aTileSaver(this);
    tiler.doSavePreview = false;    //not to save preview image (default will save preview image)
}  

public void draw() {  
    if (tiler==null) return; // Not initialized  

    // call aTileSaver.pre() to prepare frame and setup camera if it exists.  
    tiler.pre();  

    background(0, 50, 0);  
    lights();  

    pushMatrix();
    translate(width/2, height/2);  
    rotateY(PI/4);  
    rotateX(PI/4);  
    scale(8);  
    fill(240, 255, 0, 220);  
    box(10, 50, 10);  
    fill(150, 255, 0, 220);  
    box(50, 10, 10);  
    fill(255, 150, 0, 220);  
    box(10, 10, 50);  
    popMatrix();

    // call aTileSaver.post() to update tiles if tiler is active  
    tiler.post();
}  

// Saves tiled imaged when 't' is pressed  
public void keyPressed() {  
    //make the 1st parameter as empty String to save images to sketch's data directory
    if (key == 't') tiler.init("", "Simple"+nf(frameCount, 5), 5);

    //define your location path
    if (key == 's') {
        tiler.init("/home/shengpo", "Simple"+nf(frameCount, 5), 5);    //save to the place you want
        //tiler.init("/home/shengpo/", "Simple"+nf(frameCount, 5), 5);    //last '/' in the location parameter can be added or not
    }
    
    //use dialog to select the location path
    if(key == 'f'){
        selectFolder("Select a folder to process:", "folderSelected");
        //known problem: tiler.doSavePreview = true; will produce wrong preview image
    }
}  


void folderSelected(File selection) {
    if(selection == null){
        println("Window was closed or the user hit cancel.");
    }else{
        println("User selected " + selection.getAbsolutePath());

        String location = selection.getAbsolutePath();
        tiler.init(location, "Simple"+nf(frameCount, 5), 5);    //save to the place you want
    }
}

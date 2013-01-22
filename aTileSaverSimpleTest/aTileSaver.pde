/*************************************************
 about sketch: aTileSaver.pde
 
 [purpose]
 - Class for rendering high-resolution images by splitting them into tiles using the viewport. 
 
 [Original version]
 - source : http://workshop.evolutionzone.com/2007/03/24/code-tilesaverpde/
 - version: v0.12 2007.0326
 - author: Marius Watz - http://workshop.evolutionzone.com
 - Builds heavily on solution by "surelyyoujest":  http://processing.org/discourse/yabb_beta/YaBB.cgi?board=OpenGL;action=display;num=1159148942  
 
 [modified and fixed]
 - by Shen, Sheng-Po (shengpo.github.com) and Wu, Kuan-Ying (www.mutienliao.tw)
 - tested on Processing 2.0b7 (other version of PDE should work fine.)
 - date: 2013.1.22
 
 *************************************************/

class aTileSaver {  
    public boolean isTiling=false, done=true;  
    public boolean doSavePreview=true;  

    PApplet p;  
    float FOV=60; // initial field of view  
    float cameraZ, width, height;  
    int tileNum=10, tileNumSq; // number of tiles  
    int tileImgCnt, tileX, tileY;  
    boolean firstFrame=false, secondFrame=false;  
    String tileFilename, tileFileExt=".tga";  
    //String tileFilename, tileFileExt=".png";  
    PImage tileImg;  
    float perc, percMilestone;  

    // The constructor takes a PApplet reference to your sketch.  
    public aTileSaver(PApplet _p) {  
        p=_p;
    }  

    // If init() is called without specifying number of tiles, getMaxTiles()  
    // will be called to estimate number of tiles according to free memory.  
    public void init(String _filename) {  
        init(_filename, getMaxTiles(p.width));
    }  

    // Initialize using a filename to output to and number of tiles to use.  
    public void init(String _filename, int _num) {  
        tileFilename=_filename;  
        tileNum=_num;  
        tileNumSq=(tileNum*tileNum);  

        width=p.width;  
        height=p.height;  
        cameraZ=(height/2.0f)/p.tan(p.PI*FOV/360.0f);  
        p.println("aTileSaver: "+tileNumSq+" tiles and Resolution: "+(p.width*tileNum)+"x"+(p.height*tileNum));  

        // remove extension from filename  
        if (!new java.io.File(tileFilename).isAbsolute())  
            tileFilename=p.dataPath(tileFilename);  
        tileFilename=noExt(tileFilename);  
        p.createPath(tileFilename);  

        // save preview  
        if (doSavePreview) p.g.save(tileFilename+"_preview.png");  

        // set up off-screen buffer for saving tiled images  
        tileImg=new PImage(p.width*tileNum, p.height*tileNum);  

        // start tiling  
        isTiling=true;  
        firstFrame=true;          //for skip first frame after do tiling
        secondFrame=true;     //for skip second frame after do tiling
        tileImgCnt=0;
        tileX = 0;
        tileY = 0;

        done=false;  
        perc=0;  
        percMilestone=0;
    }  

    // set filetype, default is TGA. pass a valid image extension as parameter.  
    public void setSaveType(String extension) {  
        tileFileExt=extension;  
        if (tileFileExt.indexOf(".")==-1) tileFileExt="."+tileFileExt;
    }  

    // pre() handles initialization of each frame.  
    // It should be called in draw() before any drawing occurs.  
    public void pre() {  
        if (!isTiling) return;  
        if (firstFrame) {
            firstFrame=false;  
        } else if (secondFrame) {  
            secondFrame=false;
        }  
        setupCamera();
    }  

    // post() handles tile update and image saving.  
    // It should be called at the very end of draw(), after any drawing.  
    public void post() {  
        // If first or second frame, don't update or save.  
        if (firstFrame || secondFrame || (!isTiling)) return;  

        // Get current image from sketch and draw it into buffer  
        p.loadPixels();  
        tileImg.set(tileX*p.width, tileY*p.height, p.g);  

        // Increment tile index  
        tileImgCnt++;  
        perc=100*((float)tileImgCnt/(float)tileNumSq);  
        if (perc-percMilestone> 5 || perc>99) {  
            p.println(p.nf(perc, 3, 2)+"% completed. "+tileImgCnt+"/"+tileNumSq+" images saved.");  
            percMilestone=perc;
        }  

        if (tileImgCnt==tileNumSq) tileFinish();  
        else tileInc();
    }  

    public boolean checkStatus() {  
        return isTiling;
    }  

    // tileFinish() handles saving of the tiled image  
    public void tileFinish() {  
        isTiling=false;  

        restoreCamera();  

        // save large image to TGA  
        tileFilename+="_"+(p.width*tileNum)+"x"+(p.height*tileNum)+tileFileExt;  
        p.println("Save: "+tileFilename.substring(tileFilename.lastIndexOf(java.io.File.separator)+1));  
        tileImg.save(tileFilename);  
        p.println("Done tiling.n");  

        // clear buffer for garbage collection  
        tileImg=null;  
        done=true;
    }  

    // Increment tile coordinates  
    public void tileInc() {  
        if (tileX==tileNum-1) {  
            tileX=0;  
            tileY=(tileY+1)%tileNum;
        } 
        else {  
            tileX++;
        }
    }  

    // set up camera correctly for the current tile
    //caution: camera's coordination system si different from drawing's coordination system
   //              so, must be very care of parameters in camera() and frustum() !!
    public void setupCamera() {  
        //reset to default camera coordination with Y-UP (up-increase), and original poit is at (width/2f, height/2f, 0)
        p.camera(width/2.0f, height/2.0f, cameraZ, width/2.0f, height/2.0f, 0, 0, 1, 0); 

        if (isTiling) {  
            //set to a specific perspective (or clipping volume) with enough near near-plane and enough far far-plane
            //this step is to fix the viewport on each tile
            float mod=1f/10f;  //to make near plane is close to camera(aka eye)
            p.frustum((-width/2f + width*((float)tileX/(float)tileNum))*mod,         //left
                            (-width/2f + width*((tileX+1)/(float)tileNum))*mod,          //right
                            (height/2f - height*((tileY+1)/(float)tileNum))*mod,         //bottom
                            (height/2f - height*((float)tileY/(float)tileNum))*mod,      //up
                            cameraZ*mod, 10000);                                                //near, far
        }
    }  

    // restore camera once tiling is done  
    public void restoreCamera() {  
        //reset to default camera coordination with Y-UP (up-increase), and original poit is at (width/2f, height/2f, 0)
        p.camera(width/2.0f, height/2.0f, cameraZ, width/2.0f, height/2.0f, 0, 0, 1, 0);  

        //reset to default perspective (or clipping volume) with enough near near-plane and enough far far-plane
        float mod=1f/10f;  //to make near plane is close to camera(aka eye)
        p.frustum(-(width/2)*mod, (width/2)*mod,         //left, right
                       -(height/2)*mod, (height/2)*mod,     //bottom, up
                       cameraZ*mod, 10000);                    //near, far
    }  

    // checks free memory and gives a suggestion for maximum tile  
    // resolution. It should work well in most cases, I've been able  
    // to generate 20k x 20k pixel images with 1.5 GB RAM allocated.  
    public int getMaxTiles(int width) {  
        // get an instance of java.lang.Runtime, force garbage collection  
        java.lang.Runtime runtime=java.lang.Runtime.getRuntime();  
        runtime.gc();  

        // calculate free memory for ARGB (4 byte) data, giving some slack  
        // to out of memory crashes.  
        int num=(int)(Math.sqrt((float)(runtime.freeMemory()/4)*0.925f))/width;  
        p.println(((float)runtime.freeMemory()/(1024*1024))+"/"+((float)runtime.totalMemory()/(1024*1024)));  

        // warn if low memory  
        if (num==1) {  
            p.println("Memory is low. Consider increasing memory.");  
            num=2;
        }  

        return num;
    }  

    // strip extension from filename  
    String noExt(String name) {  
        int last=name.lastIndexOf(".");  
        if (last>0)  
            return name.substring(0, last);  

        return name;
    }
}  


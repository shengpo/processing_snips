//thsi class is learned from toxiclibs, used for peasycam-like

public class EZCam {
    private float currZoom = 1.25f;
    private float defaultZoom = 1.25f;
    private float minZoom = 0.01;
    private float deltaZoom = 0.1;

    private float rotateX = 0;
    private float rotateY = 0;
    private boolean isResetRotate = false;
    
    private float panX = 0;
    private float panY = 0;

    
    public EZCam(){
    }
    
    
    public void beginCam(){
        computeRotate();
        computeZoom();
        computePan();

        pushMatrix();
        translate(panX, panY, 0);
        rotateX(rotateX);
        rotateY(rotateY);
        scale(currZoom);
        translate(-panX, -panY, 0);
    }
    
    
    public void endCam(){
        popMatrix();

        if(isResetRotate){
            isResetRotate = false;
        }
    }
    
    
    private void computeRotate(){
        if(isResetRotate){
            mouseX = 0;
            mouseY = 0;
        }

        if(isRotate){
            rotateX = mouseY*0.01;
            rotateY = mouseX*0.01;
        }
    }
    
    private void computeZoom(){
        if(isZoom){
            currZoom = map(mouseY, 0, height, 7f, 0.01f);
        }
    }

    private void computePan(){
        if(isPan){
            panX = mouseX;
            panY = mouseY;
        }
    }
        
    
    public void resetRotate(){
        isResetRotate = true;
    }

    
    public void doZoomIn(){
        currZoom = currZoom + deltaZoom;
    }


    public void doZoomOut(){
        currZoom = currZoom - deltaZoom;
        if(currZoom < minZoom){
            currZoom = minZoom;
        }
    }
    
    
    public void resetZoom(){
        currZoom = defaultZoom;
    }
    
    
    public void setZoom(float zoom){
        currZoom = zoom;
    }
    
    public void resetPan(){
        panX = width/2;
        panY = height/2;
    }
}

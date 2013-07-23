public class Photo {
    private String photoURL = "";        //url of image 
    private float latitude = -1;         //latitude information of image
    private float longitude = -1;        //longitude information of image
    private String owner = "";           //owner of image
    
    private String dirPath = "";        //local directory path for saving downloaded image
    private PImage img = null;         
    
    private int loadingState = -1;        //-1: unavailable, 0: on loading, 1: loading done
    private boolean isSaved = false;      //check if the image is saved in local directory
    
    public Photo(String dirPath, String photoURL, float latitude, float longitude, String owner){
        this.dirPath = dirPath;
        this.photoURL = photoURL;
        this.latitude = latitude;
        this.longitude = longitude;
        this.owner = owner;
    }

    public Photo(String imgPath){
        img = loadImage(imgPath);
    }
    

    public void doRequestImage(){
        if(img == null){
            img = requestImage(photoURL);
        }else{
            if(img.width < 0){
                //error occurred during loading
                loadingState = -1;
            }else if(img.width == 0){
                //on loading
                loadingState = 0;
            }else{
                //loading successfully
                loadingState = 1;
                
                //save to directory
                if(!isSaved){
                    String[] segment = split(photoURL, "/");
                    String filename = segment[segment.length-1];
                    
                    img.save(dirPath + filename);
                    isSaved = true;
                }
            }
        }
    }
    
    
    public int getLoadingState(){
        return loadingState;
    }
    
    public PImage getImage(){
        return img;
    }
}

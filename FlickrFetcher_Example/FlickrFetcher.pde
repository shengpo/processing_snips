public class FlickrFetcher {
    private String api_key = "";
    private String sortMode = "relevance";                        //the sort mode of the search result
//    private String flickrAPI_url;                                 //for query Flickr API service
    private ArrayList<String> photoNameCheckList = null;    //紀錄已經下載下來的photo圖檔名稱, 並用來對將要下載下來的photo圖檔做名稱確認，若已經下載過便不再下載
    
    private String dirPath = "";        //local directory path for saving downloaded image
    private boolean isSetFinalDirPath = false;

    
    public FlickrFetcher(String API_KEY, String sortMode){
        this.api_key = API_KEY;
        this.sortMode = sortMode;
        photoNameCheckList = new ArrayList<String>();
    }
    
    public void setSortMode(String sortMode){
        this.sortMode = sortMode;
    }
        
    public void setDirPath(String dirPath){
        this.dirPath = dirPath;
    }
    
    //set the final directory path for saving loaded images        
    private void setFinalDirPath(String query){
        if(!isSetFinalDirPath){
            if(dirPath.equals("")){
                dirPath = dataPath("search/"+query) + "/";
            }else{
                if(dirPath.charAt(dirPath.length()-1) == '/'){
                    dirPath = dirPath + query + "/";
                }else{
                    dirPath = dirPath + "/" + query + "/";
                }
            }

            isSetFinalDirPath = true;
        }
    }
    
    private String getFlickrPhotoSearchAPI_url(String query, int photoCountPerPage, int atPage){
        String flickrPhotoSearchAPI_url = "";

        if(atPage <= 0){
            flickrPhotoSearchAPI_url = "http://www.flickr.com/services/rest/?api_key=" + api_key + "&method=flickr.photos.search&sort=" + sortMode + "&per_page=" + photoCountPerPage + "&text=" + urlEncode(query) + "&extras=geo,owner_name";
            println("Flickr Image search: " + flickrPhotoSearchAPI_url);
        }else{
            flickrPhotoSearchAPI_url = "http://www.flickr.com/services/rest/?api_key=" + api_key + "&method=flickr.photos.search&sort=" + sortMode + "&per_page=" + photoCountPerPage + "&text=" + urlEncode(query) + "&extras=geo,owner_name&page="+atPage;
            println("Flickr Image search again (width page parameter): " + flickrPhotoSearchAPI_url);
        }

        return flickrPhotoSearchAPI_url;
    }    
    
    public ArrayList<Photo> getPhotos(String query, int photoCountPerPage){    //photoCountPerPage : how many images will be got in one page (max: 500)
        ArrayList<Photo> photoList = new ArrayList<Photo>();
        XML rsp = null;

        //set the final directory path for saving loaded images        
        setFinalDirPath(query);
        
        if(query!=null && !query.equals("")){
            rsp = loadXML(getFlickrPhotoSearchAPI_url(query, photoCountPerPage, -1));
            
            if(rsp != null){
                if(rsp.getString("stat").equals("ok")){    //get photos successfully
                    XML photos = rsp.getChild("photos");
                    
                    if(photos.getInt("total") > 0){    //at least one image was found
                        //如果搜尋結果大於一個page, 則隨機選一個page
                        if(photos.getInt("pages") > 1){
                            println("[INFO] the results is more than one page, hence search again by using random page ...");
                            
                            int atPage = (int)random(photos.getInt("pages")) + 1;
                            rsp = loadXML(getFlickrPhotoSearchAPI_url(query, photoCountPerPage, atPage));
                            
                            if(rsp != null){
                                if(rsp.getString("stat").equals("ok")){    //get photos successfully
                                    photos = rsp.getChild("photos");
                                    
                                    if(photos.getInt("total") > 0){    //at least one image was found
                                            XML[] photo = photos.getChildren("photo");
                                            
                                            for(int i=0; i<photo.length; i++){
                                                float latitude = photo[i].getFloat("latitude");
                                                float longitude = photo[i].getFloat("longitude");
                                                String photoURL_b = "http://farm"+ photo[i].getInt("farm") +".static.flickr.com/" +
                                                                photo[i].getInt("server") + "/" +  
                                                                photo[i].getString("id") + "_" +  
                                                                photo[i].getString("secret") + "_b.jpg";  //t:縮圖，最長邊為 100; m:小，最長邊為 240; b:大尺寸，最長邊為 1024
                                                                                                                        //參考網頁：http://www.flickr.com/services/api/misc.urls.html
                                                String owner = photo[i].getString("ownername");
                                                
                                                //photoList.add(new Photo(dirPath, photoURL_b, latitude, longitude, owner));
                                                //確認是否photo已經下載過了
                                                if(checkPhotoIfDownloaded(photoURL_b) == false){
                                                    photoList.add(new Photo(dirPath, photoURL_b, latitude, longitude, owner));    //沒有下載過才加到list中
                                                }
                                            }
                                    }
                                }else{    //get photos failed
                                    println("Response Error: fail to get search result from flickr api ...");
                                    println("Error code: " + rsp.getChild(0).getString("code"));
                                    println("Error message: " + rsp.getChild(0).getString("msg"));
                                }
                            }else{
                                println("[INFO] Flickr API: flickr.photos.search is unreachable");
                            }
                        }else{    //如果搜尋結果只有一個page, 使用目前的搜尋結果
                            println("[INFO] the results is only in one page, hence using the results ...");
                        
                            XML[] photo = photos.getChildren("photo");
                            
                            for(int i=0; i<photo.length; i++){
                                float latitude = photo[i].getFloat("latitude");
                                float longitude = photo[i].getFloat("longitude");
                                String photoURL_b = "http://farm"+ photo[i].getInt("farm") +".static.flickr.com/" +
                                                photo[i].getInt("server") + "/" +  
                                                photo[i].getString("id") + "_" +  
                                                photo[i].getString("secret") + "_b.jpg";  //t:縮圖，最長邊為 100; m:小，最長邊為 240; b:大尺寸，最長邊為 1024
                                String owner = photo[i].getString("ownername");
                                
                                //photoList.add(new Photo(dirPath, photoURL_b, latitude, longitude, owner));
                                //確認是否photo已經下載過了
                                if(checkPhotoIfDownloaded(photoURL_b) == false){
                                    photoList.add(new Photo(dirPath, photoURL_b, latitude, longitude, owner));    //沒有下載過才加到list中
                                }
                            }
                        }
                    }
                }else{    //get photos failed
                    println("Response Error: fail to get search result from flickr api ...");
                    println("Error code: " + rsp.getChild(0).getString("code"));
                    println("Error message: " + rsp.getChild(0).getString("msg"));
                }
            }else{
                println("[INFO] Flickr API: flickr.photos.search is unreachable");
            }
        }
        
        return photoList;
    }
    
    public void cealerPhotoNameCheckList(){
        photoNameCheckList.clear();
    }
    
    private boolean checkPhotoIfDownloaded(String photoURL){
        boolean isDownloaded = false;
        
        for(int i=0; i<photoNameCheckList.size(); i++){
            if(photoNameCheckList.get(i).equals(photoURL)){
                isDownloaded = true;
                break;
            }
        }
        
        if(!isDownloaded){
            photoNameCheckList.add(photoURL);
        }
        
        return isDownloaded;
    }
}

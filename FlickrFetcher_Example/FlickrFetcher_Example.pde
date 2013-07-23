/*
 此程式展示 如何利用flickr API來取得flickr上的公開照片
 也同時展示如何去解析flickr API所回傳的XML文件，以取得每張照片的相關資訊
 此程式透過關鍵字搜尋照片，然後將取得的照片儲存在本機端設定的資料夾中，並在程式畫面中機播放
 
 Author: Shen, Sheng-Po (http://shengpo.github.io)
 Test Environment: Processing 2.0.1
 Date:   2013.07.20
 License: CC BY-SA 3.0
*/



//for flickr fetcher
FlickrFetcher flickrFetcher = null;
String API_KEY = "92e0515f6f3ab362f92592b11f03feb2";    //flickr API KEY
String sortMode = "relevance";       //the sort mode of the search result (posiible values: date-posted-asc, date-posted-desc, date-taken-asc, date-taken-desc, interestingness-desc, interestingness-asc, and relevance.)
int howManyPhoto2Get = 30;        //一次最多取得幾張photo

ArrayList<Photo> photoList = null; 
int loadingPeriod = 5;    //每次loading圖片的總時間(秒) (超過時間表示loading不成功)
int retryTimes = 3;         //搜尋圖片最多retry幾次

String dirPath = "";    //下載下來的flickr圖檔所要放置的資料夾位置


void setup(){
    size(800, 600);

    //for flick fetcher
    flickrFetcher = new FlickrFetcher(API_KEY, sortMode);
    dirPath = dataPath("flickr");    //dirPath若是空字串，則會將結果儲存在 data/search/ 之下
    flickrFetcher.setDirPath(dirPath);

    photoList = new ArrayList<Photo>();

    String query = "台北101";
    doFlickrSearch(query);

    //now, if photos are fetched, then they has been saved in the dirPath
}

void draw(){
    background(0);

    //show fetched photos randomly
    if(photoList.size() > 0){
        PImage img = photoList.get((int)random(photoList.size())).getImage();
        img.resize(0, height);
        
        image(img, (width-img.width)/2, 0);
    }
    
    delay(1000);
}


/*** flickr fetcher related functions/methods ***/

void doFlickrSearch(String query){
    int retryCount = 0;

    do{
        retryCount = retryCount + 1;
        println("do flickr searching ...... " + retryCount + "/" + retryTimes);
        
        if(howManyPhoto2Get-photoList.size() > 0){    //還沒搜尋完整時才再搜尋
            ArrayList<Photo> tempList = flickrFetcher.getPhotos(query, howManyPhoto2Get-photoList.size());
            if(tempList.size() == 0){
                println("[INFO] no more search results.");
            }else{
                photoList.addAll(tempList);    //將搜尋結果加到photoList中
            }
        }
        doPreparePhotos();
    }while(retryCount < retryTimes);

    //清除loadingState為0的photo
    clearUnloadedPhotos();
}


void doPreparePhotos(){
    println("prepareing (loading) GO ! ");

    int targetMillis = millis() + 1000*loadingPeriod;
    do{
        for(Photo p: photoList){
            p.doRequestImage();
        }
//        print(".");
    }while(millis() < targetMillis);
    
    //delete unavailable photos
    int loadedCount = 0;
    for(int i=photoList.size()-1; i>=0; i--){
        if(photoList.get(i).getLoadingState() == -1){
            photoList.remove(i);
        }else if(photoList.get(i).getLoadingState() == 1){
            loadedCount = loadedCount + 1;
        }
    }
    
    //print out current loading state
    println("[loading state] : " + loadedCount + "/" + howManyPhoto2Get);
}


void clearUnloadedPhotos(){
    for(int i=photoList.size()-1; i>=0; i--){
        if(photoList.get(i).getLoadingState() <= 0){
            photoList.remove(i);
            println("[INFO] remove one uncompleted-loading photo ...");
        }
    }
    
    //clear photoNameCheckList
    flickrFetcher.cealerPhotoNameCheckList();
    //print out current loading state
    println("[FINAL loading state] : " + photoList.size() + "/" + howManyPhoto2Get);
}

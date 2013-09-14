/*
add start() and quit() for more flexible usage (if you want)
reference: http://wiki.processing.org/w/Threading

date: 2013.9.14
*/

public class GarbageCollector extends Thread {
    private int start = 0;                        //in milliseconds
    private float periodMinute = 5;        //do the garbage collection on every period    (in minutes)
    private Runtime runtime = null;

    public GarbageCollector(float periodMinute) {
        start = millis();
        this.periodMinute = periodMinute;
        // get an instance of java.lang.Runtime, force garbage collection  
        runtime=java.lang.Runtime.getRuntime();
    }

    void start() {
        //do something you want here ...

        super.start();    //don't forgot this!!
    }

    public void run() {
        while (true) {
            if ( (millis()-start) > periodMinute*60*1000 ) {
                start = millis();
                runtime.gc();  
                println("--> run the java garbage collection");
            }
        }
    }
    
    //customized method
    public void quit() {
        System.out.println("--> quitting GarbageCollector thread"); 

        // IUn case the thread is waiting. . .
        interrupt();
    }
}


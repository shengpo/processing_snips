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

        public void run() {
                while (true) {
                        if ( (millis()-start) > periodMinute*60*1000 ) {
                                start = millis();
                                runtime.gc();  
                                println("--> run the java garbage collection");
                        }
                }
        }
}


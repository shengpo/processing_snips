//registerMethod() 參考自Peasycam library的Peasycam class作法

class Car {
    private PApplet papplet = null;
    private MyMouseWheelListener myMouseWheelListener = null;

    private int x = 0;
    private int y = 0;
    private int yDelta = 0;

    public Car(PApplet papplet, int x, int y) {
        myMouseWheelListener = new MyMouseWheelListener();

        //利用PApplet提供的registerMethod重新將"mouseEvent" method註冊成MyMouseWheelListener的mouseEvent()
        papplet.registerMethod("mouseEvent", myMouseWheelListener);    
        
        this.x = x;
        this.y = y;
    }

    public void update() {
        y = y + yDelta;
    }

    public void show() {
        stroke(0);
        fill(255, 0, 0);
        rect(x-15, y-50, 30, 100);
    }

    //需有一個內嵌 protected class
    protected class MyMouseWheelListener {

        public MyMouseWheelListener() {
        }

        //method name必須是mouseEvent, 參數必須是MouseEvent
        public void mouseEvent(MouseEvent e) {
            if (e.getAction() == MouseEvent.WHEEL) {    //偵測是否為滑鼠滾輪事件
                println(e.getCount());
                
                yDelta = e.getCount();
            }
        }
    }
}


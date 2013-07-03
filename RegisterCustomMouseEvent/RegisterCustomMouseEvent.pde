Car car = null;

void setup() {
  size(400, 400);
  
  car = new Car(this, width/2, height/2);
}

void draw() {
    background(255);
    car.update();
    car.show();
} 



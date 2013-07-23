/*
 此程式展示 physical system + texture 的有趣效果
 藉由滑鼠拖拉離滑鼠最近的particle，然後放開
 因為physical system的關係，particle彼此之間的震盪拉扯，造成texture rendering類似波動的有趣變化
 
 demo video: http://youtu.be/UxkzE4cLwY4

 Author: Shen, Sheng-Po (http://shengpo.github.io)
 Test Environment: Processing 2.0.1
 Date:   2013.07.21
 License: CC BY-SA 3.0
*/

import traer.physics.*;

//physics
ParticleSystem physics;
Particle[][] particles;
int countX = 20;    //x軸方向的particle數量
int countY = 10;    //y軸方向的particle數量
float gridStepX;    //x軸方向，兩個particle之間的間距
float gridStepY;    //y軸方向，兩個particle之間的間距

float PARTICLE_MASS = 5;
float SPRING_STRENGTH = 0.2;
float SPRING_DAMPING = 0.3;

int selectX = -1;    //被滑鼠選擇到的particle的x軸方向的索引值
int selectY = -1;    //被滑鼠選擇到的particle的y軸方向的索引值


//image source
PImage img = null;
ArrayList<PImage> imgList = null;    //用來儲存從原始影像切割而來的成多個texture image, 以加速rendering速度




void setup() {
    size(610, 319, P3D);
//    size(800, 600, P3D);

    //image source
    img = loadImage("angrybirds.jpg");
    img.resize(width, height);
    imgList = new ArrayList<PImage>();

    //physics
    physics = new ParticleSystem(0, 0, -0.01, 0.01);
    particles = new Particle[countX][countY];

    gridStepX = width/(countX-1f);
    gridStepY = height/(countY-1f);


    //create particles
    for(int i=0; i<countX; i++){
            for(int j=0; j<countY; j++){
                    particles[i][j] = physics.makeParticle(PARTICLE_MASS, i*gridStepX, j*gridStepY, 0);
            }
    }

    //create partial texture (for speed up the texture rendering)
    for(int i=0; i<countX-1; i++){
            for(int j=0; j<countY-1; j++){
                    imgList.add(img.get((int)(i*gridStepX), (int)(j*gridStepY), (int)gridStepX, (int)gridStepY));
            }
    }
    
    //make springs
    for(int i=0; i<countX; i++){
            for(int j=1; j<countY; j++){
                    physics.makeSpring(particles[i][j-1], particles[i][j], SPRING_STRENGTH, SPRING_DAMPING, gridStepY);
            }
    }
    for(int j=0; j<countY; j++){
            for(int i=1; i<countX; i++){
                    physics.makeSpring(particles[i-1][j], particles[i][j], SPRING_STRENGTH, SPRING_DAMPING, gridStepX);
            }
    }


    //fix surrounding particles
    for(int i=0; i<countX; i++){
        particles[i][0].makeFixed();           //上邊
        particles[i][countY-1].makeFixed();    //下邊
    }
    for(int j=0; j<countY; j++){
        particles[0][j].makeFixed();           //左邊
        particles[countX-1][j].makeFixed();    //右邊
    }
        
    //set texture mode
    textureMode(NORMAL);
}

void draw() {
    physics.tick();
    
    int index = 0;
    noStroke();
    for(int i=0; i<countX-1; i++){
        for(int j=0; j<countY-1; j++){
            beginShape();
            texture(imgList.get(index));    //use prepared texture image will speed up the rendering
//            texture(img.get(int(i*gridStepX), int(j*gridStepY), int(gridStepX), int(gridStepY)));    //real-time getting texture will speed down the rendering
            vertex(particles[i][j].position().x(), particles[i][j].position().y(), particles[i][j].position().z(), 0, 0);
            vertex(particles[i+1][j].position().x(), particles[i+1][j].position().y(), particles[i+1][j].position().z(), 1, 0);
            vertex(particles[i+1][j+1].position().x(), particles[i+1][j+1].position().y(), particles[i+1][j+1].position().z(), 1, 1);
            vertex(particles[i][j+1].position().x(), particles[i][j+1].position().y(), particles[i][j+1].position().z(), 0, 1);
            endShape();    
            
            index = index + 1;
        }
    }
    
    if(selectX>=0 && selectY>=0){
        particles[selectX][selectY].position().set(mouseX, mouseY, 0);
//        particles[selectX][selectY].position().add(mouseX-pmouseX, mouseY-pmouseY, 0);
    }
}


//press mouse to select the closest particle
void mousePressed(){
    float d = dist(0, 0, 0, width, height, 0);
    
    if(selectX<0 && selectY<0){
        for(int i=0; i<countX; i++){
            for(int j=0; j<countY; j++){
                float di = dist(mouseX, mouseY, 0, particles[i][j].position().x(), particles[i][j].position().y(), particles[i][j].position().z()); 
                if( di < d){
                    d = di;
                    selectX = i;
                    selectY = j;
                }
            }
        }
    }
}


void mouseReleased(){
    if(selectX>=0 && selectY>=0){
//        particles[selectX][selectY].velocity().set((mouseX-pmouseX), (mouseY-pmouseY), 0);
        selectX = -1;
        selectY = -1;
    }    
}

class Grass{
 
  float _x, _h, _xTarget;
  float _x2 = 0;
  
  Grass(float x, float h){
    _x = x;
    _h = h;
    _x2 = x;
    update();
  }
  
  void update(){
    strokeWeight(1);
    _xTarget = _x+random(-5,5);
    _x2 += (_xTarget - _x2)/10;
    line(_x, height, _x2, height-_h); 
  }
  
}

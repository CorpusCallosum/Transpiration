class Branch {
  //subclass instantiated by Elevator for each floor
  //used to keep track of floor activity, and effect the curlinessof branch fractility
  // int _len;
  //float _num;
  //constructor

  //_len = len;
  //_num = num;

  float curlx = 0; 
  float curly = 0; 
  float f; 
  float deley = 10; 
  float growth = 0; 
  float growthTarget = 10;
  int branch, _fl, _cnt;
  float _x, _y, curlLength, _dir;
  float growthRate = 1;
  float growthMax = 12;
  int _detail = 2;
  int _c1 = 255;
  int _c2 = 255;
  int _c3 = 255;


  Branch(int fl, float x, float y) {
    //constructor
    _fl = fl;
    _x = x;
    _y = y;

    //decide branch direction


    float r = 0;

    if (fl%2 == 0) {
      _dir = 1 + random(-r, r);
    }
    else {
      _dir = -1 + random(-r, r);
    }

    curlLength = map(_fl, 1, 26, 3, 5);
    curlLength += random(-r, r);
  }

  void drawBranch() {
    _cnt = 0;
    f = sqrt(2)/curlLength; 

    // translate(width/2,height/3*2); 
    // background(250);
  //  stroke(_c1);
   // colorMode(HSB);
   
    strokeWeight(1);
    fill(255, 255, 255, 50);
    //curlx += (radians(360.f/height*mouseX)-curlx)/deley;
    //curly += (radians(360.f/height*mouseY)-curly)/deley;

    curlx += (radians(360.f/height*10*_dir)-curlx)/deley;
    curly += (radians(360.f/height*2)-curly)/deley;

    pushMatrix();
    translate(_x, _y);
          //rotate(-200*_dir);

    branch(height/5.f, 17);
    popMatrix();

    growth += (growthTarget/10-growth+.1)/deley;
    
  }

  void branch(float len, int num) 
  { 
   //  _c1 += (255-_c1)/50;
   // _c2 += (255-_c2)/50;
   // _c3 += (255-_c3)/50;
    stroke(_c1,_c2,_c3);
    //  stroke(0, 150, 0, 90);
    // println("branch");
    len = len*f*1.25; 
    num -= 1; 
    if ((len > _detail) && (num > 0)) 
    { 
      //      if (blurCnt == blurSpeed) {
      //        blurCnt = 0;
      //        filter(BLUR, 1);
      //      }
      pushMatrix(); 
      rotate(curlx*10);

      line(0, 0, 0, -len-8); 
      translate(0, -len); 
      branch(len, num); 
      popMatrix(); 

      //    pushMatrix(); 
      //    line(0,0,0,-len); 
      //    translate(0,-len); 
      //    branch(len); 
      //    popMatrix(); 
      if(_cnt > 0){
        len *= growth; 
        pushMatrix(); 
        rotate(curlx-curly); 
        line(0, 0, 0, -len-5); 
        translate(0, -len); 
        branch(len, num); 
        popMatrix(); 
      }
      //len /= growth;
    }
    _cnt++;
  }

  void grow() {
 /*  _c1 = 204;
   _c2 = 153;
   _c3 = 0;*/
    if (growthTarget < growthMax) {
      growthTarget += growthRate;
      curlLength += growthRate/100;
      curlx += growthRate/20;
      curly += growthRate/20;
    }
  }

  void shrink() {
    growthTarget -= growthRate;
    curlLength -= growthRate/100;
    curlx -= growthRate/20;
    curly -= growthRate/20;
  }
  
  void setWind(float wind){
    curlx += wind;
  }
}


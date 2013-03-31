//-- Img / @kikko_fr
//-- ECV Kinect Workshop 2013 

class Img extends PVector {
  
  PImage img;
  PVector velocity;
  float rotation;
  float scale;
  float acc;
  float alpha;
  int numUpdates;
  
  float dRotation, rotationDest;
  
  Img(PImage img_, PVector velocity_)
  {
    img = img_;
    velocity = velocity_;
    
    numUpdates = 0;
    rotation = 0;
    scale = 1;
    acc = 0.95;
    alpha = 1;
    
    rotationDest = 360;
  }
  
  boolean update()
  {
    dRotation = (rotationDest - rotation) * 0.05;
    rotation += dRotation;
    
    // apply friction
    velocity.x *= acc;
    velocity.y *= acc;
    velocity.z *= acc;
    
    // apply velocity
    x += velocity.x;
    y += velocity.y;
    
    //alpha *= 0.97;
    
    numUpdates = numUpdates + 1;
    
    // return validity of this image
    boolean isValid = numUpdates < 2 * 60;
    
    return isValid;
  }
  
  void draw(PApplet ctx)
  {
    ctx.pushMatrix();
    
    ctx.translate(x, y);
    ctx.scale(scale);
    ctx.rotate( radians(rotation) );
    
    tint(255, alpha*255);
    image( img, - img.width*0.5, - img.height*0.5, img.width, img.height);
    
    ctx.popMatrix();
  }
}

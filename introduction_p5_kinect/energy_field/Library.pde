//-- Library / @kikko_fr
//-- ECV Kinect Workshop 2013 

class Library
{
  ArrayList imgs;
  
  Library()
  {
    imgs = new ArrayList();
    
    String photoPath = dataPath("images");
    
    File dsStore = new File(photoPath+"/.DS_Store");
    if(dsStore.exists()) dsStore.delete();
    
    File photoDir = new File(photoPath);
    String[] files = photoDir.list();
    if(files.length == 0) return;
    
    for(int i=0; i<files.length; i++)
    {
      imgs.add(0, loadImage(photoPath + "/" + files[i]));
    }
  }
  
  int getNumImages()
  {
    return imgs.size();
  }
  
  PImage getImageAt(int pos)
  {
    return (PImage)imgs.get(pos);
  }
  
  PImage getRandomImage()
  {
    int pos = (int)random(imgs.size());
    return (PImage)imgs.get(pos);
  }
}

import processing.opengl.*;

//This sketch is to test the soundanalyzer class
SoundAnalyzerClass sa;
float[] energy;
int col_width = 0;

void setup(){  
  frameRate(100);
  size(512, 200, OPENGL);
  background(0);  
  sa = new SoundAnalyzerClass(this, new String("reprise.wav"), 128);
  if (sa.isAveraging()){  
    energy = new float[sa.Averages()];
    println("avgs: " + sa.Averages());
    col_width = width/sa.Averages();    
  }
  else {    
    energy = new float[sa.NumFreq()];
    col_width = width/sa.NumFreq();    
  }    
  rectMode(CORNERS);  
}

void draw(){
  //println(col_width);
  background(0);
  fill(255);  
  energy = sa.Analyze();
  for (int i=0;i<energy.length;i++){
    rect(i*col_width, height, i*col_width + col_width, height -  energy[i]);
    //println(energy[i]);
  }  
}

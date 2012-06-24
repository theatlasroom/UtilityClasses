/*
SoundAnalyzerClass V1 
24/6/2012

this class uses the minim library to analyze a sound source
the class returns a n-length array of amplitudes values for each frequency

*/


import ddf.minim.*;
import ddf.minim.analysis.*;

class SoundAnalyzerClass {
  private Minim m;   //reference to the minim object
  private AudioPlayer source;  //reference to the current sound source
  private FFT fft;  //reference to the fft object
  private String file_name;  //name of the file to analyze (if needed);
  private int buffer_size = 2048, num_freq = 50;
  private float[] freq; 
  
  SoundAnalyzerClass(String file_name, int num_freq){
    this.file_name = file_name;
    this.source = m.loadFile(this.file_name, buffer_size);
    //create an fft object, set the timesize to the size of the samples buffer and the samplerate to source files samplerate
    this.fft = new FFT(this.source.bufferSize(), this.source.sampleRate());
  }
  
  public float[] Analyze(){
    //perform the forward transform on the audio
    this.fft.forward(this.source.mix);
    //iterate through the frequencies, return an array of values
    for (int i=this.num_freq-1;i>0;i--){
      
    }
  } 
  
  
  //utility functions
  public void init(int num_freq){
    //create the frequency array
    this.num_freq = num_freq;
    this.freq = new float[num_freq];    
  }
  
  public void CleanUp(){
    //clean up all the objects that are created
    this.source = null;
    this.fft = null;
    //return minims resources
    this.m.stop();
    super.stop();
  }  
}

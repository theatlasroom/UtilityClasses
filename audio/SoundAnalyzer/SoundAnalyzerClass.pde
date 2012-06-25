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
  private static final int LOG_AVG = 0, LIN_AVG = 1, NO_AVG = 2; 
  private int buffer_size = 2048, num_freq = 128, averaging = LOG_AVG, averages = 128;
  private float[] freq; 
  private boolean use_averaging = true;
  private PApplet parent = null;
  
    
  public SoundAnalyzerClass(PApplet parent, String file_name){this.init(parent, file_name, this.num_freq, this.averaging, this.averages);}
  public SoundAnalyzerClass(PApplet parent, String file_name, int averages){this.init(parent, file_name, this.num_freq, this.averaging, averages);}  
  public SoundAnalyzerClass(PApplet parent, String file_name, int num_freq, int averaging, int averages){this.init(parent, file_name, num_freq, averaging, averages);}
  
  public float[] Analyze(){
    //perform the forward transform on the audio
    this.fft.forward(this.source.mix);
    switch (this.averaging){      
      case LIN_AVG:  //linear averaging
        this.LinAnalysis();
        break;
      case LOG_AVG:   //logarithmic averaging
        this.LogAnalysis();
        break;
      default:  //default to no averaging     
        this.FreqAnalysis();      
        break;        
    }
    return this.freq;
  } 
  
  public void LinAnalysis(){
    //println("averages");
    for (int i=0;i<this.averages;i++)
      this.freq[i] = this.fft.getAvg(i);  //store the value of the ith averaged frequency band    
  }
    
  public void LogAnalysis(){
    //println("averages");
    for (int i=0;i<this.averages;i++){
      //this.fft.scaleBand(i, 0.5);      
      this.freq[i] = (this.ScaleAmplitude(i) * this.fft.getAvg(i)) / 10;  //store the value of the ith averaged frequency band
    }    
  }
    
  public void FreqAnalysis(){
    //iterate through the frequencies, return an array of values
    for (int i=0;i<this.num_freq-1;i++)
      //this.freq[i] = this.fft.getBand(i);  //store the value of the ith frequency band    
      this.freq[i] = (this.ScaleAmplitude(i) * this.fft.getBand(i))/10;  //store the value of the ith frequency band    
  } 
  
  public float ScaleAmplitude(int band){
    //scale logarithmically base 10
    return band * (log(band)/log(10));    
  }
  
  //public getters
  public int BufferSize(){return this.buffer_size;};
  public int NumFreq(){return this.num_freq;};
  public int Averages(){return this.averages;};
  public boolean isAveraging(){return this.use_averaging;};  
  
  //utility functions
  private void init(PApplet parent, String file_name, int num_freq, int averaging, int averages){
    this.parent = parent;
    this.m = new Minim(parent);
    this.file_name = file_name;
   
    this.source = m.loadFile(this.file_name, this.buffer_size);
    //create an fft object, set the timesize to the size of the samples buffer and the samplerate to source files samplerate
    this.fft = new FFT(this.source.bufferSize(), this.source.sampleRate());
    //use a hamming window to help reduce noise
    this.fft.window(FFT.HAMMING);
    //create the array assuming averaging will be used    
    this.averages = averages;
    this.freq = new float[this.averages];    
    switch (this.averaging){      
      case LIN_AVG:  //linear averaging
        this.fft.linAverages(this.averages);
        break;
      case LOG_AVG:   //logarithmic averaging
        this.fft.logAverages(22,10);
        this.averages = fft.avgSize(); 
        this.freq = new float[this.averages];        
        println("avg-size: " + fft.avgSize());
        break;
      default:  //default to no averaging     
        this.use_averaging = false;  
        //create the frequency array
        this.num_freq = num_freq;    
        this.freq = new float[num_freq];        
        break;        
    }
    this.source.loop();   
  }
  
  public void CleanUp(){
    //clean up all the objects that are created
    this.source.close();
    this.fft = null;
    //return minims resources
    this.m.stop();
  }  
}

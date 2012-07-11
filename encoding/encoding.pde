BitEncoderDecoder b;
int len = 50;
float[] data_arr;
int action = 0;

void setup(){
  b = new BitEncoderDecoder(0.5, len);
  data_arr = new float[len];
  if (action == 0)
    b.OpenWriteStream();
  else
    b.ReadFile();
}

void draw(){
  if (action == 0)
    Encode();
  else
    Decode();
  if (frameCount == 100){
    b.CloseStream();
    b.ReadFile();
    action = 1;
  }
}

void populate(){
  for (int i=0;i<len;i++)
    data_arr[i] = random(0, 1);
}

void Encode(){
  populate();  
  b.Encode(data_arr);  
}

void Decode(){
  String s = b.Decode();
  if (s != null){
    println(s);
  }  
}

void stop(){
  b.CloseStream();
}

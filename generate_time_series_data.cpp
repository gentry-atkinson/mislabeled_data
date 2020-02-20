#include<iostream>
#include<fstream>
#include<cmath>
#include<cstdlib>
#include<time.h>
#include<climits>

using namespace std;

int main(int argc, char** argv){
  if(argc != 5){
    cerr << "Usage is genTS num_samples sample_rate seconds_per_sample"
      << " num_lables"<< endl;
    return 1;
  }
  const int numSample = atoi(argv[1]);
  const int sampleRate = atoi(argv[2]);
  const int numSeconds = atoi(argv[3]);
  const int numLables = atoi(argv[4]);
  const float maxInt = static_cast<float>(INT_MAX);

  ofstream sampleFile("synthetic_examples.csv");
  ofstream labelFile("synthetic_labels.csv");

  float signal1Scale[numLables], signal1Phase[numLables], signal1Offset[numLables];
  float signal2Scale[numLables], signal2Phase[numLables], signal2Offset[numLables];
  float signal3Scale[numLables], signal3Phase[numLables], signal3Offset[numLables];

  //initialze signal values for each label
  for(int i = 0; i < numLables; i++){
    signal1Scale[i] = 0.5 + rand()/maxInt;
    signal1Phase[i] = rand()/maxInt;
    signal1Offset[i] = rand()%5;
    signal2Scale[i] = 1.0 + 2*rand()/maxInt;
    signal2Phase[i] = 2*rand()/maxInt;
    signal2Offset[i] = rand()%5;
    signal3Scale[i] = 4.0 + 3*rand()/maxInt;
    signal3Phase[i] = 2*rand()/maxInt;
    signal3Offset[i] = rand()%5;
  }

  //write samples
  for(int i = 0; i<numSample; i++){
    int sampleLable = rand() % numLables;
    float scaleNoise, phaseNoise, offsetNoise;
    scaleNoise = 0.1 * rand()/maxInt + 1.0;
    phaseNoise = 0.1 * rand()/maxInt;
    for(int j = 0; j<sampleRate*numSeconds; j++){
        offsetNoise = 0.05 * rand()/maxInt;
        float sampleValue = 0;
        sampleValue += ((2.0*j/static_cast<float>(sampleRate))*scaleNoise*signal1Scale[sampleLable]+signal1Phase[sampleLable]+phaseNoise)*M_PI+offsetNoise+signal1Offset[sampleLable];
        sampleValue += ((2.0*j/static_cast<float>(sampleRate))*scaleNoise*signal2Scale[sampleLable]+signal2Phase[sampleLable]+phaseNoise)*M_PI+offsetNoise+signal2Offset[sampleLable];
        sampleValue += ((2.0*j/static_cast<float>(sampleRate))*scaleNoise*signal3Scale[sampleLable]+signal3Phase[sampleLable]+phaseNoise)*M_PI+offsetNoise+signal3Offset[sampleLable];
        sampleFile << sampleValue;
        if(j != sampleRate*numSeconds-1)sampleFile<<", ";
    }
    labelFile << sampleLable << endl;
    sampleFile << endl;
  }

  srand(time(NULL));
  return 0;
}

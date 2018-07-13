ECE417_MP5_AV_Data.mat

This file has four variables:

(1) av_train is the training audio-visual data.
    av_train.audio is the audio feature matrix. 
    Each column av_train.audio(:,k) represents the audio feature 
    vector of frame k.
    av_train.visual is the visual feature matrix. 
    Each column av_train.visual(:,k) represents the visual feature 
    vector of frame k.

(2) av_validate is the audio-visual data for validation.
    av_validate.audio is the audio feature matrix. 
    Each column av_validate.audio(:,k) represents the audio feature 
    vector of frame k.
    av_validate.visual is the visual feature matrix. 
    Each column av_validate.visual(:,k) represents the visual feature 
    vector of frame k.

(3) testAudio is the test audio data matrix. Each column of testAudio
    is an audio feature vector.

(4) silenceModel will be used to decide if an audio frame is silence.

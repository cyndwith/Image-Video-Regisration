clc;
clear all;
close all;
video1 = 'video Registration Database/palli_video/palli_video_left.mp4';
video2 = 'video Registration Database/palli_video/palli_video_right.mp4';
%video3 = 'video Registration Database/palli_video/bitcamp3.mp4';
outputFile = 'video Registration Database/palli_video/outputVideo/';
videoRegistration(video1,video2,outputFile);
%video_panorama_4_6(video3,'para.avi');

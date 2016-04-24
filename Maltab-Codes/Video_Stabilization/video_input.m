clear;clc;
%url1 = 'http://10.109.148.113:8080/shot.jpg';
url2 = 'http://10.109.32.30:8080/shot.jpg';
%ss1  = imread(url1);
%fh1 = image(ss1);
ss2  = imread(url2);
fh2 = image(ss2);
while(1)
   %ss1  = imread(url1);
   %ss1 = imresize(ss1,0.2);
   ss2  = imread(url2);
   ss2 = imresize(ss2,0.2);
   %set(fh1,'CData',ss1);
   %figure(1); drawnow;
   set(fh2,'CData',ss2);
   figure(2);drawnow;
end
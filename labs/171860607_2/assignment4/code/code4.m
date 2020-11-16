function [final] =code4(Gauss_D)
%Gauss_D=60;
%pic-A
f=mat2gray(imread('woman.png'));
[x,y]=size(f); 
newf=zeros(2*x,2*y);
newf(1:x,1:y)=f;
newff=double(zeros(2*x,2*y));
%pic-C
for i = 1 : (x*2)
    for j = 1 : (y*2)
        newff(i,j) = double(newf(i,j))*((-1)^(i+j));
    end
end
%pic-D
ff=fft2(newff);
%pic-E %TODO
Hf = zeros(2*x,2*y);
for u = 1 :2*x
    for v = 1:2*y
        Hf(u,v) = exp((-((u-(x+1.0))^2+(v-(y+1.0))^2))/( 2 * Gauss_D^2));
    end
end
%pic-F
Gf = Hf.*ff;
%pic-G
gpf = real(ifft2(Gf)); 
for i = 1 : x
    for j = 1 : y 
        gpf(i,j) = double(gpf(i,j)*(-1)^(i+j));
    end
end
%pic-H
final=gpf(1:x,1:y);

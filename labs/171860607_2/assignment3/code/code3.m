function [final] =code3(Gauss_D)
%Gauss_D=60;
n=2;
%pic-A
f=rgb2gray(imread('455.png'));
f=mat2gray(f);
[x,y]=size(f);
subplot(331);imshow(f,[]); 
newf=zeros(2*x,2*y);
newf(1:x,1:y)=f;
newff=double(zeros(2*x,2*y));
%pic-C
for i = 1 : (x*2)
    for j = 1 : (y*2)
        newff(i,j) = double(newf(i,j))*((-1)^(i+j));
    end
end
subplot(333);imshow(newff,[]);
%pic-D
ff=fft2(newff);
%pic-E %TODO
Hf = zeros(2*x,2*y);
for u = 1 :2*x
    for v = 1:2*y
        %巴特沃斯高通滤波器为 D0./D,巴特沃斯低通滤波器为 D./D0
        Hf(u,v) = 1./(1+(Gauss_D./sqrt(((u-(x+1.0))^2+(v-(y+1.0))^2))).^(2*n));
        %H=1./(1+(D./D0).^(2*n));              %设计巴特沃斯低通滤波器
        
        %Hf(u,v) = exp((-((u-(x+1.0))^2+(v-(y+1.0))^2))/( 2 * Gauss_D^2));%高斯低通滤波器
        %Hf(u,v) = 1.0-exp((-((u-(x+1.0))^2+(v-(y+1.0))^2))/( 2 * Gauss_D^2)); %高斯高通滤波器
    end
end
%pic-F
Gf = Hf.*ff;
%pic-G
gpf=ifft2(Gf);
gpf = real(gpf); 
for i = 1 : x
    for j = 1 : y 
        gpf(i,j) = gpf(i,j)*(-1)^(i+j);
    end
end
%pic-H
final=gpf(1:x,1:y);

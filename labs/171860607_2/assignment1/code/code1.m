%function [final] =code1 (Gauss_D)
Gauss_D=40;
%pic-A
f=imread('436.tif');
f=mat2gray(f);
[x,y]=size(f);
subplot(331);%imshow(f,[]); 
imshow(im2uint8(mat2gray(log(abs(f)+1))),[]);title('A');
%pic-B
newf=zeros(2*x,2*y);
newf(1:x,1:y)=f;
subplot(332);imshow(newf,[]);title('B'); 
newff=double(zeros(2*x,2*y));
%pic-C
for i = 1 : (x*2)
    for j = 1 : (y*2)
        newff(i,j) = double(newf(i,j))*((-1)^(i+j));
    end
end
subplot(333);imshow(newff,[]);title('C');
%pic-D
ff=fft2(newff);
A1=log(abs(ff)+1);
subplot(334);imshow(A1,[]);title('D');
%pic-E 
Hf = zeros(2*x,2*y);
for u = 1 :2*x
    for v = 1:2*y
        Hf(u,v) = exp((-((u-(x+1.0))^2+(v-(y+1.0))^2))/( 2 * Gauss_D^2));
    end
end
subplot(335);imshow(Hf,[]);title('E');
%pic-F
Gf = Hf.*ff;
A2=log(abs(Gf)+1);
subplot(336);imshow(A2,[]);title('F');
%pic-G
gpf = real(ifft2(Gf)); 
for i = 1 : x
    for j = 1 : y 
        gpf(i,j) = double(gpf(i,j)*(-1)^(i+j));
    end
end
subplot(337);imshow(gpf,[]);title('G');
%pic-H
final=gpf(1:x,1:y);
subplot(338);imshow(final,[]);title('H');


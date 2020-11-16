sobel=double([-1,0,1;-2,0,2;-1,0,1]);
[sx,sy]=size(sobel);
%% 空间域原图
f=imread('3_3.jpg');
f=mat2gray(f);
[x,y]=size(f);
subplot(321);imshow(f,[]);title('空间域原图');
%% 频率域原图
newf=zeros(2*x,2*y);
newf(1:x,1:y)=f;

newff=zeros(2*x,2*y);
for i = 1 : (x*2)
    for j = 1 : (y*2)
        newff(i,j) = double(newf(i,j))*((-1)^(i+j));
    end
end

ff=fft2(newff);
ffplot=log(abs(real(ff))+1);
subplot(322);imshow(ffplot,[]);title('频率域原图');

%% 频率域滤波

fforg=zeros(x+sx-1,y+sy-1);
fforg(1:x,1:y)=f;
for i = 1 : x+sx-1
    for j = 1 : y+sy-1
        fforg(i,j) = double(fforg(i,j))*((-1)^(i+j));
    end
end
fforg2=fft2(fforg,x+sx-1,y+sy-1);

ffsobel=zeros(x+sx-1,y+sy-1);
ffsobel((x+sx-1)/2:(x+sx-1)/2+sx-1,(y+sy-1)/2:(y+sy-1)/2+sy-1)=sobel;
for i = 1 : x+sx-1
    for j = 1 : y+sy-1
        ffsobel(i,j) = ffsobel(i,j)*((-1)^(i+j));
    end
end
fffsobel=fft2(ffsobel,x+sx-1,y+sy-1);

for i = 1 : x+sx-1
    for j = 1 : y+sy-1
        fffsobel(i,j) = fffsobel(i,j)*((-1)^(i+j));
    end
end
ffffsobel=imag(fffsobel);

subplot(323);imshow(ffffsobel,[]);title('频率域算子');

Gf = fffsobel.*fforg2;

A2=log(abs(Gf)+1);
subplot(324);imshow(A2,[]);title('频率域相乘');

gpf=ifft2(Gf);
gpfr = real(gpf); 
for i = 1 : x+sx-1
    for j = 1 : y+sy-1 
        gpf(i,j) = double(gpf(i,j))*(-1)^(i+j);
    end
end
finalff=gpf(1:x,1:y);
subplot(325);imshow(finalff,[]);title('频率域滤波结果');

%% 空间域滤波

nsf=zeros(x+2*ceil(sx/2),y+2*ceil(sy/2));
nsf(ceil(sx/2)+1:ceil(sx/2)+x,ceil(sy/2)+1:ceil(sy/2)+y)=f;%这里采用零填充
%padding填充
% for i =ceil(sx/2)+1:ceil(sx/2)+x
%     for j =1:ceil(sy/2)
%         nsf(i,j)=f(i-ceil(sx/2),1);
%     end
%     for j =ceil(sy/2)+y+1:y+2*ceil(sy/2)
%         nsf(i,j)=f(i-ceil(sx/2),y);
%     end
% end
% for j =ceil(sy/2)+1:ceil(sy/2)+y
%     for i =1:ceil(sx/2)
%         nsf(i,j)=f(1,j-ceil(sy/2));
%     end
%     for i =ceil(sx/2)+x+1:x+2*ceil(sx/2)
%         nsf(i,j)=f(y,j-ceil(sy/2));
%     end
% end
% for i =1:ceil(sx/2)
%     for j =1:ceil(sy/2)
%         nsf(i,j)=f(1,1);
%     end
% end
% for i =ceil(sx/2)+x+1:2*ceil(sx/2)+x
%     for j =1:ceil(sy/2)
%         nsf(i,j)=f(x,1);
%     end
% end
% for i =1:ceil(sx/2)
%     for j =ceil(sy/2)+y+1:2*ceil(sy/2)+y
%         nsf(i,j)=f(1,y);
%     end
% end
% for i =ceil(sx/2)+x+1:2*ceil(sx/2)+x
%     for j =ceil(sy/2)+y+1:2*ceil(sy/2)+y
%         nsf(i,j)=f(x,y);
%     end
% end 
%翻转
tsobel=zeros(sx,sy);
for i =1:sx
    for j =1:sy
        tsobel(sx-i+1,sy-j+1)=sobel(i,j);
    end
end
%卷积 方式为same，若为full或valid，只需要修改i，j范围
finalsf0=zeros(x+2*ceil(sx/2),y+2*ceil(sy/2));
for i =ceil(sx/2)+1:ceil(sx/2)+x
    for j=ceil(sy/2)+1:ceil(sy/2)+y
        sum=0;
        for k=1:sx
            for l =1:sy
                sum=sum+tsobel(k,l)*nsf(i-ceil(sx/2)+k,j-ceil(sy/2)+l);
            end
        end
        finalsf0(i,j)=sum/8;
    end
end

finalsf=finalsf0(ceil(sx/2)+1:ceil(sx/2)+x,ceil(sy/2)+1:ceil(sy/2)+y);
subplot(326);imshow(finalsf,[]);title('空间域滤波结果');

%% 统计
d=abs(mapminmax(finalsf)-mapminmax(finalff));    
max(d(:))             
min(d(:))       
a = imread('../asset/a.jpg');%读取原始图像
b = imread('../asset/b.jpg');%读取模版图像
aR = a(:,:,1);%提取原始图像R通道
aG = a(:,:,2);%提取原始图像G通道
aB = a(:,:,3);%提取原始图像B通道
bR = b(:,:,1);%提取模版图像R通道
bG = b(:,:,2);%提取模版图像G通道
bB = b(:,:,3);%提取模版图像B通道
[ax,ay]=size(aR);%计算像素点规模
[bx,by]=size(bR);
aR_hist=imhist(aR)/(ax*ay);%imshit函数返回各灰度出现次数
aG_hist=imhist(aG)/(ax*ay);%除以总像素得各灰度概率密度函数PDF
aB_hist=imhist(aB)/(ax*ay);
bR_hist=imhist(bR)/(bx*by);
bG_hist=imhist(bG)/(bx*by);
bB_hist=imhist(bB)/(bx*by);
aR_cumsum = cumsum(aR_hist);%计算累计分布函数CDF
aG_cumsum = cumsum(aG_hist);
aB_cumsum = cumsum(aB_hist);
bR_cumsum = cumsum(bR_hist);
bG_cumsum = cumsum(bG_hist);
bB_cumsum = cumsum(bB_hist);
for i=1:256 %Matlab的数组从1开始，代表i-1的灰度
%对于原始图像某一灰度，找到模版图像的对应灰度使得其累积分布最接近原始图像累积分布
%[value,index] = min(x) 返回最小值及其对应的下标
%index的下标代表原始图像的灰度-1，值代表模版图像的灰度-1
    [~, R_index(i)]=min(abs(bR_cumsum-aR_cumsum(i)));
    [~, G_index(i)]=min(abs(bG_cumsum-aG_cumsum(i)));
    [~, B_index(i)]=min(abs(bB_cumsum-aB_cumsum(i)));
end
cR=zeros(ax,ay);
cG=zeros(ax,ay);
cB=zeros(ax,ay);
for i=1:ax%进行映射
    for j=1:ay
        %index的下标代表原始图像的灰度-1，值代表模版图像的灰度-1
        cR(i,j)=R_index(aR(i,j)+1)-1;
        cG(i,j)=G_index(aG(i,j)+1)-1;
        cB(i,j)=B_index(aB(i,j)+1)-1;
    end
end
c=cat(3, cR, cG, cB);%拼接三通道
c=uint8(c);%取整
imwrite(c,'c.jpg');
%绘图
subplot(2,3,1);imshow(a);title('原始图像');
subplot(2,3,2);imshow(b);title('模版图像');
subplot(2,3,3);imshow(c);title('处理之后的图像');
subplot(2,3,4);imhist(a);title('原始图像');
subplot(2,3,5);imhist(b);title('模版图像');
subplot(2,3,6);imhist(c);title('处理之后的图像');
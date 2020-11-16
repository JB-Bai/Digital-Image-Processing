final1=code3(30);
final2=code3(60);
final3=code3(120);
subplot(142);imshow(log(abs(final1)+1),[]); title('D0=30');
subplot(143);imshow(log(abs(final2)+1),[]); title('D0=60');
subplot(144);imshow(log(abs(final3)+1),[]); title('D0=120');
f=rgb2gray(imread('455.png'));
f=mat2gray(f);
subplot(141);imshow(f,[]); title('原图');
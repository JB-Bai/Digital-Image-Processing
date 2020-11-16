final2=code4(100);
final3=code4(80);
subplot(132);imshow(final2,[]); title('D=100');
subplot(133);imshow(final3,[]); title('D=80');
f=mat2gray(imread('woman.png'));
subplot(131);imshow(f,[]); title('原图');
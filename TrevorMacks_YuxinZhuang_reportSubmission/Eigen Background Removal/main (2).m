clear all
close all
clc
%�ο��ﳤ��
%can
refer_length=1.0;

%load a2.mat  %��������

abc=imread('IMG_1152.JPG');

%��ʾ���ݣ�abc������֣���Ҫ���ݼ������ݵ����ݱ仯��
figure(1)
imshow(abc,[]);

img0=abc;

[mm,nn,kk]=size(img0);
labels=zeros(mm,nn);

%���Զ��ָ�ο���
figure(2)
imshow(img0,[]);
hold on;
title('ѡȡ�����ﱳ����')
[x,y]=ginput(20);
for l=1:length(x)
    labels(int32(y(l)),int32(x(l))) =-1;
end

figure(3)
imshow(img0,[]);
hold on;
title('ѡȡ������ǰ����')
[x,y]=ginput(20);
for l=1:length(x)
    labels(int32(y(l)),int32(x(l))) =1;
end

%-- For segmentation
[labels_out_refer, strengths] = growcut(img0,labels);

figure
imshow(labels_out_refer,[]);

%���Զ��ָ������
figure(4)
imshow(img0,[]);
hold on;
title('ѡȡ�����ﱳ����')
[x,y]=ginput(20);
for l=1:length(x)
    labels(int32(y(l)),int32(x(l))) =-1;
end

figure(5)
imshow(img0,[]);
hold on;
title('ѡȡ��������ǰ����')
[x,y]=ginput(20);
for l=1:length(x)
    labels(int32(y(l)),int32(x(l))) =1;
end

%-- For segmentation
[labels_out_meter, strengths] = growcut(img0,labels);
figure(1)
imshow(labels_out_meter,[])
vp=0;
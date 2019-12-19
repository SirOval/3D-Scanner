clear all
close all
clc
%参考物长度
%can
refer_length=1.0;

%load a2.mat  %加载数据

abc=imread('IMG_1152.JPG');

%显示数据，abc这个名字，需要根据加载数据的内容变化的
figure(1)
imshow(abc,[]);

img0=abc;

[mm,nn,kk]=size(img0);
labels=zeros(mm,nn);

%半自动分割参考物
figure(2)
imshow(img0,[]);
hold on;
title('选取参照物背景点')
[x,y]=ginput(20);
for l=1:length(x)
    labels(int32(y(l)),int32(x(l))) =-1;
end

figure(3)
imshow(img0,[]);
hold on;
title('选取参照物前景点')
[x,y]=ginput(20);
for l=1:length(x)
    labels(int32(y(l)),int32(x(l))) =1;
end

%-- For segmentation
[labels_out_refer, strengths] = growcut(img0,labels);

figure
imshow(labels_out_refer,[]);

%半自动分割测量物
figure(4)
imshow(img0,[]);
hold on;
title('选取测量物背景点')
[x,y]=ginput(20);
for l=1:length(x)
    labels(int32(y(l)),int32(x(l))) =-1;
end

figure(5)
imshow(img0,[]);
hold on;
title('选取测量物体前景点')
[x,y]=ginput(20);
for l=1:length(x)
    labels(int32(y(l)),int32(x(l))) =1;
end

%-- For segmentation
[labels_out_meter, strengths] = growcut(img0,labels);
figure(1)
imshow(labels_out_meter,[])
vp=0;
clear   all
close  all
clc

subpath='新的dataset\';
addpath(subpath);
addpath('Ncut_9\');

dirOutput=dir(fullfile(subpath,'*.jpg'));%如果存在不同类型的文件，用‘*’读取所有，如果读取特定类型文件，'.'加上文件类型，例如用‘.jpg’
fileNames={dirOutput.name}';

for l=1:length(fileNames)
    tname=fileNames{l};
    I=imread(tname);
    %方法1,canny算子
    %I_edge=edge(I,'canny',[0.01,0.1],5.0)
    %图像缩小
    [m,n,k]=size(I);    
    I_new(:,:,1)=imresize(I(:,:,1),[512,512]);
    I_new(:,:,2)=imresize(I(:,:,2),[512,512]);
    I_new(:,:,3)=imresize(I(:,:,3),[512,512]);
    %方法2,模糊C均值聚类和区域的处理
%     a=I_new(:,:,1);
%     b=I_new(:,:,2);
%     c=I_new(:,:,3);
%     datas=[a(:),b(:),c(:)];
%     nlabel=3;
% %     options = [2;100;1e-5;1]; 
% %     [center, U, obj_fcn] = fcm(double(datas), nlabel, options);
% %     [iv,ip]=max(U) ;
% %     id=ip;
% %     SegLabel=reshape(id,512,512);
% %     labels=zeros(512,512);
% %     for l=1:nlabel
% %         l_val=max(labels(:));
% %         bw1=SegLabel==l;
% %         bw1=imclearborder(bw1,8);
% %         bw1 = bwareaopen(bw1,11,8);
% %         bw=bwlabel(bw1);
% %         bw(bw>0)=bw(bw>0)+l_val;
% %         labels=labels+bw;
% %     end
% %     
% %     BW=zeros(512,512);
% %     B_back=zeros(512,512);
% %    for l=1:max(labels(:))
% %        [ix,iy]=find(labels==l);
% %        if length(ix)>500
% %            span_x=max(ix)-min(ix);
% %            span_y=max(iy)-min(iy);
% %            if span_x>span_y
% %                re=span_x/span_y;
% %            else
% %                re=span_y/span_x;
% %            end
% %            if re<1.3
% %                BW=BW+double(labels==l);
% %            else
% %                B_back=B_back+double(labels==l);
% %            end
% %        end
% %    end
% %    
% %    back=labels==0;
% %    se1=strel('disk',10);%这里是创建一个半径为5的平坦型圆盘结构元素
% %    back=imerode(back,se1);
% %    BW=imdilate(BW,se1);
% %    
% %    labels=zeros(512,512);
% %    labels(BW>0)=1;
% %    labels(back>0)=-1;
% %    
% %    [labels_out_refer, strengths] = growcut(I_new,labels);
%    I=double(I_new);
% 
% 
%    figure(1)
%    imshow(I_new,[]);
%    figure(2)
%    imshow(BW,[]);
%    figure(3)
%    imshow(B_back,[]);
%    figure(4)
%    imshow(labels_out_refer,[]);
%方法3，超像素分割和谱聚类结果
img=I_new;
img_size = size(img);   %三个元素：图像的高、图像的宽、图像的通道数
%设定超像素个数
K = 50;
%设定超像素紧凑系数
m_compactness = 20;

%转换到LAB色彩空间
cform = makecform('srgb2lab');       %rgb空间转换成lab空间 matlab自带的用法
img_Lab = applycform(img, cform);    %rgb转换成lab空间
%img_Lab = RGB2Lab(img);  %不好用不知道为什么
imshow(img_Lab)
% %检测边缘
% img_edge = DetectLabEdge(img_Lab);
% imshow(img_edge)
%得到超像素的LABXY种子点信息
img_sz = img_size(1)*img_size(2);
superpixel_sz = img_sz/K;
STEP = uint32(sqrt(superpixel_sz));
xstrips = uint32(img_size(2)/STEP);
ystrips = uint32(img_size(1)/STEP);
xstrips_adderr = double(img_size(2))/double(xstrips);
ystrips_adderr = double(img_size(1))/double(ystrips);
numseeds = xstrips*ystrips;
%种子点xy信息初始值为晶格中心亚像素坐标
%种子点Lab颜色信息为对应点最接近像素点的颜色通道值
kseedsx = zeros(numseeds, 1);
kseedsy = zeros(numseeds, 1);
kseedsl = zeros(numseeds, 1);
kseedsa = zeros(numseeds, 1);
kseedsb = zeros(numseeds, 1);
n = 1;
for y = 1: ystrips
    for x = 1: xstrips 
        kseedsx(n, 1) = (double(x)-0.5)*xstrips_adderr;
        kseedsy(n, 1) = (double(y)-0.5)*ystrips_adderr;
        kseedsl(n, 1) = img_Lab(fix(kseedsy(n, 1)), fix(kseedsx(n, 1)), 1);
        kseedsa(n, 1) = img_Lab(fix(kseedsy(n, 1)), fix(kseedsx(n, 1)), 2);
        kseedsb(n, 1) = img_Lab(fix(kseedsy(n, 1)), fix(kseedsx(n, 1)), 3);
        n = n+1;
    end
end
n = 1;
%根据种子点计算超像素分区
klabels = PerformSuperpixelSLIC(img_Lab, kseedsl, kseedsa, kseedsb, kseedsx, kseedsy, STEP, m_compactness);
img_Contours = DrawContoursAroundSegments_EX(img, klabels);
figure(1)
imshow(img_Contours)
title('超像素分割结果')
% %合并小的分区
% nlabels = EnforceLabelConnectivity(img_Lab, klabels, K); 
% nlabels=verify_vv(nlabels);
% klabels=nlabels;
% % %根据得到的分区标签找到边界
% % img_ContoursEX = DrawContoursAroundSegments_EX(img, nlabels);
% % imshow(img_ContoursEX)
t=20;  %文中参数5-峰值谱聚类
klabelsnum=max(klabels(:));  %类别个数
Limg=img_Lab(:,:,1);
Aimg=img_Lab(:,:,2);
Bimg=img_Lab(:,:,3);
m=100;
SW=sqrt(img_size(1)*img_size(2))/m;  %文中参数
Sm=zeros(klabelsnum,klabelsnum); %存储两个类别之间距离
klabelval=[];  %计算每个超像素类别的特征
for l=1:klabelsnum
    limg=klabels==l;
    Lvals=Limg(limg>0);
    lval=mean(Lvals(:));
    Avals=Aimg(limg>0);
    Aval=mean(Avals(:)); 
    Bvals=Bimg(limg>0);
    Bval=mean(Bvals(:));
    [ix,iy]=find(limg>0);
    klabelval=[klabelval;[lval,Aval,Bval,mean(ix)/SW,mean(iy)/SW]];
end
S=[];  %对于一个label求最近邻的几个块
Ssigma=[];
%计算超像素块之间的距离
for i=1:size(klabelval,1)
    for j=1:size(klabelval,1)
        if i==j
            Sm(i,j)=1e5;
        else
            Sm(i,j)=norm(klabelval(i,:)-klabelval(j,:));
        end       
    end
    [vv,vindx]=sort(Sm(i,:));  %距离有小到近排序
    S=[S;vindx(1:t)];  %t个最小值
    Ssigma=[Ssigma;std(vv(1:t))];
end
%计算相似度
D=zeros(klabelsnum,klabelsnum);
for i=1:size(S,1)
    for j=1:length(S(i,:))
        ii=i;
        jj=S(i,j);
        if ii==jj
           D(ii,jj)=0;  
        else           
           D(ii,jj)=exp(-1.0*Sm(ii,jj)*Sm(ii,jj)/(2.0*Ssigma(ii)*(Ssigma(jj))));
        end
    end
end

KK=10;   %类别为总类别的一半
C=SpectralClustering(D,int32(KK));  %谱聚类

Spectralimg=zeros(img_size(1),img_size(2));

for l=1:length(C)
   Limg=klabels==l;
   Spectralimg(Limg>0)=C(l);
   
end
Spectralimg=verify_vv(Spectralimg);

BW=zeros(512,512);
for l=1:max(Spectralimg(:))
   bw1=Spectralimg==l;
   bw1=imclearborder(bw1,8);
   [ix,iy]=find(bw1>0);
   span_x=max(ix)-min(ix);
   span_y=max(iy)-min(iy);
   if length(ix)<500
       continue;
   end
   if span_x>span_y
       ra=span_x/span_y;
   else
       ra=span_y/span_x;
   end
   if ra>2.0
       continue;
   end
   BW=BW+double(bw1);
end

BW=imfill(BW,'holes');

imLabel = bwlabel(BW);                %对各连通域进行标记
stats = regionprops(imLabel,'Area');    %求各连通域的大小
area = cat(1,stats.Area);
index = find(area == max(area));        %求最大连通域的索引
BW = ismember(imLabel,index);          %获取最大连通域图像

% se1=strel('disk',5);%这里是创建一个半径为5的平坦型圆盘结构元素
% BW=imopen(BW,se1);

figure(3)
imshow(BW,[]);
img_Contours2 = DrawContoursAroundSegments_EX(img, Spectralimg);
figure(2)
imshow(img_Contours2)
title('谱聚类结果')
    
end


vp=0;


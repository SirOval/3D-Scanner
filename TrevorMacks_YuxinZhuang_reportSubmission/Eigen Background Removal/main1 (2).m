clear   all
close  all
clc

subpath='�µ�dataset\';
addpath(subpath);
addpath('Ncut_9\');

dirOutput=dir(fullfile(subpath,'*.jpg'));%������ڲ�ͬ���͵��ļ����á�*����ȡ���У������ȡ�ض������ļ���'.'�����ļ����ͣ������á�.jpg��
fileNames={dirOutput.name}';

for l=1:length(fileNames)
    tname=fileNames{l};
    I=imread(tname);
    %����1,canny����
    %I_edge=edge(I,'canny',[0.01,0.1],5.0)
    %ͼ����С
    [m,n,k]=size(I);    
    I_new(:,:,1)=imresize(I(:,:,1),[512,512]);
    I_new(:,:,2)=imresize(I(:,:,2),[512,512]);
    I_new(:,:,3)=imresize(I(:,:,3),[512,512]);
    %����2,ģ��C��ֵ���������Ĵ���
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
% %    se1=strel('disk',10);%�����Ǵ���һ���뾶Ϊ5��ƽ̹��Բ�̽ṹԪ��
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
%����3�������طָ���׾�����
img=I_new;
img_size = size(img);   %����Ԫ�أ�ͼ��ĸߡ�ͼ��Ŀ�ͼ���ͨ����
%�趨�����ظ���
K = 50;
%�趨�����ؽ���ϵ��
m_compactness = 20;

%ת����LABɫ�ʿռ�
cform = makecform('srgb2lab');       %rgb�ռ�ת����lab�ռ� matlab�Դ����÷�
img_Lab = applycform(img, cform);    %rgbת����lab�ռ�
%img_Lab = RGB2Lab(img);  %�����ò�֪��Ϊʲô
imshow(img_Lab)
% %����Ե
% img_edge = DetectLabEdge(img_Lab);
% imshow(img_edge)
%�õ������ص�LABXY���ӵ���Ϣ
img_sz = img_size(1)*img_size(2);
superpixel_sz = img_sz/K;
STEP = uint32(sqrt(superpixel_sz));
xstrips = uint32(img_size(2)/STEP);
ystrips = uint32(img_size(1)/STEP);
xstrips_adderr = double(img_size(2))/double(xstrips);
ystrips_adderr = double(img_size(1))/double(ystrips);
numseeds = xstrips*ystrips;
%���ӵ�xy��Ϣ��ʼֵΪ������������������
%���ӵ�Lab��ɫ��ϢΪ��Ӧ����ӽ����ص����ɫͨ��ֵ
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
%�������ӵ���㳬���ط���
klabels = PerformSuperpixelSLIC(img_Lab, kseedsl, kseedsa, kseedsb, kseedsx, kseedsy, STEP, m_compactness);
img_Contours = DrawContoursAroundSegments_EX(img, klabels);
figure(1)
imshow(img_Contours)
title('�����طָ���')
% %�ϲ�С�ķ���
% nlabels = EnforceLabelConnectivity(img_Lab, klabels, K); 
% nlabels=verify_vv(nlabels);
% klabels=nlabels;
% % %���ݵõ��ķ�����ǩ�ҵ��߽�
% % img_ContoursEX = DrawContoursAroundSegments_EX(img, nlabels);
% % imshow(img_ContoursEX)
t=20;  %���в���5-��ֵ�׾���
klabelsnum=max(klabels(:));  %������
Limg=img_Lab(:,:,1);
Aimg=img_Lab(:,:,2);
Bimg=img_Lab(:,:,3);
m=100;
SW=sqrt(img_size(1)*img_size(2))/m;  %���в���
Sm=zeros(klabelsnum,klabelsnum); %�洢�������֮�����
klabelval=[];  %����ÿ����������������
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
S=[];  %����һ��label������ڵļ�����
Ssigma=[];
%���㳬���ؿ�֮��ľ���
for i=1:size(klabelval,1)
    for j=1:size(klabelval,1)
        if i==j
            Sm(i,j)=1e5;
        else
            Sm(i,j)=norm(klabelval(i,:)-klabelval(j,:));
        end       
    end
    [vv,vindx]=sort(Sm(i,:));  %������С��������
    S=[S;vindx(1:t)];  %t����Сֵ
    Ssigma=[Ssigma;std(vv(1:t))];
end
%�������ƶ�
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

KK=10;   %���Ϊ������һ��
C=SpectralClustering(D,int32(KK));  %�׾���

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

imLabel = bwlabel(BW);                %�Ը���ͨ����б��
stats = regionprops(imLabel,'Area');    %�����ͨ��Ĵ�С
area = cat(1,stats.Area);
index = find(area == max(area));        %�������ͨ�������
BW = ismember(imLabel,index);          %��ȡ�����ͨ��ͼ��

% se1=strel('disk',5);%�����Ǵ���һ���뾶Ϊ5��ƽ̹��Բ�̽ṹԪ��
% BW=imopen(BW,se1);

figure(3)
imshow(BW,[]);
img_Contours2 = DrawContoursAroundSegments_EX(img, Spectralimg);
figure(2)
imshow(img_Contours2)
title('�׾�����')
    
end


vp=0;


%preprocessing
close all
input=imread('input4.jpg');
I= rgb2gray(input) ;
figure, imshow(I);
title( 'MRI Image' ) ;
 [m,n]=size(I) ;
% figure;
% imhist(I);
%I=histeq(I);   %improved contrast
%figure;
%imshow(I);

%Sharpening Image using High Pass Filter
%Disadvantage : Sensitive to Noise

hpf =[0 -1 0;-1 4 -1;0 -1 0];

y_filt =   imfilter(I, hpf, 'same');
im=y_filt+I;   
figure;
imshow((im));
title('High Pass Filtering');

%Median Filtering for Noise Removal

I_fil=medfilt2(im,[5,5]);		%using median filter for salt & pepper
figure,imshow(I_fil)
title('filtered')
I_filMSE=immse(I_fil,I);
%


%SEGMENTATION - THRESHOLD
%THRESHOLD VALUES SELECTED AFTER SEEING THE HISTOGRAM OF INPUT DATA SETS 

I_bin=I_fil;
for i=1:m
    for j=1:n
    if (150<=I_fil(i,j))&&(I_fil(i,j)<=255) 
        I_bin(i,j)=255;
   
    else 
        I_bin(i,j)=0;
    end
    end
end

figure, imshow(I_bin);
title('segmented')
%%%%%%%%%%%%%




%TOP HAT FILTERING - difference between the original image and it's opening
%opening : erosion followed by dilation 

struct_el=strel('disk', 40);    %creates an SE
im_thr1 = imerode(I_bin,struct_el);
im_thr2= imdilate(im_thr1,struct_el);
im_thr= I_bin-im_thr2;
figure
imshow(im_thr,[])
title('top hat')
%{
figure
bw=im2bw(im_thr,0.6);
label=bwlabel(bw);
%Properties
stats=regionprops(label,'Solidity','Area');

density=[stats.Solidity];
area=[stats.Area];

High_Density_Area=density > 0.5; % reduce to detect small or early stage tumors
 
mar=max(area(High_Density_Area));
tumor_label=find(area==mar);
tumor=ismember(label,tumor_label);
 
SE=strel('disk',5);
tumor=imdilate(tumor,SE);
imshow(tumor)

[B,L]=bwboundaries(tumor,8,'noholes');
imshow(I)
hold on
for i=length(B)
    plot(B{i}(:,2),B{i}(:,1),'r','linewidth',2)  %For boundary around the tumor
end
title('Brain Tumor Detected')

%}

%%%OTSU

%{
figure
imshow(er_img,[])
title('eroded')
figure
imshow(dil_img,[])
title('dilated')

%}


%%% Clustering
 [rand]= adap_clust(I_bin);

title('Region maxima');
figure
imshow(rand)
title('Brain Tumor Detected')

bw=im2bw(rand,0.6);
label=bwlabel(bw);
%Properties
stats=regionprops(label,'Solidity','Area');
area=[stats.Area];
mar=max(area([stats.Solidity]>0.4));
tumor_label=find(area==mar);
tumor=ismember(label,tumor_label);
 
SE=strel('disk',5);
tumor=imdilate(tumor,SE);
imshow(tumor)

[B,L]=bwboundaries(tumor,8,'noholes');
imshow(rand)
hold on
for i=length(B)
    plot(B{i}(:,2),B{i}(:,1),'r','linewidth',2)  %For boundary around the tumor
end
title('Brain Tumor Detected')


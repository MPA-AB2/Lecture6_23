clc,clear all,close all
nazev='V:\main\Lecture6_23\Ants\00000';
pripona='.jpg';
pocet_obr=1;%215;

for i=1:pocet_obr
    if i<10
        cislo=['00',num2str(i)];
    elseif i<100
        cislo=['0',num2str(i)];
    else
        cislo=num2str(i);
    end
    cesta=[nazev,cislo,pripona];
    img=rgb2gray(imread(cesta));
    thr=mean(mean(img))/3;
    img_filt=zeros(size(img));
    img_filt(img<=thr)=1;
    
    [ants,M]=kmeans(img_filt,7);
    %ants(ants==1)=[];
    figure
    imshow(img_filt)
    hold on
    plot(ants,'r*')
end
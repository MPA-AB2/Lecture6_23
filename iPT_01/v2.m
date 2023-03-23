%clear all;

addpath(genpath('archive'))



imds = imageDatastore('train','IncludeSubfolders',true);
imageLabeler
save gTruth2


blds = boxLabelDatastore(gTruth2(:,2));
ds = combine(imds, blds);


net = load('yolov2VehicleDetector.mat');
lgraph = net.lgraph
lgraph.Layers


options = trainingOptions('sgdm',...
          'InitialLearnRate',0.001,...
          'Verbose',true,...
          'MiniBatchSize',2,...
          'MaxEpochs',30,...
          'Shuffle','never',...
          'VerboseFrequency',2,...
          'CheckpointPath',tempdir);

[detector,info] = trainYOLOv2ObjectDetector(ds,lgraph,options);

detector
save detector
%%
%load('detector.mat')
addpath(genpath('Ants'))
num=1024/128;
trajectories=cell(1,6);
for j=1:6
    trajectories{1,j}=zeros(215,2);
end
%imnum=1;

for imnum=1:215
    %imname=['00000'];
    if imnum<10
        imname=['0000000' num2str(imnum) '.jpg'];
    elseif imnum>=10 && imnum<100
        imname=['000000' num2str(imnum)  '.jpg'];
    elseif imnum>=100
         imname=['00000' num2str(imnum)  '.jpg'];
    end
    img = imread(imname);
    img = imresize(img, [128 128]);
    %im_up=imresize(img,[1024 1024]);
    [bboxes,scores] = detect(detector,img); %samotna detekce
   
    sizebbox=size(bboxes,1);
    xmids=[];
    ymids=[];
    for i=1:sizebbox
    
    
    xmid=bboxes(i,1)+floor(bboxes(i,3)/2);
    ymid=bboxes(i,2)+floor(bboxes(i,4)/2);
    xmid=xmid*num;
    ymid=ymid*num;
    
    xmids=[xmids xmid];
    ymids=[ymids ymid];
    end


    vx=[];
    vy=[];
    
    imnumpom=imnum;

    if imnumpom==1
        for i=1:6
         trajectories{1,i}(imnum,1)=xmid;
         trajectories{1,i}(imnum,2)=ymid;
        end
    end
    if imnumpom>1
       % imnumpom=2;
    
        for i=1:6
            vx=[vx trajectories{1,i}(imnumpom-1,1)]; 
            vy=[vy trajectories{1,i}(imnumpom-1,2)];
        end
    
        vect1=zeros(6,2);
        vect2=zeros(6,2);
        vect1(:,1)=vx';
        vect2(:,2)=vy';
        distvect=zeros(6,6);
        for k_up=1:size(vx(2))                            %prepise k nejblizsim mravencum nalezene pozice
            for k=1:size(xmids(2))
                pom=[vx(k_up) vy(k_up);xmids(k) ymids(k)];
                dist=pdist(pom,'euclidean');
                distvect(k_up,k)=dist;
           
            end
        end
    
        for pom=1:6
        value=max(max(distvect));
       [Idistvect,Jdistvect]=find(distvect==value,1);
       
    
        trajectories{1,Idistvect}(imnum,1)=xmids(Jdistvect);
        trajectories{1,Idistvect}(imnum,2)=ymids(Jdistvect);
    
        distvect(Idistvect,:)=0;
    end

    end

%     trajectories{1,i}(imnum,1)=xmid;
%     trajectories{1,i}(imnum,2)=ymid;

   

%     if xmid==0
%         xmid=NaN;
%     end
%     if ymid==0
%         ymid=NaN;
%     end

   
    
    

end

if(~isempty(bboxes))
    img = insertObjectAnnotation(img,'rectangle',bboxes,scores);
end
figure
imshow(img)

figure
img_up = imread(imname);
imshow(im_up)
hold on
plot(trajectories{1,1}(:,1),trajectories{1,1}(:,2))
plot(trajectories{1,2}(:,1),trajectories{1,2}(:,2))
plot(trajectories{1,3}(:,1),trajectories{1,3}(:,2))
plot(trajectories{1,4}(:,1),trajectories{1,4}(:,2))
plot(trajectories{1,5}(:,1),trajectories{1,5}(:,2))
plot(trajectories{1,6}(:,1),trajectories{1,6}(:,2))




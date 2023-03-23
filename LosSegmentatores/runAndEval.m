% MPA-AB2 - Lecture 6
clear,close,clc
%% run our fcn
pathToIm = "V:\MPA-AB2\Lecture6_23\Ants";
trajectories = ant_tracking(pathToIm);
%% evaluation
[errorTracking] = EvaluationAnts(trajectories);
%% plot
figure
imshow(imread("V:\MPA-AB2\Lecture6_23\Ants\00000001.jpg"))
hold on
for i = 1:6
    scatter(trajectories{i}(1,1),trajectories{i}(1,2),"green","filled")
    plot(trajectories{i}(:,1),trajectories{i}(:,2))
end
hold off
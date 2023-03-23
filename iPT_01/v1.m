clear all;  

net = mobilenetv2('Weights','none');
%lgraph = layerGraph(net);
lgraph=net;
imageInputSize = [300 300 3];

imgLayer = imageInputLayer(imageInputSize,"Name","input_1")

lgraph = replaceLayer(lgraph,"input_1",imgLayer);


analyzeNetwork(lgraph)

detector = yolov2ObjectDetector(lgraph);


close all;
clear all;
clc;

addpath('dataPieton');
addpath('img');

%% 
N = 10;
for n = 1:N
    
    pietName = ['pieton_',num2str(n,'%0.2d'),'.jpeg'];
    fondName = ['fond_',num2str(n,'%0.2d'),'.jpeg'];

    pietData(n,:,:) = imread(pietName);
    fondData(n,:,:) = imread(fondName);
end

dataRef = [pietData fondData];
classType = [ones(size(pietData,1),1);zeros(size(fondData,1),1)];

%% Sobel
Gx = [-1 0 1;
     -2 0 2;
     -1 0 1]
Gy = Gx';
H = 10;
for i = 1:N
    Gx_piet = filter2(Gx,squeeze(pietData(i,:,:)));
    Gy_piet = filter2(Gy,squeeze(pietData(i,:,:)));
    Gx_fond = filter2(Gx,squeeze(fondData(i,:,:)));
    Gy_fond = filter2(Gy,squeeze(fondData(i,:,:)));
    dataSobelPiet = squeeze(sqrt(Gy_piet.^2 + Gx_piet.^2));
    dataSobelFond = squeeze(sqrt(Gy_fond.^2 + Gx_fond.^2));
    hPiet = histogram(dataSobelPiet,H);
    dataHistPiet{i} = hPiet.Values;
    hFond = histogram(dataSobelFond,H);
    dataHistFond{i} = hFond.Values;
    close
end

dataHistArray = vec2mat(cell2mat([dataHistPiet dataHistFond]),H);

%% Apprentissage

svmStruct = svmtrain(dataHistArray,classType,'kernel_function','quadratic');


%% Test avec vecteur d'apprentissage 
% clear dataAlea
% nb = 20;
% indexAlea = ceil(rand(nb,1)*nb);
% dataAlea = dataHistArray(indexAlea,:); 
% 
% rep = svmclassify(svmStruct,dataAlea);
% stem(indexAlea,rep);

%% Load data découées
N = 10;
for n = 0:N-1
    
    pietName = ['pieton_',num2str(20+n,'%0.2d'),'.jpeg'];
    fondName = ['fond_',num2str(20+n,'%0.2d'),'.jpeg'];

    pietDataTest(n+1,:,:) = imread(pietName);
    fondDataTest(n+1,:,:) = imread(fondName);
end

dataTest = [pietDataTest;fondDataTest];
classTypeTest = [ones(size(pietDataTest,1),1);zeros(size(fondDataTest,1),1)];

Gx = [-1 0 1;
     -2 0 2;
     -1 0 1]
Gy = Gx';
H = 10;
nb = 20;
indexAlea = ceil(rand(nb,1)*nb);

dataTest2 = dataTest(indexAlea,:,:);

for i = 1:size(dataTest2,1)
    Gx_img = filter2(Gx,squeeze(dataTest2(i,:,:)));
    Gy_img = filter2(Gy,squeeze(dataTest2(i,:,:)));
    dataSobel = squeeze(sqrt(Gy_img.^2 + Gx_img.^2));
    h = histogram(dataSobel,H);
    rep = svmclassify(svmStruct,h.Values);
    if rep == 1
        disp('pieton');    
    else
        disp('fond');
    end
    imagesc(squeeze(dataTest2(i,:,:)));colormap(gray);
    pause
    
    close
end
disp('Fin');
pause

%% Load data img

addpath('src');

imgName = ['detection_',num2str(200,'%0.4d'),'.jpeg'];
img = rgb2gray(imread(imgName));

wL = 100;
wH = 40;
dec = 10;
imgDecoupe = decoupe(img,wL,wH,dec);

% for i=1:size(imgDecoupe,3)
%     imagesc(imgDecoupe(:,:,i));colormap(gray);
%     pause
% end


nb = size(imgDecoupe,3);
indexAlea = ceil(rand(nb,1)*nb);


dataTest2 = imgDecoupe(:,:,indexAlea);

for i = 1:size(dataTest2,3)
    Gx_img = filter2(Gx,squeeze(dataTest2(:,:,i)));
    Gy_img = filter2(Gy,squeeze(dataTest2(:,:,i)));
    dataSobel = squeeze(sqrt(Gy_img.^2 + Gx_img.^2));
    h = histogram(dataSobel,H);
    rep = svmclassify(svmStruct,h.Values);
    if rep == 1
        disp('pieton');    
    else
        disp('fond');
    end
    imagesc(squeeze(dataTest2(:,:,i)));colormap(gray);
    pause
    
    close
end
disp('Fin');
pause

%% 
% num = 100000;
% nImg = 1000;
% for i = 1:size(imgDecoupe,3)
%     i
%     
%     Gx_img = filter2(Gx,squeeze(imgDecoupe(:,:,i)));
%     Gy_img = filter2(Gy,squeeze(imgDecoupe(:,:,i)));
%     dataSobel = squeeze(sqrt(Gy_img.^2 + Gx_img.^2));
%     h = histogram(dataSobel,H);
%     dataHistImg{i} = h.Values;
% 
%     close
% end
% 
% dataHistArrayImg = vec2mat(cell2mat(dataHistImg),H);
% 
% %%
% rep = svmclassify(svmStruct,dataHistArrayImg);
% repMat = vec2mat(rep,(480-40)/10);
% subplot(1,2,1);imagesc(repMat);colormap(gray);axis equal;
% subplot(1,2,2);imagesc(img);colormap(gray);axis equal;
% 
% clc
